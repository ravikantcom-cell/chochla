import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHOCHLA"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🃏",
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 20),
            const Text(
              "CHOCHLA",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "The Ultimate Time Pass Game",
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const GameScreen(),
    ),
  );
},
              child: const Text("START GAME"),
            ),
          ],
        ),
      ),
    );
  }
}