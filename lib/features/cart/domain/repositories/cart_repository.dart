import '../entities/cart.dart';

abstract class CartRepository {
  Future<String> getGuestId();
  Future<Cart> getCart(String guestId);
  Future<void> addToCart({
    required String guestId,
    required int productId,
    required int quantity,
    required List<Map<String, dynamic>> addons,
  });
  Future<void> deleteFromCart({
    required String guestId,
    required int productId,
    required int quantity,
  });
  Future<void> clearCart();
}
