import 'dart:ui';

import 'package:cupertino_base/pipe.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ft_game.dart';

class FtPlayer extends SpriteComponent
    with KeyboardHandler, CollisionCallbacks, HasGameReference<FtGame> {
  FtPlayer({required this.id, required this.img, required super.position})
      : super(size: Vector2(10, 10), anchor: Anchor.center);

  String id = "";
  String img; // Nuevo parámetro color

  Vector2 previousPosition = Vector2.zero();
  int previousHorizontalDirection = 0;
  int previousVerticalDirection = 0;

  final double moveSpeed = 400;
  int horizontalDirection = 0;
  int verticalDirection = 0;

  @override
  Future<void> onLoad() async {
    priority = 1;
    print(img);
    sprite = await Sprite.load(
        '$img.png'); // Usar el parámetro color para cargar el sprite correspondiente
    size = Vector2(60, 50);
    x = -400;
    y = 0;
    add(CircleHitbox());
  }

  // Método para actualizar la posición del jugador
  void updatePosition(Vector2 newPosition) {
    position.setFrom(newPosition);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection += 1;
    }

    verticalDirection = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      verticalDirection -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      verticalDirection += 1;
    }

    return false;
  }

  @override
  void update(double dt) {
    center.add(Vector2(horizontalDirection * moveSpeed * dt, 0));
    center.add(Vector2(0, verticalDirection * moveSpeed * dt));
    center.add(Vector2(0, 100 * dt));

    Vector2 newPosition = center.clone();
    if (newPosition != previousPosition ||
        horizontalDirection != previousHorizontalDirection ||
        verticalDirection != previousVerticalDirection) {
      game.websocket.sendMessage(
          '{"type": "move", "x": ${position.x}, "y": ${position.y}, "horizontalDirection": $horizontalDirection, "verticalDirection": $verticalDirection}');

      previousPosition.setFrom(newPosition);
    }

    super.update(dt);
  }

  @override
  void onCollisionStart(Set<Vector2> _, PositionComponent other) {
    super.onCollisionStart(_, other);
    if (other is Pipe) {
      game.gameover(id);
      //game.pauseEngine();

      print('melotoco');
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..filterQuality = FilterQuality.high;
  }
}
