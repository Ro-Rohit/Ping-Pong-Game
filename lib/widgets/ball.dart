import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
class Ball extends StatelessWidget {
  final bool isGameStarted;
  final double x;
  final double y;
  const Ball({Key? key, required this.isGameStarted, required this.x, required this.y}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isGameStarted
        ? Container(
      alignment: Alignment(x, y),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    )
        : Container(
      alignment: const Alignment(0,0),
      child: AvatarGlow(
        endRadius: 60,
        child: Material(
          elevation: 0,
          shape: const CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.grey[700],
            radius: 7,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
