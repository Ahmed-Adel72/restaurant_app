import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item.dart';
import 'package:restaurant_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/delete_from_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/get_guest_id_usecase.dart';
import 'package:restaurant_app/features/cart/presentation/cubit/cart_states.dart';

class CartCubit extends Cubit<CartState> {
  final GetGuestIdUseCase getGuestIdUseCase;
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final DeleteFromCartUseCase deleteFromCartUseCase;

  String? _guestId;

  CartCubit({
    required this.getGuestIdUseCase,
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.deleteFromCartUseCase,
  }) : super(CartInitial());

  Future<void> initialize() async {
    try {
      _guestId = await getGuestIdUseCase();
      await loadCart();
    } catch (e) {
      print('Error initializing cart: $e');
      emit(CartError('Error_initializing_cart'.tr()));
    }
  }

  Future<void> loadCart() async {
    if (_guestId == null) {
      await initialize();
      return;
    }
    emit(CartLoading());
    try {
      final cart = await getCartUseCase(_guestId!);
      if (cart.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded(cart: cart));
      }
    } catch (e) {
      print('Error loading cart: $e');
      emit(CartEmpty());
    }
  }

  Future<void> addToCart({
    required int productId,
    required int quantity,
    required List<Map<String, dynamic>> addons,
  }) async {
    if (_guestId == null) {
      await initialize();
      if (_guestId == null) {
        emit(CartError('Something went wrong'));
        return;
      }
    }

    try {
      await addToCartUseCase(
        guestId: _guestId!,
        productId: productId,
        quantity: quantity,
        addons: addons,
      );
      await loadCart();
    } catch (e) {
      print('Error adding to cart: $e');
      emit(CartError('Error_initializing_cart'.tr()));
      await loadCart();
    }
  }

  Future<void> deleteFromCart({
    required int productId,
    required int quantity,
  }) async {
    if (_guestId == null) {
      emit(CartError('Something went wrong'));
      return;
    }

    try {
      await deleteFromCartUseCase(
        guestId: _guestId!,
        productId: productId,
        quantity: quantity,
      );
      await loadCart();
    } catch (e) {
      print('Error deleting from cart: $e');
      emit(CartError('Error_initializing_cart'.tr()));
      await loadCart();
    }
  }

  Future<void> incrementQuantity(int productId) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = _findItemById(currentState.cart.items, productId);

      if (item != null) {
        await addToCart(
          productId: productId,
          quantity: 1,
          addons: item.addons
              .map(
                (addon) => {
                  'id': addon.id,
                  'name': addon.name,
                  'price': addon.price.toString(),
                },
              )
              .toList(),
        );
      }
    }
  }

  Future<void> decrementQuantity(int productId) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = _findItemById(currentState.cart.items, productId);

      if (item != null) {
        await deleteFromCart(productId: productId, quantity: 1);
      }
    }
  }

  Future<void> removeItem(int productId) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = _findItemById(currentState.cart.items, productId);

      if (item != null) {
        await deleteFromCart(productId: productId, quantity: item.quantity);
      }
    }
  }

  CartItem? _findItemById(List<CartItem> items, int productId) {
    for (var item in items) {
      if (item.productId == productId) {
        return item;
      }
    }
    return null;
  }

  int get itemCount {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.totalItems;
    }
    return 0;
  }
}
