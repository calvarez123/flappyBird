import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'app.dart';

class WaitingRoomScreen extends StatefulWidget {
  static const String id =
      'waiting_room'; // Identificador único para WaitingRoomScreen
  @override
  _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  List<String> selectedImages = List.generate(1, (index) => '');
  List<String> buttonTexts = ['Nombre de Usuario']; // Lista de textos de botón
  List<bool> buttonEnabled = [
    true
  ]; // Lista de valores booleanos para habilitar/deshabilitar botones
  bool isLoading = false; // Estado de carga del botón "Preparado"

  @override
  Widget build(BuildContext context) {
    bool isReady = buttonEnabled.every((element) =>
        !element); // Verifica si todos los botones "Selecciona uno!!!" están deshabilitados

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Waiting Room'),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(1, (index) {
              return Column(
                children: [
                  CupertinoButton(
                    child: Text(buttonTexts[index]),
                    onPressed: buttonEnabled[index]
                        ? () => _handleSelectButtonPressed(index)
                        : null,
                  ),
                  buildImageContainer(index),
                ],
              );
            }),
          ),
          SizedBox(height: 20),
          // Filas para dirección IP y puerto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: CupertinoTextField(
                  placeholder: 'Dirección IP',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    UserSelect.IP = value;
                  },
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: CupertinoTextField(
                  placeholder: 'Puerto',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    UserSelect.port = value;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CupertinoButton(
            child: isLoading
                ? CupertinoActivityIndicator()
                : Text(
                    'Preparado'), // Cambia el texto o muestra un indicador de carga según el estado de isLoading
            onPressed: isLoading
                ? null
                : isReady
                    ? () {
                        setState(() {
                          isLoading =
                              true; // Establece el estado de carga a true
                        });

                        // Simula un retraso antes de redirigir a la siguiente pantalla
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(builder: (context) => App()),
                          );
                        });
                      }
                    : null,
          ),
        ],
      ),
    );
  }

  void _handleSelectButtonPressed(int index) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        String enteredText = '';

        return CupertinoAlertDialog(
          title: Text('Escribe tu nombre'),
          content: Column(
            children: [
              CupertinoTextField(
                placeholder: 'Pepito19',
                onChanged: (value) {
                  enteredText = value;
                  UserSelect.nom = enteredText;
                },
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Aceptar'),
              onPressed: () {
                setState(() {
                  buttonTexts[index] = enteredText;
                  buttonEnabled[index] = false;
                });

                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildImageContainer(int index) {
    String selectedImagePath = selectedImages[index];

    return GestureDetector(
      onTap: () {
        _openColorSelectionDialog(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            image: selectedImagePath.isNotEmpty
                ? DecorationImage(
                    image: AssetImage(selectedImagePath),
                    fit: BoxFit.cover,
                  )
                : null,
            color: selectedImagePath.isEmpty ? Colors.grey : null,
          ),
          child: selectedImagePath.isEmpty
              ? Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                )
              : null,
        ),
      ),
    );
  }

  void _openColorSelectionDialog(int index) {
    List<String> imagePaths = [
      'assets/images/amarillo.png',
      'assets/images/azul.png',
      'assets/images/negro.png',
      'assets/images/rojo.png',
    ]; // Lista de rutas de las imágenes

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Select Image'),
          content: Container(
            height: 200,
            width: 200,
            child: SingleChildScrollView(
              child: CupertinoScrollbar(
                child: Column(
                  children: List.generate(imagePaths.length, (itemIndex) {
                    String imagePath = imagePaths[itemIndex];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImages[index] = imagePath;
                          if (selectedImages[index].contains("amarillo")) {
                            UserSelect.img = "amarillo";
                          } else if (selectedImages[index].contains("azul")) {
                            UserSelect.img = "azul";
                          } else if (selectedImages[index].contains("rojo")) {
                            UserSelect.img = "rojo";
                          } else if (selectedImages[index].contains("negro")) {
                            UserSelect.img = "negro";
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          imagePath,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserSelect {
  static String img = "";
  static String nom = "Pepito19";
  static String IP = "localhost";
  static String port = "8888";
}
