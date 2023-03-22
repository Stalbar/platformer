import 'package:flutter/material.dart';
import 'package:platformer/game/model/storage.dart';
import 'package:platformer/game/overlays/main_menu.dart';

import '../game.dart';
import '../game_play.dart';
import '../model/user.dart';

class SignInMenu extends StatefulWidget {
  static const id = 'SignInMenu';
  final SimplePlatformer gameRef;
  final UsersStorage storage;
  const SignInMenu({super.key, required this.gameRef, required this.storage});

  @override
  State<SignInMenu> createState() => _SignInMenuState();
}

class _SignInMenuState extends State<SignInMenu> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late List<User> users;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      loadUsers();
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Username...',
                hintStyle: TextStyle(
                  color: Colors.white,
                )
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: usernameController,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Password...',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: passwordController,
            ),
            ElevatedButton(
              onPressed: () {
                if (signIn(usernameController.text, passwordController.text)) {
                  widget.gameRef.overlays.remove(MainMenu.id);
                  widget.gameRef.overlays.remove(SignInMenu.id);
                  widget.gameRef.add(GamePlay());
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
      )
    );
  }

  bool signIn(String username, String password ) {
    if (username == '' || password == '') {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: createAlertDialog,
      );
      return false;
    }
    for (var user in users) {
      if (user.username == username && user.password == password) {
        return true;
      }
    }
    return false;
  }

  Future loadUsers() async {
    users = await widget.storage.readUsers();
  }

  Widget createAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: const Text('Invalid username or password'),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          }
        )
      ],
    );
  }
}