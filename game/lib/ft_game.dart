import 'dart:convert';
import 'dart:math';

import 'package:cupertino_base/pipe.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ft_opponent.dart';
import 'ft_player.dart';
import 'utils_websockets.dart';

class FtGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  Timer? pipeTimer;
  FtGame() {}

  late WebSocketsHandler websocket;
  FtPlayer? _player;
  final List<FtOpponent> _opponents = [];

  DateTime? lastUpdateTime;
  double serverUpdateInterval = 0; // En segons

  @override
  Future<void> onLoad() async {
    //debugMode = true; // Uncomment to see the bounding boxes
    await images.loadAll([
      'player.png',
      'rocket.png',
    ]);
    camera.viewfinder.anchor = Anchor.topLeft;
    initializeGame(loadHud: true);
    camera.viewport =
        FixedResolutionViewport(resolution: Vector2.all(canvasSize.x));

    generatePipesPeriodically();
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }
/*----------------tocando--------------- */

  void generatePipesPeriodically() {
    // Llama a la función para generar tuberías cada 3 segundos
    generatePipe();
    Future.delayed(Duration(seconds: 3), generatePipesPeriodically);
  }

  void generatePipe() {
    // Calcular la posición y de la tubería superior en el borde superior de la cámara
    final double topPipeY = 0;

    // Calcular la altura de la tubería superior de manera aleatoria
    final double randomTopPipeHeight =
        Random().nextDouble() * (canvasSize.y - Pipe.pipeGap);

    // Calcular la posición y de la tubería inferior con un pequeño desplazamiento más abajo del borde inferior de la cámara
    final double bottomPipeY = canvasSize.y - Pipe.pipeGap;

    // Calcular la altura de la tubería inferior de manera aleatoria
    final double randomBottomPipeHeight = Random().nextDouble() *
        (canvasSize.y - topPipeY - Pipe.pipeGap - randomTopPipeHeight);

    final Pipe topPipe =
        Pipe((canvasSize.x / 2), topPipeY, height: randomTopPipeHeight);
    final Pipe bottomPipe =
        Pipe((canvasSize.x / 2), bottomPipeY, height: randomBottomPipeHeight);

    world.add(topPipe);
    world.add(bottomPipe);

    // Configurar un temporizador para eliminar las tuberías después de cierto tiempo
    Future.delayed(Duration(seconds: 5), () {
      world.remove(topPipe);
      world.remove(bottomPipe);
    });
  }

  /*----------------tocando ------------------------------*/

  void reset() {
    initializeGame(loadHud: false);
  }

  void initializeGame({required bool loadHud}) {
    // Initialize websocket
    initializeWebSocket();
  }
/*
  @override
  void update(double deltaTime) {
    super.update(deltaTime);

    // Mover la cámara hacia la derecha
    double displacement =
        100 * deltaTime; // Ajusta la velocidad según tu necesidad
    Vector2 movement = Vector2(displacement, 0);
    camera.moveBy(movement);
  }
  */

  void initializeWebSocket() {
    websocket = WebSocketsHandler();
    websocket.connectToServer("localhost", 8888, serverMessageHandler);
  }

  void serverMessageHandler(String message) {
    if (kDebugMode) {
      // print("Message received: $message");
    }

    // Processar els missatges rebuts
    final data = json.decode(message);

    // Comprovar si 'data' és un Map i si 'type' és igual a 'data'
    if (data is Map<String, dynamic>) {
      if (data['type'] == 'welcome') {
        initPlayer(data['id'].toString());
        //generatePipe();
      }
      if (data['type'] == 'data') {
        var value = data['value'];
        if (value is List) {
          updateOpponents(value);
        }
      }
    }
  }

  void initPlayer(String id) {
    final List<String> randomNames = [
      "Alice",
      "Bob",
      "Charlie",
      "David",
      "Eva",
      "Frank",
      "Grace",
      "Hank",
      "Ivy",
      "Jack"
    ];
    final random = Random();
    final randomName = randomNames[random.nextInt(randomNames.length)];
    Color playerColor = getRandomColor();
    _player = FtPlayer(
        id: id,
        position: Vector2((canvasSize.x / 2), (canvasSize.y / 2)),
        color: playerColor);
    world.add(_player as Component);

    websocket.sendMessage(
        '{"type": "init", "name": "$randomName", "color": "${colorToHex(playerColor)}"}');
  }

  void updateOpponents(List<dynamic> opponentsData) {
    // Crea una llista amb els ID dels oponents actuals
    final currentOpponentIds = _opponents.map((op) => op.id).toList();

    if (_player == null) {
      return;
    }

    DateTime now = DateTime.now();
    if (lastUpdateTime != null) {
      serverUpdateInterval =
          now.difference(lastUpdateTime!).inMilliseconds / 1000.0;
    }
    lastUpdateTime = now;
    var interpolationSpeed = 1 / serverUpdateInterval;

    for (var opponentData in opponentsData) {
      final id = opponentData['id'];
      String clientColor = "0x00000000";
      double clientX = -100.0;
      double clientY = -100.0;

      if (id == _player?.id || opponentData['name'] == null) {
        // No tenim nom, no podem crear l'oponent
        // (o bé és el nostre player que encara no ha informat el nom al servidor)
        continue;
      }

      if (opponentData['color'] != null) {
        clientColor = opponentData['color'];
      }
      if (opponentData['x'] != null) {
        clientX = opponentData['x'].toDouble();
      }
      if (opponentData['y'] != null) {
        clientY = opponentData['y'].toDouble();
      }

      if (!currentOpponentIds.contains(id)) {
        // Afegir l'oponent nou
        var newOpponent = FtOpponent(
          id: id,
          position: Vector2(clientX, clientY),
          color: hexToColor(clientColor),
        );
        if (newOpponent.id != _player?.id) {
          _opponents.add(newOpponent);
          world.add(newOpponent);
        }
      } else {
        // Definir la posició fins a la que s'ha de interpolar la posició de l'oponent
        var opponent = _opponents.firstWhere((op) => op.id == id);
        opponent.interpolationSpeed = interpolationSpeed;
        opponent.targetPosition = Vector2(clientX, clientY);
        // opponent.color = hexToColor(clientColor);
      }
    }

    // Eliminar oponents que ja no estan en la llista
    _opponents.removeWhere((opponent) {
      bool shouldRemove =
          !opponentsData.any((data) => data['id'] == opponent.id);
      if (shouldRemove) {
        world.remove(opponent);
      }
      return shouldRemove;
    });
  }

  Color hexToColor(String hexString) {
    // Eliminar el prefix '0x' si està present
    hexString = hexString.replaceFirst('0x', '');

    // Si la cadena comença amb '#', eliminar-ho
    if (hexString.startsWith('#')) {
      hexString = hexString.substring(1);
    }

    // Si només tenim 6 caràcters, afegir 'ff' al principi per l'opacitat
    if (hexString.length == 6) {
      hexString = 'ff$hexString';
    }

    // Convertir la cadena en un enter i crear un Color
    return Color(int.parse(hexString, radix: 16));
  }

  String colorToHex(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Color getRandomColor() {
    final random = Random();
    final hue = random.nextDouble() * 360;
    return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
  }
}
