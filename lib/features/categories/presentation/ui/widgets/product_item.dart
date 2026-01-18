import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/features/product_details/domain/entities/product.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final name = isArabic ? product.nameAr : product.name;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: product.image ?? '',
              width: 100.w,
              height: 80.h,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 100.w,
                height: 80.h,
                color: AppColors.divider,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 100.w,
                height: 80.h,
                color: AppColors.divider,
                child: Icon(
                  Icons.fastfood,
                  size: 40.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),

                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'egp'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      product.priceWithTax.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Add Button
          Container(
            width: 30.w,
            height: 30.h,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white, size: 16.sp),
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/product-details',
                  arguments: product.id,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
