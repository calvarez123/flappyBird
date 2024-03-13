// ignore_for_file: must_call_super

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
  FtPlayer({required this.id, required super.position, required this.color})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  String id = "";
  Color color = const Color.fromARGB(255, 175, 175, 175);

  Vector2 previousPosition = Vector2.zero();
  int previousHorizontalDirection = 0;
  int previousVerticalDirection = 0;

  final double moveSpeed = 400;
  int horizontalDirection = 0;
  int verticalDirection = 0;

  @override
  Future<void> onLoad() async {
    priority = 1; // Dibuixar-lo per sobre de tot
    sprite = await Sprite.load('player.png');
    size = Vector2.all(64);
    x = -400;
    y = 0;
    add(CircleHitbox());
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Modificar la direcció horitzontal basada en les tecles dreta i esquerra
    horizontalDirection = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection += 1;
    }

    // Modificar la direcció vertical basada en les tecles amunt i avall
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
    // Movimiento horizontal con las flechas
    center.add(Vector2(horizontalDirection * moveSpeed * dt, 0));

    // Movimiento vertical con las flechas
    center.add(Vector2(0, verticalDirection * moveSpeed * dt));

    // Movimiento hacia abajo constante
    center.add(Vector2(0, 100 * dt));

    // Actualizar la posición solo si ha habido cambios
    Vector2 newPosition = center.clone();
    if (newPosition != previousPosition ||
        horizontalDirection != previousHorizontalDirection ||
        verticalDirection != previousVerticalDirection) {
      // Enviar los datos al servidor, solo si ha habido cambios
      game.websocket.sendMessage(
          '{"type": "move", "x": ${position.x}, "y": ${position.y}, "horizontalDirection": $horizontalDirection, "verticalDirection": $verticalDirection}');

      previousPosition.setFrom(newPosition);
    }

    super.update(dt);
  }

  @override
  void onCollisionStart(Set<Vector2> _, PositionComponent other) {
    super.onCollisionStart(_, other);

    game.pauseEngine();
    print('melotoco');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Preparar el Paint amb color i opacitat
    final paint = Paint()
      ..colorFilter =
          ColorFilter.mode(color.withOpacity(0.5), BlendMode.srcATop)
      ..filterQuality = FilterQuality.high;

    // Renderitzar el sprite amb el Paint personalitzat
    sprite?.render(canvas, size: size, overridePaint: paint);
    // Dibujar la hitbox en azul
    final hitboxPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5) // Color azul con opacidad
      ..style = PaintingStyle.stroke // Estilo de trazo
      ..strokeWidth = 2; // Grosor del trazo

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, hitboxPaint);
  }
}
