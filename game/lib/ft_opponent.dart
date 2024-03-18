import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'ft_game.dart';

class FtOpponent extends SpriteComponent with HasGameReference<FtGame> {
  FtOpponent({required this.id, required super.position, required this.img})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  String id = "";
  String img = "";

  Vector2 targetPosition =
      Vector2.zero(); // Posición objetivo (la del servidor)
  double interpolationSpeed = 10; // Velocidad de interpolación

  @override
  Future<void> onLoad() async {
    priority = 0; // Dibujar por debajo del jugador
    await _loadSprite(); // Cargar el sprite usando el nombre del color
    size = Vector2.all(64);
    add(CircleHitbox());
  }

  Future<void> _loadSprite() async {
    // Construir la ruta del asset utilizando el nombre del color
    String assetPath = '$img.png';
    sprite = await Sprite.load(assetPath); // Cargar el sprite
  }

  @override
  void update(double dt) {
    // Define un factor de interpolación. Por ejemplo, 0.1 para un 10% del camino por fotograma
    double lerpFactor = interpolationSpeed * dt;

    // Calcula la nueva posición como una interpolación lineal entre la posición actual y la targetPosition
    position =
        position + (targetPosition - position) * lerpFactor.clamp(0.0, 1.0);

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Preparar el Paint con color y opacidad
    final paint = Paint()
      ..filterQuality = FilterQuality.high
      ..colorFilter = ColorFilter.mode(Colors.white.withOpacity(0.5),
          BlendMode.srcOver); // Ajustar la opacidad aquí

    // Renderizar el sprite con el Paint personalizado
    sprite?.render(canvas, size: size, overridePaint: paint);
  }
}
