import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platformer/game/game.dart';
import 'package:platformer/game/model/storage.dart';
import 'package:platformer/game/overlays/registration.dart';

import 'game/overlays/game_over.dart';
import 'game/overlays/main_menu.dart';
import 'game/overlays/pause_menu.dart';
import 'game/overlays/sign_in.dart';

void main() {
  runApp(const MyApp());
}

final _game = SimplePlatformer();
final _storage = UsersStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData (
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget<SimplePlatformer>(
          game: kDebugMode ? SimplePlatformer() : _game,
          overlayBuilderMap: {
            MainMenu.id: (context, game) => MainMenu(gameRef: game),
            PauseMenu.id: (context, game) => PauseMenu(gameRef: game),
            GameOver.id: (context, game) => GameOver(gameRef: game),
            RegistrationMenu.id: (context, game) => RegistrationMenu(gameRef: game, storage: _storage,), 
            SignInMenu.id: (context, game) => SignInMenu(gameRef: game, storage: _storage)
          },
          initialActiveOverlays: const [MainMenu.id],
        )
      )
    );
  }
}
