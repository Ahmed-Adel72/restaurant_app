import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<Cart> call(String guestId) async {
    return await repository.getCart(guestId);
  }
}
