import 'package:dio/dio.dart';
import 'package:restaurant_app/core/network/api_constants.dart';
import 'package:restaurant_app/features/product_details/data/models/addon_model.dart';
import 'package:restaurant_app/features/product_details/data/models/product_details_model.dart';

class ProductDetailsRemoteDataSource {
  final Dio dio;

  ProductDetailsRemoteDataSource(this.dio);

  Future<ProductDetailsModel> getProductDetails(int productId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.productDetailsEndpoint}$productId',
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        return ProductDetailsModel.fromJson(response.data[0]);
      }

      throw Exception('Product not found');
    } on DioException catch (e) {
      throw Exception('Failed to load product details: ${e.message}');
    }
  }

  Future<List<AddonModel>> getProductAddons(int productId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.productAddonsEndpoint}$productId',
      );

      print('Addons Response: ${response.data}');

      if (response.data != null && response.data is Map) {
        final addonResponse = AddonResponseModel.fromJson(response.data);
        final addons = addonResponse.getAllAddons();

        print('Parsed Addons: ${addons.length}');
        for (var addon in addons) {
          print(
            'Addon: ${addon.name} - ${addon.nameAr} - Options: ${addon.options.length}',
          );
        }

        return addons;
      }

      print('No addons found in response');
      return [];
    } on DioException catch (e) {
      print('Failed to load addons: ${e.message}');
      return [];
    } catch (e) {
      print('Error parsing addons: $e');
      return [];
    }
  }
}
