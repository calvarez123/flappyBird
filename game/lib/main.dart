import 'dart:io' show Platform;
import 'package:cupertino_base/waitingRoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'waitingRoom.dart'; // Importa la pantalla de sala de espera

void main() async {
  try {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      WidgetsFlutterBinding.ensureInitialized();
      await WindowManager.instance.ensureInitialized();
      windowManager.waitUntilReadyToShow().then(showWindow);
    }
  } catch (e) {
    print(e);
  }

  // Muestra la pantalla de sala de espera antes de la aplicación principal
  runApp(
    CupertinoApp(
      home: WaitingRoomScreen(), // Muestra la pantalla de sala de espera
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.white, // Fondo blanco
      ),
    ),
  );
}

void showWindow(_) async {
  windowManager.setMinimumSize(const Size(300.0, 600.0));
  await windowManager.setTitle('App');
}
