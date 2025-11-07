import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class LoginFormState{
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false, 
    this.isValid = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }){
    return LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return '''
      $isPosting;
      $isFormPosted;
      $isValid;
      $email;
      $password;
    ''';
  }
}

class LoginFormNotifier extends Notifier<LoginFormState> {
  Function(String, String)? loginUserCallback;
  
  @override
  LoginFormState build() {
    loginUserCallback = ref.watch(authProvider.notifier).loginUser;
    return LoginFormState();
  }

  void onEmailChange(String value){
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password])
    );
  }

  void onPasswordChanged(String value){
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email])
    );
  }

  void onSubmit() async{
    if(loginUserCallback == null) throw Exception('submit not implemented');
    _touchEveryField();
    if(!state.isValid) return;
    state = state.copyWith( isPosting : true );
    await loginUserCallback!(state.email.value, state.password.value);
    state = state.copyWith( isPosting : false );
  }

  void _touchEveryField(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      email: email, 
      password: password,
      isFormPosted: true,
      isValid: Formz.validate([email,password])
    );
  }
  
}

//Autodispose para que se limpie el loginFormState cuando se salga de la vista del login
final loginFormProvider = NotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>(LoginFormNotifier.new);
