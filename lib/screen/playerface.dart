import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/scoreboard.dart';
import 'package:pingpong/widgets/coverScreen.dart';
import '../widgets/brick.dart';
import '../widgets/ball.dart';
import 'homeScreen.dart';

class FacePlayerScreen extends StatefulWidget {
  const FacePlayerScreen({Key? key}) : super(key: key);

  @override
  State<FacePlayerScreen> createState() => _FacePlayerScreenState();
}
enum Direction {up, down, right, left}
class _FacePlayerScreenState extends State<FacePlayerScreen> {
  double player1X = -0.2;
  double player2X = -0.2;
  double ballX = 0.0;
  double ballY = 0.0;
  double brickWidth = 0.4;
  bool isGameStarted = false;
  bool isPlayer2Dead = false;
  bool isPlayer1Dead = false;
  int player2Score = 0;
  bool isPlayer1StopMoving = false;
  bool isPlayer2StopMoving = false;
  int player1Score = 0;
  var ballXDirection = Direction.left;
  var ballYDirection = Direction.down;
  double ballSpeed = 0;

  void decideInitialDirection(){
    int x = Random().nextInt(10);
    if(mounted){
      setState((){
        ballXDirection = x.isEven? Direction.left : Direction.right;
        ballYDirection = x.isEven? Direction.down : Direction.up;
      });
    }
  }

  void movePlayer1(TapDownDetails details){

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if(isPlayer1StopMoving){
        timer.cancel();
      }
      if(details.globalPosition.dx <= 160 ){
        if((player1X - 0.1 > -1)){
          setState(() {
            player1X -= 0.1;
          });
        }
      }
      else if(details.globalPosition.dx > 160) {
        if(!(player1X + 0.1 >= 0.7)){
          setState(() {
            player1X += 0.1;
          });
        }
      }
    });
  }
   void movePlayer2(TapDownDetails details){

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if(isPlayer2StopMoving){
        timer.cancel();
      }
      if(details.globalPosition.dx <= 160 ){
        if((player2X - 0.1 > -1)){
          setState(() {
            player2X -= 0.1;
          });
        }
      }
      else if(details.globalPosition.dx > 160) {
        if(!(player2X + 0.1 >= 0.7)){
          setState(() {
            player2X += 0.1;
          });
        }
      }
    });
  }

  void giveDirection(){
    if(mounted){
      setState(() {
        if(ballX <= -1 ){
          ballXDirection = Direction.right;

        }
        if(ballX >= 1 ){
          ballXDirection = Direction.left;
        }
        if(ballY >= 0.9 && player1X + brickWidth >= ballX && player1X <= ballX){
          ballYDirection = Direction.up;
          ballSpeed += 0.002 ;
        }
        if(ballY <= -0.9 && player2X + brickWidth >= ballX && player2X <= ballX){
          ballYDirection = Direction.down;
          ballSpeed += 0.002 ;

        }
      });
    }


  }
  void movingBall(){
    if(mounted){
      setState(() {
        if(ballYDirection == Direction.up){
          ballY -= 0.01 + ballSpeed;
        }
        if(ballYDirection == Direction.down){
          ballY += 0.01 + ballSpeed;
        }
        if(ballXDirection == Direction.left){
          ballX -= 0.01 + ballSpeed;
        }
        if(ballXDirection == Direction.right){
          ballX += 0.01 + ballSpeed;
        }
      });
    }
  }

  bool isGameOver(){
    if(ballY < -1 && mounted){
      setState(() {
        isPlayer2Dead = true;
      });
      return true;
    }
    if(ballY > 1 && mounted){
      setState(() {
        isPlayer1Dead = true;
      });
      return true;
    }
    return false;
  }
  void showWhoWin(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_){
          return AlertDialog(
            backgroundColor: isPlayer1Dead? Colors.pinkAccent : Colors.deepPurple,
            title: Center(
              child: Text(isPlayer2Dead? 'Player1 Win!!' : 'Player2 Win!',
                style: const TextStyle(color:Colors.white, fontSize: 18 ),),
            ),
            actions: [
              GestureDetector(
                onTap: (){resetGame();},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: isPlayer2Dead? Colors.pink[100] : Colors.deepPurple[100],
                    padding: const EdgeInsets.all(14),
                    child: Text('PLAY AGAIN?', style: TextStyle(color: isPlayer1Dead? Colors.pink[800] : Colors.deepPurple[800],),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      const HomeScreen()), (Route<dynamic> route) => false);

                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: isPlayer2Dead? Colors.pink[100] : Colors.deepPurple[100],
                    padding: const EdgeInsets.all(14),
                    child: Text('Exit',
                      style: TextStyle(color: isPlayer1Dead? Colors.pink[800] : Colors.deepPurple[800],),),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void startGame(){
    decideInitialDirection();
    setState(() {
      isGameStarted = true;
    });
    Timer.periodic( const Duration(milliseconds:  40 ), (timer) {
      giveDirection();
      movingBall();
      if(isGameOver()){
        timer.cancel();
        showWhoWin();
      }
    });
  }

  void resetGame(){
    decideInitialDirection();
    if(mounted){
      setState(() {
        isPlayer2Dead? player1Score+=1: player2Score +=1;
        isGameStarted =isPlayer2Dead =isPlayer1Dead = isPlayer1StopMoving = isPlayer2StopMoving =  false;
        player1X = player2X =  -0.2;
        ballX = ballY = ballSpeed = 0;
      });
    }

    Navigator.of(context, rootNavigator: true).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Stack(
          children: [
            GestureDetector(
                onTap: (){startGame();},
                child: CoverScreen(isGameStarted: isGameStarted)),
            ScoreBoard(isGameStarted: isGameStarted, score1: player2Score, score2: player1Score),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: GestureDetector(
                onTapDown: (details){
                  if(isGameStarted){
                    setState(() {
                      isPlayer2StopMoving = false;
                    });
                    movePlayer2(details);
                  }
                },
                onTapUp:(details){
                  setState(() {
                    if(isGameStarted){
                      setState(() {
                        isPlayer2StopMoving = true;
                      });
                    }

                  });
                } ,
                child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height/3,
                    width: double.maxFinite,
                    child: Brick(x: player2X, y: -0.9, brickWidth: brickWidth, isEnemy: false)),
              ),
            ),

            Ball(isGameStarted: isGameStarted, x: ballX, y: ballY),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                  onTapDown: (details){
                    if(isGameStarted){
                      setState(() {
                        isPlayer1StopMoving = false;
                      });
                      movePlayer1(details);
                    }
                  },
                  onTapUp:(details){
                    setState(() {
                      if(isGameStarted){
                        setState(() {
                          isPlayer1StopMoving = true;
                        });
                      }

                    });
                  },
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height/3,
                    width: double.maxFinite,
                    child: Brick(x: player1X, y: 1, brickWidth: brickWidth, isEnemy: true)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
