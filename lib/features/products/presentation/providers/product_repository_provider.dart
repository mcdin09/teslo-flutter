import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/domain/domaint.dart';
import 'package:teslo_shop/features/products/infrasctructure/infrastructure.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final productsRepository =  ProductsRepositoryImpl(
    datasource: ProductsDatasourceImpl(accessToken)
  );
  return productsRepository;
});