import 'dart:io';
import 'package:cupertino_base/ft_game.dart';
import 'package:flutter/material.dart';

class GameoverScreen extends StatelessWidget {
  final FtGame game;
  static const String id = 'gameover';

  const GameoverScreen({Key? key, required this.game}) : super(key: key);

  List<Widget> _buildNameList(List<String> names) {
    return names.map((name) => Text(name)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = [
      'Nombre1',
      'Nombre2',
      'Nombre3'
    ]; // Ejemplo de lista de nombres

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
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.orange, // Color de fondo para la ListView
              padding:
                  EdgeInsets.all(10), // Añadir espacio alrededor de la ListView
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'RANKING',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text((index + 1)
                              .toString()), // Muestra el número de jugador
                          title: Text(
                            names[index],
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
