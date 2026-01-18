import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart.dart';
import '../../../../../core/theme/app_colors.dart';

class CartSummary extends StatelessWidget {
  final Cart cart;

  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'payment_details'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),

          CustomPaint(
            size: Size(double.infinity, 1),
            painter: DashedLinePainter(),
          ),

          SizedBox(height: 10.h),

          // Total Price
          _buildRow(
            'total_price'.tr(),
            'egp'.tr(),
            cart.totalPrice.toStringAsFixed(2),
          ),

          SizedBox(height: 16.h),

          // VAT
          _buildRow('tax'.tr(), 'egp'.tr(), cart.vat.toStringAsFixed(2)),

          SizedBox(height: 16.h),

          // Dashed Divider
          CustomPaint(
            size: Size(double.infinity, 1),
            painter: DashedLinePainter(),
          ),

          SizedBox(height: 16.h),

          // Grand Total
          _buildRow(
            'grand_total'.tr(),
            'egp'.tr(),
            cart.totalPriceWithTax.toStringAsFixed(2),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    String value2, {
    bool isBold = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),

        Text(
          value2,
          style: TextStyle(
            fontSize: isBold ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
