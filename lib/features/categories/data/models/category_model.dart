import '../../domain/entities/category.dart';
import '../../../product_details/data/models/product_model.dart';

class CategoryModel extends Category {
  final List<ProductModel> productModels;

  CategoryModel({
    required super.id,
    required super.name,
    required super.nameAr,
    super.image,
    required this.productModels,
  }) : super(products: productModels);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<ProductModel> products = [];

    if (json['products'] != null && json['products'] is List) {
      products = (json['products'] as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList();
    }

    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name_en'] ?? json['name'] ?? '',
      nameAr: json['name_ar'] ?? json['name'] ?? '',
      image: json['image'],
      productModels: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': name,
      'name_ar': nameAr,
      'image': image,
      'products': productModels.map((p) => p.toJson()).toList(),
    };
  }
}
