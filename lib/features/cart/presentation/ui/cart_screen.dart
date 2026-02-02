import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/di/dependency_injection.dart';
import 'package:restaurant_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:restaurant_app/features/cart/presentation/cubit/cart_states.dart';
import 'package:restaurant_app/features/cart/presentation/ui/widgets/cart_item_widget.dart';
import 'package:restaurant_app/features/cart/presentation/ui/widgets/cart_summary.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/error_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartCubit>()..loadCart(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),

              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    if (state is CartLoading) {
                      return const LoadingWidget();
                    }

                    if (state is CartError) {
                      return CustomErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context.read<CartCubit>().loadCart();
                        },
                      );
                    }

                    if (state is CartEmpty) {
                      return _buildEmptyCart();
                    }

                    if (state is CartLoaded) {
                      return _buildCartContent(context, state);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 18.sp,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'back'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 35.w),

          Align(
            alignment: Alignment.center,
            child: Text(
              'cart'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 70.w),
          GestureDetector(
            onTap: () async {
              final currentLocale = context.locale;
              final newLocale = currentLocale.languageCode == 'ar'
                  ? const Locale('en')
                  : const Locale('ar');
              await context.setLocale(newLocale);
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  context.locale.languageCode == 'ar' ? 'EN' : 'ع',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 24.h),
          Text(
            'empty_cart'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'add_items_to_cart'.tr(),
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Cart Items List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  itemCount: state.cart.items.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 5,
                    thickness: 1.5,
                    color: Color(0xFFE0E0E0),
                  ),
                  itemBuilder: (context, index) {
                    return CartItemWidget(
                      item: state.cart.items[index],
                      onIncrement: () {
                        context.read<CartCubit>().incrementQuantity(
                          state.cart.items[index].productId,
                        );
                      },
                      onDecrement: () {
                        context.read<CartCubit>().decrementQuantity(
                          state.cart.items[index].productId,
                        );
                      },
                      onDelete: () {
                        context.read<CartCubit>().removeItem(
                          state.cart.items[index].productId,
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 16.h),

                _buildCouponSection(context),

                SizedBox(height: 16.h),

                CartSummary(cart: state.cart),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),

        _buildCheckoutButton(context, state),
      ],
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'apply_coupon'.tr(),
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'apply'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartLoaded state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'checkout'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
