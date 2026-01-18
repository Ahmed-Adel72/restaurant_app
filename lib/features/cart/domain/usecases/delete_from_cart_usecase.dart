import '../repositories/cart_repository.dart';

class DeleteFromCartUseCase {
  final CartRepository repository;

  DeleteFromCartUseCase(this.repository);

  Future<void> call({
    required String guestId,
    required int productId,
    required int quantity,
  }) async {
    return await repository.deleteFromCart(
      guestId: guestId,
      productId: productId,
      quantity: quantity,
    );
  }
}
