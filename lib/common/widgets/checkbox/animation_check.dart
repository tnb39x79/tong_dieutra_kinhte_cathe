import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/constants/constants.dart';

class CustomAnimatedCheck extends StatefulWidget {
  const CustomAnimatedCheck({super.key});

  @override
  CustomAnimatedCheckState createState() => CustomAnimatedCheckState();
}

class CustomAnimatedCheckState extends State<CustomAnimatedCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCheck() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheck,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(50, 50),
            painter: CheckmarkPainter(_animation.value),
          );
        },
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5.0;

    final path = Path();
    // Define the checkmark path
    path.moveTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.7);
    path.lineTo(size.width * 0.8, size.height * 0.3);

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      canvas.drawPath(metric.extractPath(0.0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as CheckmarkPainter).progress != progress;
  }
}

class CustomAnimatedCheckmark extends StatefulWidget {
  const CustomAnimatedCheckmark(
      {this.enable, this.checked, this.checkColor, super.key});
  final bool? enable;
  final Color? checkColor;
  final bool? checked;

  @override
  CustomAnimatedCheckmarkState createState() => CustomAnimatedCheckmarkState();
}

class CustomAnimatedCheckmarkState extends State<CustomAnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.checked ?? false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCheckmark() {
    setState(() {
      _isChecked = !_isChecked;
      if (_isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (widget.enable != null && widget.enable == true)
          ? _toggleCheckmark
          : () => {},
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              _isChecked ? widget.checkColor ?? primaryColor : Colors.grey[300],
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}




class AnimatedCheckmark extends StatefulWidget {
  const AnimatedCheckmark(
      {  this.checkColor, super.key});
 
  final Color? checkColor; 

  @override
  AnimatedCheckmarkState createState() => AnimatedCheckmarkState();
}

class AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation; 

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 

  @override
  Widget build(BuildContext context) {
     _controller.forward();
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end:  1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, opacity, child) {
          return Opacity(
            opacity: opacity,
            child:ScaleTransition(
            scale: _scaleAnimation ,
            child: Icon(Icons.check_circle_outlined, color: successColor) ,
          ));
        },
      );
  }
}



