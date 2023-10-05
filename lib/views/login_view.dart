import 'package:flutter/material.dart';
import 'package:mynotes/firebase/firebase_service.dart';
import 'package:mynotes/firebase/firebase_user_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final FirebaseService _firebaseService;
  bool _loading = false;

  void login() async {
    setState(() {
      _loading = true;
    });
    final email = _email.text;
    final password = _password.text;
    FirebaseUser? user = await _firebaseService.loginUser(email, password);
    if(user != null) {
      Navigator.of(context).pushReplacementNamed('/notes_view');
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _firebaseService = FirebaseService();
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
      body: _loading? const Center(child: CircularProgressIndicator(),):
      Column(
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
          const Text("Make sure to verify your email"),
          TextButton(
            onPressed: () {
              login();
            },
            child: const Text('Login', style: TextStyle(fontSize: 18),),
          ),
          TextButton(
            onPressed: ()  {
              Navigator.of(context).pushReplacementNamed('/register');
            },
            child: const Text('Not Registered? Register', style: TextStyle(fontSize: 18),),
          ),
        ],
      ),
    );
  }
}
