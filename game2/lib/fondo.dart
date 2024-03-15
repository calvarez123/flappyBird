import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Fondo extends SpriteComponent {
  Fondo(Size size, {required Vector2}) {
    this.width = size.width;
    this.height = size.height;
    // Reemplaza 'suelo_sprite.png' con el nombre de tu sprite de suelo
  }

  @override
  Future<void> onLoad() async {
    priority = 0; // Dibujar-lo per sobre de tot
    sprite = await Sprite.load('ground.png');
  }

  @override
  void update(double dt) {
    // Puedes agregar lógica de actualización aquí si es necesario
    super.update(dt);
  }
}
