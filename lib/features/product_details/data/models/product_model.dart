import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.nameAr,
    required super.description,
    required super.descriptionAr,
    required super.price,
    required super.priceWithTax,
    super.image,
    required super.categoryId,
    super.onSale,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name_en'] ?? json['name'] ?? '',
      nameAr: json['name_ar'] ?? json['name'] ?? '',
      description: json['description_en'] ?? json['description'] ?? '',
      descriptionAr: json['description_ar'] ?? json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      priceWithTax:
          double.tryParse(json['price_tax']?.toString() ?? '0') ?? 0.0,
      image: json['image'] ?? '',
      categoryId:
          (json['category_ids'] != null &&
              (json['category_ids'] as List).isNotEmpty)
          ? (json['category_ids'] as List).first
          : 0,
      onSale: json['on_sale'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': name,
      'name_ar': nameAr,
      'description_en': description,
      'description_ar': descriptionAr,
      'price': price,
      'price_tax': priceWithTax,
      'image': image,
      'category_ids': [categoryId],
      'on_sale': onSale,
    };
  }
}
