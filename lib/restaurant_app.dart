import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/theme/app_theme.dart';
import 'package:restaurant_app/features/cart/presentation/ui/cart_screen.dart';
import 'package:restaurant_app/features/categories/presentation/ui/categories_screen.dart';
import 'package:restaurant_app/features/product_details/presentation/ui/product_details_screen.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (_) => const CategoriesScreen(),
                );
              case '/product-details':
                final productId = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => ProductDetailsScreen(productId: productId),
                );
              case '/cart':
                return MaterialPageRoute(builder: (_) => const CartScreen());
              default:
                return MaterialPageRoute(
                  builder: (_) => const CategoriesScreen(),
                );
            }
          },
          home: const CategoriesScreen(),
        );
      },
    );
  }
}
