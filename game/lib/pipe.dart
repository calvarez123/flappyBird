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
        ) {}

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(toRect(), pipePaint);
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(pipeWidth, height),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.x -= pipeSpeed * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is FtPlayer) {
      print('lo toque');
      return;
    }

    super.onCollision(intersectionPoints, other);
  }
}
