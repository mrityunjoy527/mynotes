import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_or_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase_options.dart';
// import 'dart:developer' show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {
      loginRoute: (context) => const Login(),
      registerRoute: (context) => const Register(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateOrUpdateNote(),
    },
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Firebase.initializeApp(
//             options: DefaultFirebaseOptions.currentPlatform),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return const Center(child: CircularProgressIndicator());
//             case ConnectionState.done:
//               return FutureBuilder(
//                 future: SharedPreferences.getInstance(),
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return const Center(child: CircularProgressIndicator());
//                     case ConnectionState.done:
//                       if (snapshot.hasData) {
//                         final sh = snapshot.data;
//                         if(sh != null) {
//                           final email = sh.get('userEmail');
//                           if(email != null) {
//                             return const NotesView();
//                           }
//                         }
//                         return const Login();
//                       }
//                       return const Login();
//                     default:
//                       return const Login();
//                   }
//                 },
//               );
//             default:
//               return const Login();
//           }
//         });
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                state is CounterStateInvalid ? state.invalidValue : '';
            return Column(
              children: [
                Text('Current Value = ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalid,
                  child: Text('Invalid Input = $invalidValue'),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter the number',
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(DecrementCounter(_controller.text));
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(IncrementCounter(_controller.text));
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementCounter extends CounterEvent {
  const IncrementCounter(String value) : super(value);
}

class DecrementCounter extends CounterEvent {
  const DecrementCounter(String value) : super(value);
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;

  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementCounter>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementCounter>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
