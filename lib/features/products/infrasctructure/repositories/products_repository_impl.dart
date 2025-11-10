import 'package:teslo_shop/features/products/domain/domaint.dart';

class ProductsRepositoryImpl extends ProductsRepository {

  final ProductsDatasource datasource;

  ProductsRepositoryImpl({required this.datasource});

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return datasource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProducts(String id) {
    return datasource.getProducts(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    return datasource.searchProductByTerm(term);
  }

}