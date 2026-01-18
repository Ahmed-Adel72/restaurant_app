import '../entities/addon.dart';
import '../repositories/product_details_repository.dart';

class GetProductAddonsUseCase {
  final ProductDetailsRepository repository;

  GetProductAddonsUseCase(this.repository);

  Future<List<Addon>> call(int productId) async {
    return await repository.getProductAddons(productId);
  }
}
