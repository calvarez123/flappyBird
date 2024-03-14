import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Pipe extends SpriteComponent {
  static const double defaultWidth =
      150.0; // Ancho predeterminado de la tubería
  static const double minHeight = 100.0; // Altura mínima de la tubería
  static const double maxHeight = 450.0; // Altura máxima de la tubería
  final double height; // Altura de la tubería
  static const double speed = 100.0; // Velocidad de movimiento de la tubería

  Pipe({required this.height, required double x, required double y})
      : super(size: Vector2(defaultWidth, height), anchor: Anchor.center) {
    this.x = x;
    this.y = y;
    debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    priority = 1; // Dibujar-lo per sobre de tot
    sprite = await Sprite.load('pipe.png');
  }

  factory Pipe.randomHeight({required double x, required double y}) {
    final randomHeight =
        Random().nextDouble() * (maxHeight - minHeight) + minHeight;
    return Pipe(height: randomHeight, x: x, y: y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Mover la tubería hacia la derecha
    x -= speed *
        dt; // dt es el tiempo transcurrido desde el último frame, lo que asegura un movimiento suave independientemente de la velocidad de actualización
  }

  @override
  void render(Canvas c) {
    super.render(c);
    // Dibujar el cuadrado verde
  }
}
