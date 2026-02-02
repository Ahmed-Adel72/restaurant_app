import '../../domain/entities/product_details.dart';

class ProductDetailsModel extends ProductDetails {
  ProductDetailsModel({
    required super.id,
    required super.name,
    required super.nameAr,
    required super.description,
    required super.descriptionAr,
    required super.price,
    required super.priceWithTax,
    super.image,
    super.onSale,
    required super.type,
    super.relatedIds,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    List<int> relatedIds = [];
    if (json['related_ids'] != null && json['related_ids'] is List) {
      relatedIds = (json['related_ids'] as List)
          .map((e) => int.tryParse(e.toString()) ?? 0)
          .toList();
    }

    return ProductDetailsModel(
      id: json['id'] ?? 0,
      name: json['name_en'] ?? json['name'] ?? '',
      nameAr: json['name_ar'] ?? json['name'] ?? '',
      description: json['description_en'] ?? json['description'] ?? '',
      descriptionAr: json['description_ar'] ?? json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      priceWithTax:
          double.tryParse(json['price_tax']?.toString() ?? '0') ?? 0.0,
      image: json['image'] ?? '',
      onSale: json['on_sale'] ?? false,
      type: json['type'] ?? 'simple',
      relatedIds: relatedIds,
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
      'on_sale': onSale,
      'type': type,
      'related_ids': relatedIds,
    };
  }
}
