import 'package:brick_breaker/src/components/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';

class Ball extends CircleComponent with CollisionCallbacks, HasGameRef<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]);

  late final Vector2 velocity;
  final double difficultyModifier;
  final Color _defaultColor = const Color(0xff1e6091); // Marked as final
  double _originalSpeed = 0; // Store the original speed of the ball

  void changeColor(Color color) {
    paint.color = color;
  }

  void resetColor() {
    paint.color = _defaultColor;
  }

  void setOriginalSpeed() {
    _originalSpeed = velocity.length; // Store the original speed
  }

  void resetSpeed() {
    velocity.normalize(); // Normalize to maintain direction
    velocity.scale(_originalSpeed); // Reset to original speed
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
      gameRef.activeBalls--;

      // Deduct a life only if no balls are left
      if (gameRef.activeBalls == 0 && gameRef.lives.value > 0) {
        gameRef.lives.value--;

        if (gameRef.lives.value > 0) {
          spawnNewBall();
        } else {
          gameRef.playState = PlayState.gameOver;
        }
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayArea) {
      // Get the closest intersection point
      Vector2 intersection = intersectionPoints.first;

      // Ball hits the top wall
      if (intersection.y <= 0) {
        velocity.y = -velocity.y;
        position.y = 0;  // Ensure the ball doesn't move out of bounds
      }
      // Ball hits the left wall
      else if (intersection.x <= 0) {
        velocity.x = -velocity.x;
        position.x = 0;  // Ensure the ball doesn't move out of bounds
      }
      // Ball hits the right wall
      else if (intersection.x >= game.width) {
        velocity.x = -velocity.x;
        position.x = game.width;  // Ensure the ball doesn't move out of bounds
      }
    }
 
    else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x + (position.x - other.position.x) / other.size.x * game.width * 0.3;

      
      if (velocity.y < 0) {
        position.y = other.position.y - other.size.y / 2 - 1;
      }
    } 
    else if (other is Brick) {
      
      if (position.y < other.position.y - other.size.y / 2 || position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
        
        position.y = position.y < other.position.y - other.size.y / 2 ? 
            other.position.y - other.size.y / 2 - 1 : 
            other.position.y + other.size.y / 2 + 1;
      } else {
        velocity.x = -velocity.x;
        
        position.x = position.x < other.position.x - other.size.x / 2 ? 
            other.position.x - other.size.x / 2 - 1 : 
            other.position.x + other.size.x / 2 + 1;
      }
    } else if (other is Wall){
         if (position.y <= other.position.y) {
          // Collision with the top wall
          velocity.y = -velocity.y;
          position.y = other.position.y; // Prevent overlapping
        } else if (position.x <= other.position.x) {
          // Collision with the left wall
          velocity.x = -velocity.x;
          position.x = other.position.x; // Prevent overlapping
        } else if (position.x >= other.position.x + other.size.x) {
          // Collision with the right wall
          velocity.x = -velocity.x;
          position.x = other.position.x + other.size.x; // Prevent overlapping
        } else if (position.y >= other.position.y + other.size.y) {
          // Collision with the bottom wall
          velocity.y = -velocity.y;
          position.y = other.position.y + other.size.y; // Prevent overlapping
        }
      }
    }

  void spawnNewBall() {
    final bat = gameRef.world.children.query<Bat>().first;

    gameRef.world.add(Ball(
      difficultyModifier: difficultyModifier,
      radius: radius,
      position: Vector2(bat.position.x, gameRef.height * 0.90),
      velocity: Vector2(
        (gameRef.rand.nextDouble() - 0.5) * gameRef.width,
        gameRef.height * 0.2,
      ).normalized()
        ..scale(gameRef.height / 3.5),
    ));

    gameRef.activeBalls++;
  }
}