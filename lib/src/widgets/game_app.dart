import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'overlay_screen.dart';                                   
import 'score_card.dart'; 

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override                                                     
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color.fromARGB(255, 19, 218, 218),
          displayColor: const Color.fromARGB(255, 38, 160, 190),
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffa9d6e5),
                Color(0xfff2e8cf),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    ScoreCard(score: game.score),
                    ValueListenableBuilder<int>(
                      valueListenable: game.lives,
                      builder: (context, lives, child) {
                        return Container(
                          alignment: Alignment.topLeft, // Aligns the hearts to the top-left
                          padding: const EdgeInsets.only(left: 470.0), // Adds padding to move the hearts
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start, // Aligns hearts to the start (left)
                            children: List.generate(
                              lives,
                              (index) => const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: FittedBox(
                        child: SizedBox(
                          width: gameWidth,
                          height: gameHeight,
                          child: GameWidget(
                            game: game,
                            overlayBuilderMap: {
                              PlayState.welcome.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'TAP TO PLAY',
                                    subtitle: 'Use arrow keys or swipe',
                                  ),
                              PlayState.nextlevel.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'L E V E L C O M P L E T E',
                                    subtitle: 'Go To Next Level',
                                  ),
                              PlayState.gameOver.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'G A M E   O V E R',
                                    subtitle: 'Tap to Play Again',
                                  ),
                              PlayState.won.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'Y O U   W O N ! ! !',
                                    subtitle: 'Tap to Play Again',
                                  ),
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}