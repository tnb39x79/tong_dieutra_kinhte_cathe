/// Simple enums for Vietnamese Speech-to-Text service

/// Service state
enum STTServiceState {
  uninitialized,
  initializing,
  ready,
  recording,
  processing,
  error,
  disposed;

  bool get canStartRecording => this == STTServiceState.ready;

  bool get canStopRecording => this == STTServiceState.recording;

  bool get isOperational => [ready, recording, processing].contains(this);
}
