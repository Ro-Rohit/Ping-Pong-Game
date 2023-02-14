import 'package:flutter/material.dart';
import 'package:pingpong/screen/enemyface.dart';
import 'package:pingpong/screen/playerface.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/pingpong.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FaceEnemyScreen()));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  color: Colors.greenAccent,
                  padding: EdgeInsets.all(10),
                  child: const Center(
                    child: Text('Play With Computer', style: TextStyle(color: Colors.black, fontSize: 15, ),),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FacePlayerScreen()));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  color: Colors.greenAccent,
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text('Play With Friends', style: TextStyle(color: Colors.black, fontSize: 15, ),),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
