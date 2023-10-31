import 'package:shared_preferences/shared_preferences.dart';

import 'auth_user.dart';

abstract class AuthProvider {

  Future<void> initialize();

  Future<SharedPreferences> initializeSharedPreference({String? email, String? id, bool? emailVerified});

  AuthUser? get currentUser;

  Future<AuthUser> login({required String email, required String password});

  Future<AuthUser> createUser({required String email, required String password});

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordResetLink({required String email});
}

