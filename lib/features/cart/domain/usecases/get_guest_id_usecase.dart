import '../repositories/cart_repository.dart';

class GetGuestIdUseCase {
  final CartRepository repository;

  GetGuestIdUseCase(this.repository);

  Future<String> call() async {
    return await repository.getGuestId();
  }
}
