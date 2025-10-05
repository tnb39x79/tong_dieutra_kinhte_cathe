import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class LoadingOverlayHelper {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => const _LoadingWidget(),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      constraints: const BoxConstraints.expand(),
      alignment: Alignment.center,
      child: const Center(
        child: SpinKitSquareCircle(
          color:primaryColor,
          size: 55,
        ),
      ),
    );
  }
}
