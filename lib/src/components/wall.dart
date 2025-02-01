import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Wall extends PositionComponent with CollisionCallbacks {
  Wall({
    required Vector2 position,
    required Vector2 size,
    required this.color,
  }) : super(position: position, size: size);

  final Color color;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Add collision detection
    add(RectangleHitbox());

    // Add visual representation
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = color,
      ),
    );
  }
}
