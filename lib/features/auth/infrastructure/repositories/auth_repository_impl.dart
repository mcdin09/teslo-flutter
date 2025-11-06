import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDatasource datasource;

  AuthRepositoryImpl(
    AuthDatasource? datasource
  ): datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkStatus(String token) {
    return datasource.checkStatus(token);
  }

  @override
  Future<User> login(String mail, String password) {
    return datasource.login(mail, password);
  }

  @override
  Future<User> register(String mail, String password, String fullName) {
    return datasource.register(mail, password, fullName);
  }

}