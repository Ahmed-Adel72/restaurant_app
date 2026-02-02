class CartItem {
  final int productId;
  final String productName;
  final String productNameAr;
  final int quantity;
  final double price;
  final double addonPrice;
  final String? image;
  final List<CartAddon> addons;
  final int points;
  final double total;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required this.quantity,
    required this.price,
    required this.addonPrice,
    this.image,
    required this.addons,
    required this.points,
    required this.total,
  });
}

class CartAddon {
  final int id;
  final String name;
  final double price;

  CartAddon({required this.id, required this.name, required this.price});
}
