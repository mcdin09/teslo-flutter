import 'package:teslo_shop/features/auth/domain/domain.dart';

class AuthDatasourceImpl extends AuthDatasource{

  
  Future <User> login(String mail, String password){
    throw UnimplementedError();
  }

  Future <User> register(String mail, String password, String fullName){
    throw UnimplementedError();
  }

  Future <User> checkStatus(String token){
    throw UnimplementedError();
  }
}