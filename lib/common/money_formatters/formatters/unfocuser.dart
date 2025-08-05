import 'package:flutter/material.dart';

class Unfocuser extends StatelessWidget {
  const Unfocuser({
    super.key,
    required this.child,
    this.isEnabled = true,
  });

  final Widget child;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return child;
    }
    return GestureDetector(
      onTap: () {
        final focusScopeNode = FocusScope.of(context);
        if (focusScopeNode.hasPrimaryFocus == false &&
            focusScopeNode.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}