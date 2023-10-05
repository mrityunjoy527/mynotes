import 'package:flutter/material.dart';

import '../firebase/firebase_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseService _firebaseService;

  @override
  void initState() {
    _firebaseService = FirebaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes View'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (val) async {
              final wantLogout = await showAlertDialog(context);
              if(wantLogout) {
                await _firebaseService.logOut();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('You are on the Notes View Page'),
      ),
    );
  }
}

Future<bool> showAlertDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
            },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
            },
                child: const Text('Yes')),
          ],
          title: const Text('Log out'),
          content: const Text('Do you really want to log out ?'),
        );
      }
    ).then((value) => value ?? false);
}

enum MenuAction {
  logout
}
