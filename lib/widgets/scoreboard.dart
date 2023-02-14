import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final bool isGameStarted;
  final int score1;
  final int score2;
  const ScoreBoard({Key? key, required this.isGameStarted, required this.score1, required this.score2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isGameStarted
        ? Stack(
      children: [
        Container(
          alignment: const Alignment(0, -0.2),
          child: Text(score1.toString(), style: TextStyle(color: Colors.grey[700], fontSize: 100),),
        ),
        Container(
          alignment: const Alignment(0, 0),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width/3,
            color: Colors.grey[700],
          ),
        ),
        Container(
          alignment: const Alignment(0, 0.2),
          child: Text(score2.toString(), style: TextStyle(color: Colors.grey[700], fontSize: 100),),
        ),

      ],
    )
        : Container();

  }
}
