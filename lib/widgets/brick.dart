import 'package:flutter/material.dart';

class Brick extends StatelessWidget {
  final double x;
  final double y;
  final double brickWidth;
  final bool isEnemy;
  const Brick({Key? key, required this.x, required this.y, required this.brickWidth, required this.isEnemy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2*x + brickWidth)/(2-brickWidth), y),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: isEnemy? Colors.deepPurple : Colors.pinkAccent,
          width: MediaQuery.of(context).size.width * brickWidth/2 + 0.1,
          height: 20,
        ),
      ),
    );
  }
}
