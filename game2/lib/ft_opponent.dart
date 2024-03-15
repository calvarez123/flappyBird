import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'ft_game.dart';

class FtOpponent extends SpriteComponent with HasGameReference<FtGame> {
  FtOpponent({required this.id, required super.position, required this.color})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  String id = "";
  String color = "";

  Vector2 targetPosition = Vector2.zero(); // Posició objectiu (la del servidor)
  double interpolationSpeed = 10; // Velocitat d'interpolació

  @override
  Future<void> onLoad() async {
    priority = 0; // Dibuixar-lo per sota del player
    await _loadSprite(); // Cargar el sprite usando el nombre del color
    size = Vector2.all(64);
    add(CircleHitbox());
  }

  Future<void> _loadSprite() async {
    // Construir la ruta del asset utilizando el nombre del color
    String assetPath = '$color.png';
    sprite = await Sprite.load(assetPath); // Cargar el sprite
  }

  @override
  void update(double dt) {
    // Defineix un factor d'interpolació. Per exemple, 0.1 per un 10% del camí per frame
    double lerpFactor = interpolationSpeed * dt;

    // Calcula la nova posició com una interpolació lineal entre la posició actual i la targetPosition
    position =
        position + (targetPosition - position) * lerpFactor.clamp(0.0, 1.0);

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Preparar el Paint amb color i opacitat
    final paint = Paint()..filterQuality = FilterQuality.high;

    // Renderitzar el sprite amb el Paint personalitzat
    sprite?.render(canvas, size: size, overridePaint: paint);
  }
}
