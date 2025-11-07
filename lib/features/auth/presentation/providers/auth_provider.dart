import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import '../../domain/domain.dart';

typedef ListennerFunct = void Function(AuthState? previous, AuthState next);

final authProvider = NotifierProvider<AuthNotifier,AuthState>((){
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageServiceImpl = KeyValueStorageServiceImpl();
  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageServiceImpl
  );
});

class AuthNotifier extends Notifier<AuthState>{

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({required this.keyValueStorageService, required this.authRepository});

  @override
  AuthState build() {
    checkAuthStatus();
    return AuthState();
  }

  Future<void> loginUser(String email, String password) async{
    await Future.delayed(const Duration(milliseconds: 500));
    try{
      final user = await authRepository.login(email, password);
      await _setLoggedUser(user);
    }
    on CustomError catch(e){
      await logout(error: e.message);
    }
    catch(e){
      await logout(error: 'Error no controlado');
    }
  }

  void registerUser(String email, String password, String fullName) async{

  }

  set listtener(ListennerFunct listennerFunct){
    listenSelf(listennerFunct);
  }

  void checkAuthStatus() async{
    final token = await keyValueStorageService.getValue<String>('token');
    if(token == null) return logout();
    try{
      final user = await authRepository.checkStatus(token);
      _setLoggedUser(user);
    }
    catch(e){
      logout();
    }
  }

  Future<void> _setLoggedUser(User user) async{
    //TODO: Guardar el token en el dispositivo
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: null
    );
  }

  Future<void> logout({String? error}) async{
    await keyValueStorageService.removeKey('token');
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