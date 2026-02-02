import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/product_details/domain/entities/addon.dart';
import 'package:restaurant_app/features/product_details/domain/entities/product_details.dart';
import 'package:restaurant_app/features/product_details/domain/usecases/get_addons.dart';
import 'package:restaurant_app/features/product_details/domain/usecases/get_product_details.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final GetProductAddonsUseCase getProductAddonsUseCase;

  int quantity = 1;
  Map<String, AddonOption?> selectedAddons = {};

  ProductDetailsCubit(
    this.getProductDetailsUseCase,
    this.getProductAddonsUseCase,
  ) : super(ProductDetailsInitial());

  Future<void> loadProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    try {
      final product = await getProductDetailsUseCase(productId);
      final addons = await getProductAddonsUseCase(productId);

      selectedAddons.clear();

      for (var addon in addons) {
        print(
          'Processing addon: ${addon.name} with ${addon.options.length} options',
        );

        if (addon.options.isNotEmpty) {
          AddonOption? defaultOption;

          for (var option in addon.options) {
            if (option.selectedByDefault) {
              defaultOption = option;
              break;
            }
          }
          if (defaultOption == null) {
            defaultOption = addon.options[0];
          }

          selectedAddons[addon.id] = defaultOption;
          print('Selected addon for ${addon.name}: ${defaultOption.label}');
        }
      }

      quantity = 1;

      emit(
        ProductDetailsLoaded(
          product: product,
          addons: addons,
          quantity: quantity,
          selectedAddons: Map.from(selectedAddons),
        ),
      );

      print('Product details loaded successfully');
    } catch (e, stackTrace) {
      print('Error loading product details: $e');
      print('Stack trace: $stackTrace');
      emit(ProductDetailsError('Error_loading_product_details'.tr()));
    }
  }

  void incrementQuantity() {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      quantity++;
      emit(
        ProductDetailsLoaded(
          product: currentState.product,
          addons: currentState.addons,
          quantity: quantity,
          selectedAddons: Map.from(selectedAddons),
        ),
      );
    }
  }

  void decrementQuantity() {
    if (state is ProductDetailsLoaded && quantity > 1) {
      final currentState = state as ProductDetailsLoaded;
      quantity--;
      emit(
        ProductDetailsLoaded(
          product: currentState.product,
          addons: currentState.addons,
          quantity: quantity,
          selectedAddons: Map.from(selectedAddons),
        ),
      );
    }
  }

  void selectAddonOption(String addonId, AddonOption option) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      selectedAddons[addonId] = option;

      print('Selected option for addon $addonId: ${option.label}');

      emit(
        ProductDetailsLoaded(
          product: currentState.product,
          addons: currentState.addons,
          quantity: quantity,
          selectedAddons: Map.from(selectedAddons),
        ),
      );
    }
  }

  double calculateTotalPrice() {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      double total = currentState.product.price;
      selectedAddons.forEach((addonId, option) {
        if (option != null) {
          total += option.price;
        }
      });

      return total * quantity;
    }
    return 0.0;
  }

  bool canAddToCart() {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      for (var addon in currentState.addons) {
        if (addon.isRequired) {
          final selected = selectedAddons[addon.id];
          if (selected == null) {
            print('Required addon not selected: ${addon.name}');
            return false;
          }
        }
      }
      return true;
    }
    return false;
  }

  String? getSelectedAddonName(String addonId, bool isArabic) {
    final option = selectedAddons[addonId];
    if (option == null) return null;
    return isArabic ? option.labelAr : option.label;
  }

  Map<String, String> getAddonSummary(bool isArabic) {
    Map<String, String> summary = {};

    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;

      for (var addon in currentState.addons) {
        final option = selectedAddons[addon.id];
        if (option != null) {
          final addonName = isArabic ? addon.nameAr : addon.name;
          final optionName = isArabic ? option.labelAr : option.label;
          summary[addonName] = optionName;
        }
      }
    }

    return summary;
  }
}
