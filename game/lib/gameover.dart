import 'dart:io';
import 'package:cupertino_base/ft_game.dart';
import 'package:cupertino_base/waitingRoom.dart';
import 'package:flutter/material.dart';

class GameoverScreen extends StatefulWidget {
  final FtGame game;
  static const String id = 'gameover';
  static Map<String, int> ranking_names = {};

  const GameoverScreen({Key? key, required this.game}) : super(key: key);

  @override
  _GameoverScreenState createState() => _GameoverScreenState();
}

class _GameoverScreenState extends State<GameoverScreen> {
  bool showRanking = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: FileImage(File('assets/images/gameover.png'))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FtGame.websocket.disconnectFromServer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingRoomScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                'Restart',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showRanking = false;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                'SEGUIR PARTIDA',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showRanking = true;
                setState(() {
                  updateRanking();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                'RANKING',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: showRanking,
              child: Container(
                color: Colors.orange,
                padding: EdgeInsets.all(10),
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
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: GameoverScreen.ranking_names.length,
                              itemBuilder: (context, index) {
                                final rankingKeys =
                                GameoverScreen.ranking_names.keys.toList();
                                rankingKeys.sort((a, b) {
                                  final scoreA =
                                  GameoverScreen.ranking_names[a];
                                  final scoreB =
                                  GameoverScreen.ranking_names[b];
                                  if (scoreA != null && scoreB != null) {
                                    return scoreB
                                        .compareTo(scoreA); // Orden descendente
                                  } else {
                                    // Manejar el caso de valores nulos según tus necesidades
                                    return 0; // Por ejemplo, mantener el orden original
                                  }
                                });
                                final playerName = rankingKeys[index];
                                final playerScore =
                                GameoverScreen.ranking_names[playerName];
                                return Card(
                                  elevation: 3,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueGrey,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      '$playerName - $playerScore',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily:
                                        'Montserrat', // Cambia "Montserrat" por la fuente que prefieras
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Esta función se utiliza para actualizar el ranking
  void updateRanking() {
    setState(() {
      GameoverScreen.ranking_names;
    });
  }
}
