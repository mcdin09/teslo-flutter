import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_repository_provider.dart';

final productProvier = AsyncNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>(ProductNotifier.new);

class ProductNotifier extends AsyncNotifier<ProductState>{

  late final ProductsRepository productsRepository;
  final String id;

  ProductNotifier(this.id);

  @override
  FutureOr<ProductState> build() async {
    productsRepository = ref.watch(productsRepositoryProvider);
    final product = await loadProduct();
    final state = ProductState(id: id, product: product, isLoading: false);
    return state;
  }

  Product _newEmptyProduct(){
    return Product(
      id: 'new', 
      title: '', 
      price: 0, 
      description: '', 
      slug: '', 
      stock: 0, 
      sizes: ['M'], 
      gender: 'women', 
      tags: [], 
      images: [], 
    );
  }

  Future<Product?> loadProduct() async{

    try{
      if(id == 'new') return _newEmptyProduct();
      return await productsRepository.getProductById(id);
    }catch(ex){
      return null;
    }

  }

}

class ProductState{
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id, 
    this.product, 
    this.isLoading = true, 
    this.isSaving = false
  });


  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  })=>ProductState(
    id : id ?? this.id,
    product : product ?? this.product,
    isLoading : isLoading ?? this.isLoading,
    isSaving : isSaving ?? this.isSaving,
  );



}