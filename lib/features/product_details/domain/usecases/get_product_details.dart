import '../entities/product_details.dart';
import '../repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<ProductDetails> call(int productId) async {
    return await repository.getProductDetails(productId);
  }
}
