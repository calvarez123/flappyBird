import 'package:cupertino_base/ft_game.dart';
import 'package:cupertino_base/ft_player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'dart:math';

class Pipe extends PositionComponent
    with HasGameRef<FtGame>, CollisionCallbacks {
  static const double pipeWidth = 100.0;
  static const double pipeSpeed = 100.0;

  final Paint pipePaint;
  final double pipeHeight;

  Pipe(double x, double y, {required double height})
      : pipePaint = Paint()..color = Colors.green,
        pipeHeight = height,
        super(
          position: Vector2(x, y),
          size: Vector2(pipeWidth, height),
        ) {
    debugMode = true;
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(toRect(), pipePaint);
    // Dibujar la hitbox en rojo
    final hitboxPaint = Paint()
      ..color = Colors.red.withOpacity(0.5) // Color rojo con opacidad
      ..style = PaintingStyle.stroke // Estilo de trazo
      ..strokeWidth = 2; // Grosor del trazo

    c.drawRect(toRect(), hitboxPaint);
  }

  @override
  Future<void> onLoad() async {
    RectangleHitbox().removeFromParent();
    add(RectangleHitbox());
    RectangleHitbox().paint;
  }

  @override
  void update(double dt) {
    super.update(dt);
    RectangleHitbox().removeFromParent();

    this.x -= pipeSpeed * dt;
    add(RectangleHitbox());
  }
}
