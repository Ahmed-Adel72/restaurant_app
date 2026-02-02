import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_app/features/cart/data/data_source/cart_local_datasource.dart';
import 'package:restaurant_app/features/categories/data/data_source/category_remote_datasource.dart';
import 'package:restaurant_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/delete_from_cart_usecase.dart';
import 'package:restaurant_app/features/product_details/domain/usecases/get_addons.dart';
import 'package:restaurant_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/get_guest_id_usecase.dart';
import 'package:restaurant_app/features/product_details/domain/usecases/get_product_details.dart';
import 'package:restaurant_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:restaurant_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:restaurant_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_factory.dart';
import '../../features/cart/data/data_source/cart_remote_datasource.dart';
import '../../features/product_details/data/data_source/product_details_remote_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/product_details/data/repositories/product_details_repository_impl.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/product_details/domain/repositories/product_details_repository.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<Dio>(() => DioFactory.getDio());

  ///////////////// Cart Feature///////////////////
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => DeleteFromCartUseCase(sl()));
  sl.registerFactory(
    () => CartCubit(
      getGuestIdUseCase: sl(),
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      deleteFromCartUseCase: sl(),
    ),
  );
  ////////////// Product Details Feature////////////////

  sl.registerLazySingleton(() => ProductDetailsRemoteDataSource(sl()));
  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductAddonsUseCase(sl()));
  sl.registerFactory(() => ProductDetailsCubit(sl(), sl()));

  ////////////// Categories Feature////////////////
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CategoryRemoteDataSource(sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => GetGuestIdUseCase(sl()));
  sl.registerFactory(() => CategoriesCubit(sl()));
}
