import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/products/domain/domaint.dart';

class ProductMapper{
  static jsonToEntity(Map<String,dynamic> json)=>Product(
    id: json['id'],
    title: json['title'],
    price: double.parse(json['price'].toString()),
    description: json['description'],
    slug: json['slug'],
    stock: json['stock'],
    sizes: List<String>.from( json['sizes'].map((size)=>size) ),
    gender: json['gender'],
    tags: List<String>.from( json['tags'].map((tag)=>tag) ),
    images: json['images'].map(
      (String image)=>image.startsWith('http') 
        ? image //Images saved as url
        : '${Environment.apiUrl}/files/product/$image' //Image saved on api
    ),
    user: UserMapper.userJsonToEntity(json['user']),
  );
}