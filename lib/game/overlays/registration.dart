import 'package:flutter/material.dart';
import 'package:platformer/game/model/storage.dart';

import '../game.dart';
import '../model/user.dart';

class RegistrationMenu extends StatefulWidget {
  static const id = 'Registration Menu';
  final SimplePlatformer gameRef;
  final UsersStorage storage;
  const RegistrationMenu({super.key, required this.gameRef, required this.storage});

  @override
  State<RegistrationMenu> createState() => _RegistrationMenuState();
}

class _RegistrationMenuState extends State<RegistrationMenu> {

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (registerUser(usernameController.text, passwordController.text)) {
                      widget.gameRef.overlays.remove(RegistrationMenu.id);
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.gameRef.overlays.remove(RegistrationMenu.id);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                    )
                  ),
                )
              ]
            )
          ],
        )
      )
    );
  }

  bool registerUser(String username, String password ) {
    if (username == '' || password == '') {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: createAlertDialog,
      );
      return false;
    }
    users.add(User(username: username, password: password));
    widget.storage.writeUsers(users);
    return true;
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