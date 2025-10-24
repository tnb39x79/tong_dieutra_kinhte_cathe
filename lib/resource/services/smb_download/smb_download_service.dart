import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:smb_connect/smb_connect.dart';

/// SMB downloading state
enum SmbTaskState { downloading, paused, success, canceled, error }

/// Event representing current progress or error and the current state for SMB downloads
class SmbTaskEvent {
  const SmbTaskEvent({
    required this.state,
    this.bytesReceived,
    this.totalBytes,
    this.error,
  });

  final SmbTaskState state;
  final int? bytesReceived;
  final int? totalBytes;
  final Object? error;

  @override
  String toString() => "SmbTaskEvent ($state)";
}

/// SMB Download Service for downloading files from SMB shares
/// 
/// This service handles downloading files from SMB protocol URLs with authentication
/// and provides progress tracking similar to the HTTP DownloadTaskService.
class SmbDownloadService {
  SmbDownloadService._({
    required this.smbUrl,
    required this.file,
    required this.username,
    required this.password,
    required this.deleteOnCancel,
    required this.deleteOnError,
  });

  final String smbUrl;
  final File file;
  final String username;
  final String password;
  final bool deleteOnCancel;
  final bool deleteOnError;

  /// Events stream, used to listen for downloading state changes
  Stream<SmbTaskEvent> get events => _events.stream;

  /// Latest event
  SmbTaskEvent? get event => _event;

  /// Static method to start SMB file downloading
  /// 
  /// * [smbUrl] is the SMB URL (e.g., smb://server/share/path/file.zip)
  /// * [file] is download destination path, file will be created while downloading
  /// * [username] and [password] are SMB authentication credentials
  /// * [deleteOnCancel] specify if file should be deleted after download is cancelled
  /// * [deleteOnError] specify if file should be deleted when error is raised
  static Future<SmbDownloadService> download(
    String smbUrl, {
    required File file,
    required String username,
    required String password,
    bool deleteOnCancel = true,
    bool deleteOnError = false,
  }) async {
    final task = SmbDownloadService._(
      smbUrl: smbUrl,
      file: file,
      username: username,
      password: password,
      deleteOnCancel: deleteOnCancel,
      deleteOnError: deleteOnError,
    );
    await task.resume();
    return task;
  }

  /// Pause file downloading (not implemented for SMB - will cancel instead)
  Future<bool> pause() async {
    if (_doneOrCancelled || !_downloading) return false;
    return await cancel();
  }

  /// Resume file downloading
  Future<bool> resume() async {
    if (_doneOrCancelled || _downloading) return false;
    _addEvent(SmbTaskEvent(
      state: SmbTaskState.downloading,
      bytesReceived: _bytesReceived,
      totalBytes: _totalBytes,
    ));
    _download();
    return true;
  }

  /// Cancel the downloading
  Future<bool> cancel() async {
    if (_doneOrCancelled) return false;
    _isCancelled = true;
    _addEvent(SmbTaskEvent(
      state: SmbTaskState.canceled,
      bytesReceived: _bytesReceived,
      totalBytes: _totalBytes,
    ));
    _dispose(SmbTaskState.canceled);
    return true;
  }

  // Events stream
  final StreamController<SmbTaskEvent> _events = StreamController<SmbTaskEvent>();
  SmbTaskEvent? _event;

  int _bytesReceived = 0;
  int _totalBytes = -1;
  bool _isCancelled = false;

  // Internal shortcuts
  bool get _cancelled => _isCancelled || event?.state == SmbTaskState.canceled;
  bool get _downloading => event?.state == SmbTaskState.downloading;
  bool get _done => event?.state == SmbTaskState.success;
  bool get _doneOrCancelled => _done || _cancelled;

  /// Add new event to stream
  void _addEvent(SmbTaskEvent event) {
    _event = event;
    if (!_events.isClosed) {
      _events.add(event);
    }
  }

  /// Clean up
  Future<void> _dispose(SmbTaskState state) async {
    if (state == SmbTaskState.canceled) {
      if (deleteOnCancel && await file.exists()) {
        await file.delete();
      }
      _events.close();
    } else if (state == SmbTaskState.error) {
      if (deleteOnError && await file.exists()) {
        await file.delete();
      }
      _events.close();
    } else if (state == SmbTaskState.success) {
      _events.close();
    }
  }

  /// Parse SMB URL to extract server, share, and file path
  Map<String, String> _parseSmbUrl(String smbUrl) {
    // Expected format: smb://server/share/path/to/file.ext
    final uri = Uri.parse(smbUrl);
    
    if (uri.scheme.toLowerCase() != 'smb') {
      throw ArgumentError('URL must use SMB protocol: $smbUrl');
    }

    final host = uri.host;
    final pathSegments = uri.pathSegments;
    
    if (pathSegments.isEmpty) {
      throw ArgumentError('SMB URL must include share and file path: $smbUrl');
    }

    final share = pathSegments.first;
    final filePath = pathSegments.skip(1).join('/');

    return {
      'host': host,
      'share': share,
      'filePath': filePath,
    };
  }

  /// Download function using SMB protocol
  Future<void> _download() async {
    try {
      // Parse SMB URL
      final urlParts = _parseSmbUrl(smbUrl);
      final host = urlParts['host']!;
      final share = urlParts['share']!;
      final filePath = urlParts['filePath']!;

      debugPrint('SMB Download - Host: $host, Share: $share, File: $filePath');

      // Create parent directory if it doesn't exist
      final parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true);
      }

      // Delete existing file if it exists
      if (await file.exists()) {
        await file.delete();
      }

      // Create the file
      await file.create();

      // Connect to SMB share
      debugPrint('Connecting to SMB server: $host');
      final smbClient = await SmbConnect.connectAuth(
        host: host,
        domain: "",
        username: username,
        password: password,
      );

      debugPrint('Connected to SMB server, accessing file: /$share/$filePath');

      // Download file with progress tracking
      await _downloadFileWithProgress(smbClient, share, filePath);

      // Disconnect from SMB
      await smbClient.close();

      if (!_cancelled) {
        _addEvent(const SmbTaskEvent(state: SmbTaskState.success));
        _dispose(SmbTaskState.success);
      }

    } catch (error) {
      debugPrint('SMB Download error: $error');
      _addEvent(SmbTaskEvent(state: SmbTaskState.error, error: error));
      _dispose(SmbTaskState.error);
    }
  }

  /// Download file with progress tracking
  Future<void> _downloadFileWithProgress(
    SmbConnect smbClient,
    String share,
    String filePath,
  ) async {
    try {
      // Get SMB file reference
      final smbFilePath = '/$share/$filePath';
      final smbFile = await smbClient.file(smbFilePath);

      // Get file size for progress tracking
      _totalBytes = smbFile.size;
      debugPrint('SMB file size: $_totalBytes bytes');

      // Open read stream from SMB file
      final readStream = await smbClient.openRead(smbFile);
      final sink = await file.open(mode: FileMode.writeOnly);

      try {
        await for (final chunk in readStream) {
          if (_cancelled) {
            break;
          }

          // Write chunk to local file
          await sink.writeFrom(chunk);

          // Update progress
          _bytesReceived += chunk.length;

          if (!_cancelled) {
            _addEvent(SmbTaskEvent(
              state: SmbTaskState.downloading,
              bytesReceived: _bytesReceived,
              totalBytes: _totalBytes,
            ));
          }
        }
      } finally {
        await sink.close();
      }

    } catch (error) {
      debugPrint('Error during SMB file download: $error');
      rethrow;
    }
  }
}
