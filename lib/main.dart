import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_or_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateOrUpdateNote(),
    },
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        }else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthStateForgotPassword:
            return const ForgotPassword();
          case AuthStateLoggedIn:
            return const NotesView();
          case AuthStateNeedsVerification:
            return const VerifyEmailView();
          case AuthStateLoggedOut:
            return const Login();
          case AuthStateRegistering:
            return const Register();
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
