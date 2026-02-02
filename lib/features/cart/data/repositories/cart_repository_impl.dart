import 'package:restaurant_app/features/cart/data/data_source/cart_local_datasource.dart';
import 'package:restaurant_app/features/cart/data/data_source/cart_remote_datasource.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_request_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<String> getGuestId() async {
    try {
      String? localGuestId = await localDataSource.getGuestId();

      if (localGuestId != null && localGuestId.isNotEmpty) {
        return localGuestId;
      }
      final guestId = await remoteDataSource.getGuestId();
      await localDataSource.saveGuestId(guestId);
      return guestId;
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }

  @override
  Future<Cart> getCart(String guestId) async {
    try {
      return await remoteDataSource.getCart(guestId);
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }

  @override
  Future<void> addToCart({
    required String guestId,
    required int productId,
    required int quantity,
    required List<Map<String, dynamic>> addons,
  }) async {
    try {
      final addonsRequest = addons.map((addon) {
        return AddToCartAddon(
          id: addon['id'] ?? 0,
          name: addon['name'] ?? '',
          price: addon['price']?.toString() ?? '0',
        );
      }).toList();

      final request = AddToCartRequest(
        guestId: guestId,
        items: [
          AddToCartItem(
            productId: productId,
            quantity: quantity,
            addons: addonsRequest,
          ),
        ],
      );

      final newGuestId = await remoteDataSource.addToCart(request);
      await localDataSource.saveGuestId(newGuestId);
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFromCart({
    required String guestId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final request = DeleteFromCartRequest(
        guestId: guestId,
        productId: productId,
        quantity: quantity,
      );
      await remoteDataSource.deleteFromCart(request);
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await localDataSource.clearGuestId();
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }
}
