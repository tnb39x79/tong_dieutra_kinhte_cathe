import 'package:flutter/material.dart';

class AnimatedToggleSwitch extends StatefulWidget {
  @override
  _AnimatedToggleSwitchState createState() => _AnimatedToggleSwitchState();
}

class _AnimatedToggleSwitchState extends State<AnimatedToggleSwitch> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitched = !isSwitched;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 40.0,
        width: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isSwitched ? Colors.green : Colors.redAccent,
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              top: 3.0,
              left: isSwitched ? 60.0 : 0.0,
              right: isSwitched ? 0.0 : 60.0,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: animation,
                    child: child,
                  );
                },
                child: isSwitched
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        key: UniqueKey(),
                      )
                    : Icon(
                        Icons.remove_circle_outline,
                        color: Colors.white,
                        key: UniqueKey(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomToggleButton extends StatefulWidget {
  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isToggled = !isToggled;
        });
      },
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: isToggled ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            isToggled ? 'Online' : 'Offline',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
