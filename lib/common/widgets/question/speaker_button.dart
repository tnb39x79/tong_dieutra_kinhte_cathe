import 'package:flutter/material.dart';  

class SpeakerButton extends StatelessWidget {
  const SpeakerButton({
    super.key,
    required this.text,
    this.size = 20,
    this.color,
    this.padding = const EdgeInsets.all(8.0),
    this.onSpeakStart,
    this.onSpeakComplete,
    this.onError,
  });

  /// The text to be spoken
  final String text;

  /// Size of the speaker icon
  final double size;

  /// Color of the speaker icon (defaults to primaryColor)
  final Color? color;

  /// Padding around the icon
  final EdgeInsetsGeometry padding;

  /// Optional callback when speaking starts
  final VoidCallback? onSpeakStart;

  /// Optional callback when speaking completes
  final VoidCallback? onSpeakComplete;

  /// Optional callback when error occurs
  final void Function(String error)? onError;

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    // return InkWell(
    //   onTap: _onSpeakerTap,
    //   borderRadius: BorderRadius.circular(20),
    //   child: Container(
    //     padding: padding,
    //     child: Icon(
    //       Icons.volume_up,
    //       size: size,
    //       color: color ?? primaryColor,
    //     ),
    //   ),
    // );
  }

  /// Handle speaker icon tap to speak the text
  Future<void> _onSpeakerTap() async {
    // try {
    //   if (text.trim().isEmpty) {
    //     const errorMsg = 'No text to speak';
    //     logWarning(errorMsg, name: 'SpeakerButton');
    //     onError?.call(errorMsg);
    //     return;
    //   }
    //
    //   // Get the TTS service
    //   if (!Get.isRegistered<VietnameseTtsService>()) {
    //     const errorMsg = 'Vietnamese TTS service not registered';
    //     logError(errorMsg, name: 'SpeakerButton');
    //     onError?.call(errorMsg);
    //     return;
    //   }
    //
    //   final ttsService = Get.find<VietnameseTtsService>();
    //
    //   if (!ttsService.isInitialized) {
    //     const errorMsg = 'TTS service not initialized yet';
    //     logWarning(errorMsg, name: 'SpeakerButton');
    //     onError?.call(errorMsg);
    //     return;
    //   }
    //
    //   // Clean the text for better TTS pronunciation
    //
    //   logInfo('Speaking text: "$text"', name: 'SpeakerButton');
    //
    //   // Notify speaking start
    //   onSpeakStart?.call();
    //
    //   await ttsService.speak(text);
    //
    //   // Notify speaking complete
    //   onSpeakComplete?.call();
    // } catch (e, stackTrace) {
    //   final errorMsg = 'Error speaking text: $e';
    //   logError(errorMsg, name: 'SpeakerButton');
    //   logError('Stack trace: $stackTrace', name: 'SpeakerButton');
    //   onError?.call(errorMsg);
    // }
  }
}
