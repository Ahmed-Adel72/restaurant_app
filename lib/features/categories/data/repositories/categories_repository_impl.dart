import 'package:restaurant_app/features/categories/data/data_source/category_remote_datasource.dart';
import 'package:restaurant_app/features/categories/domain/entities/category.dart';
import 'package:restaurant_app/features/categories/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoryRemoteDataSource remote;

  CategoriesRepositoryImpl(this.remote);

  @override
  Future<List<Category>> getCategories() {
    return remote.getCategories();
  }
}
