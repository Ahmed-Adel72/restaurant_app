import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/categories/domain/entities/category.dart';
import 'package:restaurant_app/features/product_details/domain/entities/product.dart';
import 'package:restaurant_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:restaurant_app/features/categories/presentation/cubit/categories_states.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUsecase getCategories;

  CategoriesCubit(this.getCategories) : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());

    try {
      final categories = await getCategories();

      if (categories.isNotEmpty) {
        emit(
          CategoriesSuccess(
            categories: categories,
            selectedCategoryId: categories.first.id,
          ),
        );
      } else {
        emit(CategoriesError('لا توجد فئات متاحة'));
      }
    } catch (e) {
      print('Error loading categories: $e');
      emit(CategoriesError('Something went wrong while loading categories'));
    }
  }

  void selectCategory(int categoryId) {
    if (state is CategoriesSuccess) {
      final currentState = state as CategoriesSuccess;
      emit(
        CategoriesSuccess(
          categories: currentState.categories,
          selectedCategoryId: categoryId,
        ),
      );
    }
  }

  List<Product> getProductsByCategory(int categoryId) {
    if (state is CategoriesSuccess) {
      final currentState = state as CategoriesSuccess;

      final matchingCategories = currentState.categories
          .where((cat) => cat.id == categoryId)
          .toList();

      if (matchingCategories.isNotEmpty) {
        return matchingCategories.first.products;
      }

      if (currentState.categories.isNotEmpty) {
        return currentState.categories.first.products;
      }
    }
    return [];
  }

  Category? getSelectedCategory() {
    if (state is CategoriesSuccess) {
      final currentState = state as CategoriesSuccess;
      final matchingCategories = currentState.categories
          .where((cat) => cat.id == currentState.selectedCategoryId)
          .toList();

      if (matchingCategories.isNotEmpty) {
        return matchingCategories.first;
      }

      if (currentState.categories.isNotEmpty) {
        return currentState.categories.first;
      }
    }
    return null;
  }
}
