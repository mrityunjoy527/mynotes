import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService implements AuthProvider {

  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordResetLink({required String email}) => provider.sendPasswordResetLink(email: email);

  @override
  Future<SharedPreferences> initializeSharedPreference({String? email, String? id, bool? emailVerified}) =>
      provider.initializeSharedPreference(email: email, id: id, emailVerified: emailVerified);

  @override
  Future<void> initialize() => provider.initialize();
}