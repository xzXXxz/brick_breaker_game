import 'dart:math';

import 'package:brick_breaker/src/components/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  final bool isMoving;
  final Vector2 velocity;
  int hitPoints; // Number of hits required to break the brick

  Brick({
    required super.position,
    required Color color,
    this.isMoving = false,
    this.hitPoints = 1,
    Vector2? velocity,
  })  : velocity = velocity ?? Vector2.zero(),
        super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void update(double dt) {
    super.update(dt);

    if (isMoving) {
      position.add(velocity * dt);

      // Handle horizontal movement (left-right bounce)
      if (velocity.x != 0) {
        if (position.x - size.x / 2 <= 0) {
          position.x = size.x / 2;
          velocity.x = -velocity.x;
        } else if (position.x + size.x / 2 >= game.size.x) {
          position.x = game.size.x - size.x / 2;
          velocity.x = -velocity.x;
        }
      }

      // Handle vertical movement (up-down bounce)
      if (velocity.y != 0) {
        if (position.y <= 0) {
          position.y = 0;
          velocity.y = -velocity.y;
        } else if (position.y + size.y >= game.size.y / 3) {
          position.y = game.size.y / 3 - size.y;
          velocity.y = -velocity.y;
        }
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PowerUp) {
      return; // Ignore collisions with PowerUp
    }
    if (other is PlayArea) {
      return;
    }

    hitPoints--; // Decrease hit points on collision
    if (hitPoints <= 0) {
      removeFromParent();
      game.score.value++;
      _maybeSpawnPowerUp();

      if (game.world.children.query<Brick>().length == 1) {
        game.nextLevel();
      }
    }
  }

  void _maybeSpawnPowerUp() {
    final random = Random();
    if (random.nextDouble() < 0.3) {
      // 30% chance to spawn power-up
      final powerUpType =
          PowerUpType.values[random.nextInt(PowerUpType.values.length)];
      final powerUp = PowerUp(
        position: position,
        type: powerUpType,
        velocity: Vector2(0, 150),
      );
      game.world.add(powerUp);
    }
  }
}
