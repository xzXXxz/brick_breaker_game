import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';                         
import 'package:flutter/services.dart';

import 'components/components.dart';
import './config.dart';

enum PlayState { welcome, playing, gameOver, won, nextlevel }

class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );
        
  final lives = ValueNotifier<int>(3);
  final ValueNotifier<int> score = ValueNotifier(0);
  final rand = math.Random();
  int activeBalls = 0;
  int currentlevel = 0;

  double baseBallSpeed = 1.0;

  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;                                    
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    overlays.clear();
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
      case PlayState.nextlevel:
        overlays.add(playState.name);
        break;
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        overlays.remove(PlayState.nextlevel.name);
        break;
    }
  }                                        

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    playState = PlayState.welcome; 
  }

  void nextLevel() {
      currentlevel++; // Move to the next level
  if (currentlevel >= levels.length) {
    // If no more levels, the player has won
    playState = PlayState.won;
  } else {
    playState = PlayState.nextlevel;
    // Clear the current level's objects
    world.removeAll(world.children.query<Brick>());
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Wall>());

    baseBallSpeed += 0.05;
  }
}

void loadLevel() {
    final level = levels[currentlevel];

    // Clear world
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
    world.removeAll(world.children.query<Wall>());

    // Determine brick movement direction
    final isHorizontalMovement = level.direction == 'horizontal';
    final velocity = isHorizontalMovement
        ? Vector2(100, 0) // Left-right movement
        : Vector2(0, 100); // Up-down movement

    // Add bricks
    for (int row = 0; row < level.layout.length; row++) {
      for (int col = 0; col < level.layout[row].length; col++) {
        if (level.layout[row][col] == 1) {
          world.add(Brick(
            position: Vector2(
              (col + 0.5) * brickWidth + (col + 1) * brickGutter,
              (row + 2.0) * brickHeight + row * brickGutter,
            ),
            color: brickColors[col % brickColors.length],
            isMoving: true,
            velocity: velocity,
            hitPoints: level.hitPoints?[row][col] ?? 1,
          ));
        }
      }
    }

    for (final wall in level.walls) {
      world.add(Wall(
        position: wall['position'] as Vector2,
        size: wall['size'] as Vector2,
        color: Colors.grey,
    ));
  }

    // Reset lives and score
    lives.value = level.lives;
    activeBalls = 1;
    score.value = 0;

    // Add ball and bat
    world.add(Ball(
      difficultyModifier: baseBallSpeed,
      radius: ballRadius,
      position: Vector2(width / 2, height * 0.95 - ballRadius - 5),
      velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
          .normalized()
        ..scale(height / 3.5 * baseBallSpeed),
    ));

    world.add(Bat(
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 2),
      position: Vector2(width / 2, height * 0.95),
    ));
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    playState = PlayState.playing;
    loadLevel();
  }

 void addBall(Ball ball) {
    activeBalls++;
    world.add(ball);
  }

  void onBallRemoved() {
    activeBalls--;

    if (activeBalls == 0) {
      lives.value--;

      if (lives.value > 0) {
        // Restart with a single ball
        startGame();
      } else {
        // Game over
        playState = PlayState.gameOver;
      }
    }
  }  

    void splitBalls() {
    final balls = world.children.query<Ball>();

    for (final ball in balls) {
      // Creating two additional balls for each existing one
      world.add(
        Ball(
          difficultyModifier: ball.difficultyModifier,
          radius: ball.radius,
          position: ball.position.clone(),
          velocity: ball.velocity.clone()..rotate(0.2), 
        ),
      );
      world.add(
        Ball(
          difficultyModifier: ball.difficultyModifier,
          radius: ball.radius,
          position: ball.position.clone(),
          velocity: ball.velocity.clone()..rotate(-0.2),
        ),
      );
    }
    activeBalls += 2 * balls.length;
  }



  @override                                                     
  void onTap() {
    super.onTap();
    
    if (playState == PlayState.welcome || playState == PlayState.gameOver){
      startGame();
  } else if (playState == PlayState.nextlevel) {
    nextLevel();
    loadLevel();
    playState = PlayState.playing;
  }
  }                                                             

  @override                                                     
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:                            
      case LogicalKeyboardKey.enter:
        startGame();      
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);
}