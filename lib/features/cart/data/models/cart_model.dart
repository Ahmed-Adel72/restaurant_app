import '../../domain/entities/cart.dart';
import 'cart_item_model.dart';

class CartModel extends Cart {
  CartModel({
    required List<CartItemModel> items,
    required super.totalPrice,
    required super.vat,
    required super.totalPriceWithTax,
    required super.totalItems,
    required super.totalPoints,
  }) : super(items: items);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    List<CartItemModel> items = [];

    if (json['cart_items'] != null && json['cart_items'] is List) {
      items = (json['cart_items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    }

    return CartModel(
      items: items,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      vat: double.tryParse(json['VAT']?.toString() ?? '0') ?? 0.0,
      totalPriceWithTax:
          double.tryParse(json['total_price_with_tax']?.toString() ?? '0') ??
          0.0,
      totalItems: int.tryParse(json['total_items']?.toString() ?? '0') ?? 0,
      totalPoints: int.tryParse(json['total_points']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_items': (items as List<CartItemModel>)
          .map((item) => item.toJson())
          .toList(),
      'total_price': totalPrice.toString(),
      'VAT': vat.toString(),
      'total_price_with_tax': totalPriceWithTax.toString(),
      'total_items': totalItems,
      'total_points': totalPoints,
    };
  }

  factory CartModel.empty() {
    return CartModel(
      items: [],
      totalPrice: 0.0,
      vat: 0.0,
      totalPriceWithTax: 0.0,
      totalItems: 0,
      totalPoints: 0,
    );
  }
}
