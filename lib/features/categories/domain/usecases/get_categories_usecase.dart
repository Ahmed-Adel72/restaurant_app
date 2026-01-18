import 'package:restaurant_app/features/categories/domain/entities/category.dart';

import '../repositories/categories_repository.dart';

class GetCategoriesUsecase {
  final CategoriesRepository repo;

  GetCategoriesUsecase(this.repo);

  Future<List<Category>> call() {
    return repo.getCategories();
  }
}
