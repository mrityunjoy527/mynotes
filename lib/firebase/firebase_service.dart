import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/firebase/firebase_user_model.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;

  FirebaseUser? makeUser(User user) {
    return FirebaseUser(user.email, user.uid);
  }

  Future<FirebaseUser?> createUser(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      user?.sendEmailVerification();
      // print(user);
      return makeUser(user!);
    }catch(e) {
      return null;
    }
  }

  Future<FirebaseUser?> loginUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      bool isVerified = user?.emailVerified ?? false;
      if(!isVerified) return null;
      // print(user);
      return makeUser(user!);
    }catch(e) {
      return null;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}