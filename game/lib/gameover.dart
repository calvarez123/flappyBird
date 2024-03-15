import 'dart:io';
import 'package:cupertino_base/ft_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameoverScreen extends StatelessWidget {
  final FtGame game;
  static const String id = 'gameover';

  const GameoverScreen({Key? key, required this.game})
      : super(key: key); // Corrección del constructor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Usamos FileImage en lugar de Image.asset y proporcionamos la ruta de la imagen
            Image(image: FileImage(File('assets/images/gameover.png'))),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
