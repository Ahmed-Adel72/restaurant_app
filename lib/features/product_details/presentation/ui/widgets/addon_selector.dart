import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:restaurant_app/features/product_details/domain/entities/addon.dart';
import 'package:restaurant_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../../../../core/theme/app_colors.dart';

class AddonSelector extends StatelessWidget {
  final Addon addon;

  const AddonSelector({super.key, required this.addon});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final addonName = isArabic ? addon.nameAr : addon.name;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Addon Title
          Row(
            children: [
              if (addon.isRequired)
                Text(
                  addonName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
              SizedBox(width: 4.w),
              Icon(Icons.star, color: AppColors.primary, size: 14.sp),
            ],
          ),

          SizedBox(height: 12.h),

          // Addon Options
          if (addon.options.isNotEmpty)
            ...addon.options.map((option) {
              return _buildAddonOption(context, option, isArabic);
            }).toList()
          else
            Center(
              child: Text(
                'No_options_available'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddonOption(
    BuildContext context,
    AddonOption option,
    bool isArabic,
  ) {
    final optionName = isArabic ? option.labelAr : option.label;

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is! ProductDetailsLoaded) {
          return const SizedBox.shrink();
        }

        final selectedOption = state.selectedAddons[addon.id];
        final isSelected = selectedOption?.label == option.label;

        return GestureDetector(
          onTap: () {
            context.read<ProductDetailsCubit>().selectAddonOption(
              addon.id,
              option,
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),

            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Text(
                    optionName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),

                if (option.price > 0) ...[
                  SizedBox(width: 8.w),
                  Text(
                    '+${option.price.toStringAsFixed(0)} ${'egp'.tr()}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
