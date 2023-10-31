import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(isLoading: false, exception: null));
    });
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      emit(const AuthStateRegistering(exception: null, isLoading: true));
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        emit(const AuthStateRegistering(exception: null, isLoading: false));
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final sharedPreference = await provider.initializeSharedPreference();
      final AuthUser? user;
      if(sharedPreference.containsKey('email')) {
        final email = sharedPreference.get('email') as String;
        final id = sharedPreference.get('id') as String;
        final emailVerified = sharedPreference.get('emailVerified') as bool;
        user = AuthUser(email: email, id: id, emailVerified: emailVerified);
      }else {
        user = provider.currentUser;
      }
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.emailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });
    on<AuthEventLogIn>((event, emit) async {
      try {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ));
        final email = event.email;
        final password = event.password;
        final user = await provider.login(email: email, password: password);
        if (!user.emailVerified) {
          emit(const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
              loadingText: 'Please wait while I log you in'));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          await provider.initializeSharedPreference(email: email, id: user.id, emailVerified: user.emailVerified);
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        final sharedPreference = await provider.initializeSharedPreference();
        sharedPreference.remove('email');
        sharedPreference.remove('id');
        sharedPreference.remove('emailVerified');
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return;
      }
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));
      bool? didSentEmail;
      Exception? exception;
      try {
        await provider.sendPasswordResetLink(email: email);
        didSentEmail = true;
      } on Exception catch (e) {
        didSentEmail = false;
        exception = e;
      }
      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSentEmail,
        isLoading: false,
      ));
    });
  }
}
