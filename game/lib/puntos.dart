import 'package:cupertino_base/ft_game.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class PuntosTexto extends TextComponent with HasGameRef<FtGame> {
  PuntosTexto(Vector2 position)
      : super(text: 'Puntos: 0', priority: 3, position: position);

  void actualizarPuntos(int puntos) {
    this.text =
        'Puntos: $puntos'; // Actualiza el texto con la cantidad de puntos recibida
  }

  final borderPaint = Paint()
    ..color = Color(0xFF000000)
    ..style = PaintingStyle.stroke;
  final bgPaint = Paint()..color = Color(0xFFFF00FF);

  @override
  Future<void> onLoad() async {
    priority = 3; // Dibujar-lo per sobre de tot
  }
}
