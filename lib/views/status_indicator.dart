import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/room.dart';

class StatusIndicator extends StatefulWidget {
  const StatusIndicator({Key? key, required this.room}) : super(key: key);
  final Room room;

  @override
  createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 2, right: 8),
            child: _StatusLight(color: widget.room.getStatusColour())),
        Text(
          widget.room.getStatusString(),
          style: GoogleFonts.openSans(),
        )
      ],
    );
  }
}

class _StatusLight extends StatefulWidget {
  const _StatusLight({Key? key, required this.color}) : super(key: key);
  final Color color;
  @override
  createState() => _StatusLightState();
}

class _StatusLightState extends State<_StatusLight> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 2.4)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color, boxShadow: [
          BoxShadow(
              color: widget.color.withOpacity(0.6),
              blurRadius: _animation.value,
              spreadRadius: _animation.value)
        ]),
        child: Icon(Icons.circle, size: 7, color: widget.color));
  }
}
