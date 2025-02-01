import 'package:flame/game.dart';

import '../config.dart';

class Level {
  final List<List<int>> layout;
  final int lives;
  final bool movingBricks;
  final String direction;
  final List<Map<String, dynamic>> walls;
  final List<List<int>>? hitPoints;

  Level({
    required this.layout,
    required this.lives,
    required this.direction,
    this.movingBricks = false,
    this.walls = const[],
    this.hitPoints,
  });
}

final levels = [
  Level(
    layout: [
      [0, 0, 1, 0, 0, 0, 0, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
      [0, 0, 0, 1, 1, 1, 1, 0, 0, 0],
    ],
    lives: 3,
    direction: 'horizontal',
  ),
  Level(
    layout: [
      [0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
    ],
    lives: 3,
    direction: 'vertical',
    walls: [{'position': Vector2(0,(gameHeight - 15) / 3,),'size': Vector2(500,15)},],
  ),
  Level(
    layout: [
      [0, 0, 1, 0, 1, 1, 0, 1, 0, 0],
      [0, 1, 1, 1, 0, 0, 1, 1, 1, 0],
      [0, 1, 1, 1, 0, 0, 1, 1, 1, 0],
      [0, 0, 1, 0, 1, 1, 0, 1, 0, 0],
    ],
    lives: 3,
    direction: 'horizontal',
    hitPoints: [
      [0, 0, 2, 0, 2, 2, 0, 2, 0, 0],
      [0, 1, 1, 1, 0, 0, 1, 1, 1, 0],
      [0, 1, 1, 1, 0, 0, 1, 1, 1, 0],
      [0, 0, 2, 0, 2, 2, 0, 2, 0, 0],
    ]
  ),
 Level(
    layout: [
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
    ],
    lives: 2,
    movingBricks: true,
    direction: 'horizontal',
    hitPoints: [
      [0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
      [0, 0, 2, 1, 1, 1, 1, 2, 0, 0],
      [0, 0, 2, 1, 1, 1, 1, 2, 0, 0],
      [0, 0, 2, 1, 1, 1, 1, 2, 0, 0],
      [0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
    ],
  ),
Level(
    layout: [
      [0, 0, 0, 1, 1, 1, 1, 0, 0, 0],
      [0, 0, 1, 0, 1, 1, 0, 1, 0, 0],
      [0, 0, 1, 0, 1, 1, 0, 1, 0, 0],
      [0, 0, 0, 1, 1, 1, 1, 0, 0, 0],
    ],
    lives: 2,
    direction: 'vertical',
    hitPoints: [
      [0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
      [0, 0, 2, 0, 2, 2, 0, 2, 0, 0],
      [0, 0, 2, 0, 2, 2, 0, 2, 0, 0],
      [0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
    ],
     walls: [{'position': Vector2((gameWidth - 500) / 2, (gameHeight - 15) / 3,),'size': Vector2(500,15)},],
  ),
];
