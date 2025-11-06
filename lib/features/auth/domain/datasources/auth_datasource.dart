import 'package:teslo_shop/features/auth/domain/entities/user.dart';

abstract class AuthDatasource{
  Future <User> login(String mail, String password);
  Future <User> register(String mail, String password, String fullName);
  Future <User> checkStatus(String token);
}