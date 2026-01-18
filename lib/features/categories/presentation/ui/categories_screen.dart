import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:restaurant_app/core/di/dependency_injection.dart';
import 'package:restaurant_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:restaurant_app/features/categories/presentation/cubit/categories_states.dart';
import 'package:restaurant_app/features/categories/presentation/ui/widgets/category_tab.dart';
import 'package:restaurant_app/features/categories/presentation/ui/widgets/product_item.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/error_widget.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoriesCubit>()..loadCategories(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const LoadingWidget();
              }

              if (state is CategoriesError) {
                return CustomErrorWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<CategoriesCubit>().loadCategories();
                  },
                );
              }

              if (state is CategoriesSuccess) {
                if (state.categories.isEmpty) {
                  return _buildEmptyState();
                }

                final cubit = context.read<CategoriesCubit>();
                final products = cubit.getProductsByCategory(
                  state.selectedCategoryId,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Tabs
                    _buildCategoryTabs(context, state),

                    // Category Title
                    _buildCategoryTitle(context, cubit),

                    // Products List
                    Expanded(
                      child: products.isEmpty
                          ? _buildEmptyState()
                          : _buildProductsList(products),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),

        bottomNavigationBar: _buildBottomNavigationBar(context),

        floatingActionButton: _buildFloatingCartButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, CategoriesSuccess state) {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(top: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          final isSelected = category.id == state.selectedCategoryId;

          return CategoryTab(
            category: category,
            isSelected: isSelected,
            onTap: () {
              context.read<CategoriesCubit>().selectCategory(category.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryTitle(BuildContext context, CategoriesCubit cubit) {
    final isArabic = context.locale.languageCode == 'ar';
    final selectedCategory = cubit.getSelectedCategory();

    if (selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final categoryName = isArabic
        ? selectedCategory.nameAr
        : selectedCategory.name;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Text(
        categoryName,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildProductsList(List products) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/product-details',
              arguments: products[index].id,
            );
          },
          child: ProductItem(product: products[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_products'.tr(),
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.w),
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            label: isArabic ? 'الرئيسية' : 'Home',
            isSelected: false,
          ),
          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            label: isArabic ? 'القائمة' : 'Menu',
            isSelected: true,
          ),
          SizedBox(width: 60.w),
          _buildNavItem(
            icon: Icons.local_offer_outlined,
            label: isArabic ? 'العروض' : 'Offers',
            isSelected: false,
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            label: isArabic ? 'الحساب' : 'Account',
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF4A2C2A) : AppColors.textSecondary,
          size: 24.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isSelected
                ? const Color(0xFF4A2C2A)
                : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/cart');
      },
      child: Container(
        width: 65.w,
        height: 65.h,
        decoration: BoxDecoration(
          color: const Color(0xFF4A2C2A),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            Positioned(
              right: 8.w,
              top: 8.h,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
                child: Center(
                  child: Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
