import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  final bool isGameStarted;
  const CoverScreen({Key? key, required this.isGameStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.2),
      child: !isGameStarted
          ? const Text('T A P  T O  P L A Y', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30),)
          : Container()
    );
  }
}
