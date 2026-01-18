import 'package:restaurant_app/features/categories/domain/entities/category.dart';

abstract class CategoriesRepository {
  Future<List<Category>> getCategories();
}
