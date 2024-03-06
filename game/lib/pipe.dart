import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'dart:math';

class Pipe extends PositionComponent {
  static const double pipeWidth = 100.0;
  static const double pipeSpeed = 100.0;
  static const double pipeGap =
      500.0; // Definir el tamaño del espacio entre las tuberías

  final Paint pipePaint;
  final double pipeHeight;

  Pipe(double x, double y, {required double height})
      : pipePaint = Paint()..color = Colors.green,
        pipeHeight = height,
        super(
          position: Vector2(x, y),
          size: Vector2(pipeWidth, height),
        );

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(toRect(), pipePaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.x -= pipeSpeed * dt;
  }
}
