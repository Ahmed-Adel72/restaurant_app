import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/core/di/dependency_injection.dart';
import 'package:restaurant_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:restaurant_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:restaurant_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:restaurant_app/features/product_details/presentation/ui/widgets/addon_selector.dart';
import 'package:restaurant_app/features/product_details/presentation/ui/widgets/quantity_selector.dart'
    show QuantitySelector;
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/error_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CategoriesCubit>()),
        BlocProvider(
          create: (_) =>
              sl<ProductDetailsCubit>()..loadProductDetails(productId),
        ),
        BlocProvider(create: (context) => sl<CartCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsLoading) {
                return const LoadingWidget();
              }

              if (state is ProductDetailsError) {
                return CustomErrorWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<ProductDetailsCubit>().loadProductDetails(
                      productId,
                    );
                  },
                );
              }

              if (state is ProductDetailsLoaded) {
                final isArabic = context.locale.languageCode == 'ar';
                final product = state.product;
                final name = isArabic ? product.nameAr : product.name;
                final description = isArabic
                    ? product.descriptionAr
                    : product.description;

                return Column(
                  children: [
                    _buildHeader(context, name),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildProductImage(product.image),

                            SizedBox(height: 16.h),

                            _buildProductInfo(
                              context,
                              name,
                              product.priceWithTax,
                            ),

                            SizedBox(height: 16.h),

                            if (description.isNotEmpty)
                              _buildDescription(description),

                            SizedBox(height: 16.h),

                            if (state.addons.isNotEmpty)
                              _buildAddons(context, state),

                            SizedBox(height: 100.h),
                          ],
                        ),
                      ),
                    ),

                    _buildBottomButton(context, state),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String productName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(color: AppColors.background),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 18.sp,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'back'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 5.w),

          Expanded(
            child: Text(
              'product_details'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(width: 22.w),
          Stack(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 250.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                errorWidget: (_, __, ___) => Icon(
                  Icons.fastfood,
                  size: 80.sp,
                  color: AppColors.textSecondary,
                ),
              )
            : Icon(Icons.fastfood, size: 80.sp, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, String name, double price) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      price.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    Text(
                      'egp'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 16.w),
          // Quantity Selector
          const QuantitySelector(),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildAddons(BuildContext context, ProductDetailsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: state.addons.map((addon) {
        return AddonSelector(addon: addon);
      }).toList(),
    );
  }

  Widget _buildBottomButton(BuildContext context, ProductDetailsLoaded state) {
    final cubit = context.read<ProductDetailsCubit>();
    final canAdd = cubit.canAddToCart();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: canAdd
            ? () async {
                final addons = cubit.selectedAddons.entries.map((entry) {
                  final option = entry.value;
                  return {
                    'id': int.tryParse(entry.key) ?? 0,
                    'name': option?.label ?? '',
                    'price': option?.price.toString() ?? '0',
                  };
                }).toList();

                final cartCubit = context.read<CartCubit>();
                await cartCubit.addToCart(
                  productId: state.product.id,
                  quantity: cubit.quantity,
                  addons: addons,
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("added_to_cart".tr()),
                      backgroundColor: AppColors.success,
                    ),
                  );

                  Navigator.pop(context);
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canAdd ? AppColors.primary : AppColors.divider,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'add_to_cart'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: canAdd ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
