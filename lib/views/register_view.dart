import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase/firebase_service.dart';
import 'package:mynotes/firebase/firebase_user_model.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final FirebaseService _firebaseService;
  bool _loading = false;


  void register() async {
    setState(() {
      _loading = true;
    });
    final email = _email.text;
    final password = _password.text;
    FirebaseUser? user = await _firebaseService.createUser(email, password);
    if(user != null) {
      Navigator.of(context).pushReplacementNamed(loginRoute);
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
        title: const Text("Register My Notes"),
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
          TextButton(
            onPressed: () async {
              register();
            },
            child: const Text('Register', style: TextStyle(fontSize: 18),),
          ),
          TextButton(
            onPressed: ()  {
              Navigator.of(context).pushReplacementNamed(loginRoute);
            },
            child: const Text('Already Registered & Verified? Login', style: TextStyle(fontSize: 18),),
          ),
        ],
      ),
    );
  }
}
