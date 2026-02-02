import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../../../../core/theme/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is! ProductDetailsLoaded) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            // Plus Button
            GestureDetector(
              onTap: () {
                context.read<ProductDetailsCubit>().incrementQuantity();
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 18.sp),
              ),
            ),

            SizedBox(width: 12.w),

            // Quantity
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: Center(
                child: Text(
                  state.quantity.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Minus Button
            GestureDetector(
              onTap: state.quantity > 1
                  ? () {
                      context.read<ProductDetailsCubit>().decrementQuantity();
                    }
                  : null,
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: state.quantity > 1
                      ? AppColors.divider
                      : AppColors.divider.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove,
                  color: state.quantity > 1
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
