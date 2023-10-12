import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: const Text("Register My Notes"),
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
                const SizedBox(height: 30.0,),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    try {
                      final email = _email.text;
                      final password = _password.text;
                      await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );
                      Navigator.of(context).pushNamed(
                        verifyEmailRoute,
                      );
                      setState(() {
                        _loading = false;
                      });
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(context, 'Email Already In Use, Please Login',);
                      setState(() {
                        _loading = false;
                      });
                    } on UserNotLoggedInAuthException {
                      await showErrorDialog(context, 'User Not Logged In',);
                      setState(() {
                        _loading = false;
                      });
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                          context, 'Not A good Choice Of Password',);
                      setState(() {
                        _loading = false;
                      });
                    } on InvalidEmailAuthException {
                      await showErrorDialog(context, 'Invalid Email',);
                      setState(() {
                        _loading = false;
                      });
                    } on GenericAuthException {
                      await showErrorDialog(context, 'Something went wrong',);
                      setState(() {
                        _loading = false;
                      });
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(loginRoute);
                  },
                  child: const Text(
                    'Already Registered',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
