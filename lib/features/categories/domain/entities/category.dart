import 'package:restaurant_app/features/product_details/domain/entities/product.dart';

class Category {
  final int id;
  final String name;
  final String nameAr;
  final String? image;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.nameAr,
    this.image,
    this.products = const [],
  });
}
