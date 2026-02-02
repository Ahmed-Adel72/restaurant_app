import 'package:restaurant_app/features/product_details/data/data_source/product_details_remote_datasource.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/entities/addon.dart';
import '../../domain/repositories/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductDetails> getProductDetails(int productId) async {
    try {
      return await remoteDataSource.getProductDetails(productId);
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }

  @override
  Future<List<Addon>> getProductAddons(int productId) async {
    try {
      return await remoteDataSource.getProductAddons(productId);
    } catch (e) {
      print('Repository Error loading addons: ${e.toString()}');
      return [];
    }
  }
}
