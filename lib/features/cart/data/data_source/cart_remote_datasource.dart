import 'package:dio/dio.dart';
import 'package:restaurant_app/core/network/api_constants.dart';
import 'package:restaurant_app/features/cart/data/models/cart_model.dart';
import 'package:restaurant_app/features/cart/data/models/cart_request_model.dart';

abstract class CartRemoteDataSource {
  Future<String> getGuestId();
  Future<CartModel> getCart(String guestId);
  Future<String> addToCart(AddToCartRequest request);
  Future<void> deleteFromCart(DeleteFromCartRequest request);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSourceImpl(this.dio);

  @override
  Future<String> getGuestId() async {
    try {
      final response = await dio.get(ApiConstants.guestIdEndpoint);

      if (response.data != null && response.data['guest_id'] != null) {
        return response.data['guest_id'];
      }

      throw Exception('Failed to get guest ID');
    } on DioException catch (e) {
      throw Exception('Failed to get guest ID: ${e.message}');
    }
  }

  @override
  Future<CartModel> getCart(String guestId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.cartEndpoint}?guest_id=$guestId',
      );

      if (response.data != null && response.data is Map) {
        return CartModel.fromJson(response.data);
      }

      return CartModel.empty();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return CartModel.empty();
      }
      throw Exception('Failed to load cart: ${e.message}');
    }
  }

  @override
  Future<String> addToCart(AddToCartRequest request) async {
    try {
      final response = await dio.post(
        ApiConstants.cartEndpoint,
        data: request.toJson(),
      );
      if (response.data != null && response.data['guest_id'] != null) {
        return response.data['guest_id'];
      }

      throw Exception('Failed to add to cart');
    } on DioException catch (e) {
      throw Exception('Failed to add to cart: ${e.message}');
    }
  }

  @override
  Future<void> deleteFromCart(DeleteFromCartRequest request) async {
    try {
      final response = await dio.delete(
        ApiConstants.cartEndpoint,
        data: request.toJson(),
      );
      print('Delete from Cart Response: ${response.data}');
    } on DioException catch (e) {
      throw Exception('Failed to delete from cart: ${e.message}');
    }
  }
}
