import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:developer' show log;

class FirebaseAuthProvider implements AuthProvider {


  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if(user != null) {
        await sendEmailVerification();
        // log('verification sent');
        return AuthUser.fromFirebase(user);
      }else {
        throw UserNotLoggedInAuthException();
      }
    }on FirebaseAuthException catch(e) {
      if(e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      }else if(e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      }else if(e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      }else {
        throw GenericAuthException();
      }
    } catch(e) {
      throw GenericAuthException();
    }
  }


  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      await FirebaseAuth.instance.signOut();
    }else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if(user != null) {
        if(!user.emailVerified) throw EmailNotVerifiedAuthException();
        final sharedPreference = await SharedPreferences.getInstance();
        sharedPreference.setString('userEmail', user.email!);
        return AuthUser.fromFirebase(user);
      }else {
        throw UserNotLoggedInAuthException();
      }
    }on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      }else if(e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      }else if(e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      }else {
        throw GenericAuthException();
      }
    } catch(e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      await user.sendEmailVerification();
    }else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      return AuthUser.fromFirebase(user);
    }
    return null;
  }

}