import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call({
    required String guestId,
    required int productId,
    required int quantity,
    required List<Map<String, dynamic>> addons,
  }) async {
    return await repository.addToCart(
      guestId: guestId,
      productId: productId,
      quantity: quantity,
      addons: addons,
    );
  }
}
