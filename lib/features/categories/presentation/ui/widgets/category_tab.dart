import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/features/categories/domain/entities/category.dart';
import '../../../../../../core/theme/app_colors.dart';

class CategoryTab extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final name = isArabic ? category.nameAr : category.name;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 8.w, right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.image != null && category.image!.isNotEmpty) ...[
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: category.image!,
                  width: 28.w,
                  height: 28.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 28.w,
                    height: 28.h,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  errorWidget: (_, __, ___) => Icon(
                    Icons.fastfood,
                    size: 28.sp,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
