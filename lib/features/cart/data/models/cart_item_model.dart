import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    required super.productId,
    required super.productName,
    required super.productNameAr,
    required super.quantity,
    required super.price,
    required super.addonPrice,
    super.image,
    required List<CartAddonModel> addons,
    required super.points,
    required super.total,
  }) : super(addons: addons);

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    List<CartAddonModel> addons = [];

    if (json['addons'] != null && json['addons'] is List) {
      addons = (json['addons'] as List)
          .map((addon) => CartAddonModel.fromJson(addon))
          .toList();
    }

    return CartItemModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name_en'] ?? json['product_name'] ?? '',
      productNameAr: json['product_name_ar'] ?? json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      addonPrice:
          double.tryParse(json['addon_price']?.toString() ?? '0') ?? 0.0,
      image: json['image'],
      addons: addons,
      points: int.tryParse(json['points']?.toString() ?? '0') ?? 0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name_en': productName,
      'product_name_ar': productNameAr,
      'quantity': quantity,
      'price': price.toString(),
      'addon_price': addonPrice,
      'image': image,
      'addons': (addons as List<CartAddonModel>)
          .map((addon) => addon.toJson())
          .toList(),
      'points': points.toString(),
      'total': total.toString(),
    };
  }
}

class CartAddonModel extends CartAddon {
  CartAddonModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory CartAddonModel.fromJson(Map<String, dynamic> json) {
    return CartAddonModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price.toString()};
  }
}
