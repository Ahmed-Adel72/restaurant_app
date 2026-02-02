import 'package:restaurant_app/features/categories/domain/entities/category.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesSuccess extends CategoriesState {
  final List<Category> categories;
  final int selectedCategoryId;

  CategoriesSuccess({
    required this.categories,
    required this.selectedCategoryId,
  });
}

class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError(this.message);
}
