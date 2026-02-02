class AddToCartRequest {
  final String guestId;
  final List<AddToCartItem> items;

  AddToCartRequest({required this.guestId, required this.items});

  Map<String, dynamic> toJson() {
    return {
      'guest_id': guestId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class AddToCartItem {
  final int productId;
  final int quantity;
  final List<AddToCartAddon> addons;

  AddToCartItem({
    required this.productId,
    required this.quantity,
    required this.addons,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'addons': addons.map((addon) => addon.toJson()).toList(),
    };
  }
}

class AddToCartAddon {
  final int id;
  final String name;
  final String price;

  AddToCartAddon({required this.id, required this.name, required this.price});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}

class DeleteFromCartRequest {
  final String guestId;
  final int productId;
  final int quantity;

  DeleteFromCartRequest({
    required this.guestId,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {'guest_id': guestId, 'product_id': productId, 'quantity': quantity};
  }
}
