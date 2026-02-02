import 'package:restaurant_app/features/cart/domain/entities/cart_item.dart';

class Cart {
  final List<CartItem> items;
  final double totalPrice;
  final double vat;
  final double totalPriceWithTax;
  final int totalItems;
  final int totalPoints;

  Cart({
    required this.items,
    required this.totalPrice,
    required this.vat,
    required this.totalPriceWithTax,
    required this.totalItems,
    required this.totalPoints,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}
