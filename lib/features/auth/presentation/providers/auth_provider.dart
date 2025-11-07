import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

final authProvider = NotifierProvider<AuthNotifier,AuthState>((){
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends Notifier<AuthState>{

  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository});

  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> loginUser(String email, String password) async{
    await Future.delayed(const Duration(milliseconds: 500));
    try{
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    }
    on CustomError catch(e){
      logout(error: e.message);
    }
    catch(e){
      logout(error: 'Error no controlado');
    }
  }

  void registerUser(String email, String password, String fullName) async{

  }

  void checkAuthStatus() async{

  }

  void _setLoggedUser(User user){
    //TODO: Guardar el token en el dispositivo
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: null
    );
  }

  Future<void> logout({String? error}) async{
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: error
    );
  }

}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState{
  final AuthStatus authStatus;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage})=> AuthState(
    authStatus : authStatus ?? this.authStatus,
    user : user ?? this.user  ,
    errorMessage : errorMessage ?? errorMessage
  );

}