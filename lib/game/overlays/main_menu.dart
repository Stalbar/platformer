import 'package:flutter/material.dart';
import 'package:platformer/game/game.dart';
import 'package:platformer/game/overlays/registration.dart';

import '../game_play.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';
  final SimplePlatformer gameRef;

  const MainMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(id);
                  gameRef.add(GamePlay());
                },
                child: const Text('Sign In'),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.add(RegistrationMenu.id);
                },
                child: const Text('Register')
              )
            )
          ],
        )
      )
    );
  }
}
