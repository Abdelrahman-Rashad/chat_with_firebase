import 'package:chat_with_firebase/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/auth_service.dart';

// Auth State
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserFirebase userFirebase;

  const Authenticated(this.userFirebase);

  @override
  List<Object?> get props => [userFirebase];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(Authenticated(UserFirebase(
          name: user.displayName ?? '',
          email: user.email ?? '',
          uid: user.uid,
        )));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  UserFirebase get currentUser => UserFirebase(
        name: _authService.currentUser!.displayName ?? '',
        email: _authService.currentUser!.email ?? '',
        uid: _authService.currentUser!.uid,
      );

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      UserFirebase userFirebase = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      emit(Authenticated(userFirebase));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      emit(AuthLoading());
      UserFirebase userFirebase = await _authService
          .registerWithEmailAndPassword(name, email, password);
      emit(Authenticated(userFirebase));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      UserFirebase userFirebase = await _authService.signInWithGoogle();
      emit(Authenticated(userFirebase));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(AuthLoading());
      await _authService.resetPassword(email);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
