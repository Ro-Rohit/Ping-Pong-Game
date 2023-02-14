import 'dart:async';
import '../widgets/scoreboard.dart';
import 'package:flutter/material.dart';
import 'package:pingpong/widgets/coverScreen.dart';
import '../widgets/brick.dart';
import '../widgets/ball.dart';
import 'homeScreen.dart';
import 'dart:math';

class FaceEnemyScreen extends StatefulWidget {
  const FaceEnemyScreen({Key? key}) : super(key: key);

  @override
  State<FaceEnemyScreen> createState() => _FaceEnemyScreenState();
}
enum Direction {up, down, right, left}
class _FaceEnemyScreenState extends State<FaceEnemyScreen> {
  double playerX = -0.2;
  double enemyX = -0.2;
  double ballX = 0.0;
  double ballY = 0.0;
  double brickWidth = 0.44;
  bool isGameStarted = false;
  bool isEnemyDead = false;
  bool isPlayerDead = false;
  int compScore = 0;
  bool cancelMoving = false;
  int playerScore = 0;
  var ballXDirection = Direction.left;
  var ballYDirection = Direction.up;
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

  void movePlayer(TapDownDetails details){
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if(details.globalPosition.dy >= 350){
        if(details.globalPosition.dx <= 160 ){
          if((playerX - 0.1 > -1)){
            setState(() {
              playerX -= 0.1;
            });
          }
        }
        else if(details.globalPosition.dx > 160) {
          if(!(playerX + 0.1 >= 0.7)){
            setState(() {
              playerX += 0.1;
            });
          }
        }
      }
      if(cancelMoving){
        timer.cancel();
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
        if(ballY >= 0.9 && playerX + brickWidth >= ballX && playerX <= ballX){
          ballYDirection = Direction.up;
          ballSpeed += 0.002 ;
        }
        if(ballY <= -0.9 ){
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

  void movingEnemy(){
    if(mounted){
      setState(() {
        if(enemyX - 0.1 <= -1 && ballX <= enemyX + brickWidth/2){
          enemyX = enemyX;
        }
        else if( enemyX + brickWidth >= 1 && ballX >= enemyX + brickWidth/2){
          enemyX = enemyX ;
        }
        else{
          enemyX = ballX - brickWidth/2;
        }
      });
    }


  }

  bool isGameOver(){
    if(ballY < -1){
      setState(() {
        isEnemyDead = true;
      });
      return true;
    }
    if(ballY > 1  && mounted){
      setState(() {
        isPlayerDead = true;
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
            backgroundColor: isEnemyDead?  Colors.deepPurple : Colors.pinkAccent ,
            title: Center(
              child: Text(isEnemyDead? 'You Win!!' : 'Robot Win!',
                style: const TextStyle(color:Colors.white, fontSize: 18 ),),
            ),
            actions: [
              GestureDetector(
                onTap: (){resetGame();},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: isEnemyDead? Colors.deepPurple[100] : Colors.pink[100] ,
                    padding: const EdgeInsets.all(14),
                    child: Text('PLAY AGAIN?',
                      style: TextStyle(color: isEnemyDead? Colors.deepPurple[800] : Colors.pink[800] ,),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const HomeScreen()), (Route<dynamic> route) => false);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: isEnemyDead?  Colors.deepPurple[100] : Colors.pink[100] ,
                    padding: const EdgeInsets.all(14),
                    child: Text('Exit',
                      style: TextStyle(color: isEnemyDead? Colors.deepPurple[800]: Colors.pink[800] ,),),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void startGame(){
    if(mounted){
      setState(() {
        isGameStarted = true;
      });
    }

    decideInitialDirection();
    Timer.periodic( const Duration(milliseconds:  40 ), (timer) {
      giveDirection();
      movingBall();
      movingEnemy();
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
        isEnemyDead? playerScore+=1: compScore +=1;
        isGameStarted =isEnemyDead =isPlayerDead =  false;
        playerX = enemyX =  -0.2;
        ballX = ballY = 0;
        ballSpeed = 0;
      });
      Navigator.pop(context);
    }
    }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details){
        if(isGameStarted && mounted){
          setState(() {
            cancelMoving = false;
          });
          movePlayer(details);
        }
        },
      onTapUp:(details){

        if(isGameStarted && mounted){
          setState(() {
            cancelMoving = true;
          });
        }

      } ,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Stack(
            children: [
              GestureDetector(
                  onTap: (){startGame();},
                  child: CoverScreen(isGameStarted: isGameStarted)),
              ScoreBoard(isGameStarted: isGameStarted, score1: compScore, score2: playerScore),
              Brick(x: enemyX, y: -0.9, brickWidth: brickWidth, isEnemy: false),

              Ball(isGameStarted: isGameStarted, x: ballX, y: ballY),

              Brick(x: playerX, y: 1, brickWidth: brickWidth, isEnemy: true),
            ],
          ),
        ),
      ),
    );
  }
}
