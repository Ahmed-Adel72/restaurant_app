part of 'product_details_cubit.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetails product;
  final List<Addon> addons;
  final int quantity;
  final Map<String, AddonOption?> selectedAddons;

  ProductDetailsLoaded({
    required this.product,
    required this.addons,
    required this.quantity,
    required this.selectedAddons,
  });
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError(this.message);
}
