import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String email;
  final String id;
  final bool emailVerified;

  const AuthUser({required this.email, required this.id, required this.emailVerified,});

  factory AuthUser.fromFirebase(User user) => AuthUser(email: user.email!, id: user.uid, emailVerified: user.emailVerified);
}