import '../entities/product_details.dart';
import '../entities/addon.dart';

abstract class ProductDetailsRepository {
  Future<ProductDetails> getProductDetails(int productId);
  Future<List<Addon>> getProductAddons(int productId);
}
