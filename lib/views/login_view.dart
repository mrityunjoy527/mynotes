import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
// import 'dart:developer' as devtools show log;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool _loading;

  @override
  void initState() {
    _loading = false;
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login My Notes"),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here ..',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here ..',
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              try {
                final email = _email.text;
                final password = _password.text;
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute, (route) => false);
                setState(() {
                  _loading = false;
                });
              } on EmailNotVerifiedAuthException {
                await showErrorDialog(context, 'Email Not Verified');
                setState(() {
                  _loading = false;
                });
              } on UserNotLoggedInAuthException {
                await showErrorDialog(context, 'User Not Logged In');
                setState(() {
                  _loading = false;
                });
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'User Not Found, Please Register');
                setState(() {
                  _loading = false;
                });
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'Wrong Password');
                setState(() {
                  _loading = false;
                });
              } on GenericAuthException catch (e) {
                await showErrorDialog(context, 'Something Went Wrong');
                setState(() {
                  _loading = false;
                });
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(registerRoute);
            },
            child: const Text(
              'Not Registered',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}