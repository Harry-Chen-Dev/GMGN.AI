import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? double.infinity;
    final buttonHeight = height ?? 48.h;
    final buttonColor = backgroundColor ?? 
        (isOutlined ? Colors.transparent : AppColors.primary);
    final buttonTextColor = textColor ?? 
        (isOutlined ? AppColors.primary : Colors.white);
    final buttonFontSize = fontSize ?? 16.sp;
    final buttonFontWeight = fontWeight ?? FontWeight.w600;
    final buttonBorderRadius = borderRadius ?? BorderRadius.circular(12.r);
    
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                side: BorderSide(
                  color: onPressed == null ? AppColors.borderColor : AppColors.primary,
                  width: 1.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: buttonBorderRadius,
                ),
                padding: padding ?? EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              icon: _buildIcon(buttonTextColor),
              label: _buildText(buttonTextColor, buttonFontSize, buttonFontWeight),
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                disabledBackgroundColor: AppColors.buttonDisabled,
                disabledForegroundColor: AppColors.textDisabled,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: buttonBorderRadius,
                ),
                padding: padding ?? EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              icon: _buildIcon(buttonTextColor),
              label: _buildText(buttonTextColor, buttonFontSize, buttonFontWeight),
            ),
    );
  }

  Widget _buildIcon(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 16.w,
        height: 16.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    
    if (icon != null) {
      return Icon(
        icon,
        size: 20.sp,
        color: color,
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildText(Color color, double fontSize, FontWeight fontWeight) {
    return Text(
      isLoading ? '加载中...' : text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}