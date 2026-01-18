import 'package:dio/dio.dart';
import 'package:restaurant_app/core/network/api_constants.dart';
import 'package:restaurant_app/features/categories/data/models/category_model.dart';

class CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSource(this.dio);

  Future<List<CategoryModel>> getCategories() async {
    final res = await dio.get(ApiConstants.categoriesEndpoint);
    return (res.data as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
