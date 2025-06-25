import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/crypto_token.dart';

class TokenCard extends StatelessWidget {
  final CryptoToken token;
  final VoidCallback? onTap;
  final bool showChart;
  final bool compact;

  const TokenCard({
    super.key,
    required this.token,
    this.onTap,
    this.showChart = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? 12.w : 16.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: compact ? _buildCompactLayout() : _buildFullLayout(),
      ),
    );
  }

  Widget _buildFullLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            // Token icon
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  token.symbol[0],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Token info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    token.symbol,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    token.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Security badge
            if (token.security != null)
              _buildSecurityBadge(token.security!),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Price and change
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.formattedPrice,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      token.isPositiveChange ? Icons.trending_up : Icons.trending_down,
                      color: token.isPositiveChange ? AppColors.success : AppColors.error,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      token.formattedChange,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: token.isPositiveChange ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // Mini chart or volume
            if (showChart)
              _buildMiniChart()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '24h 成交量',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    token.formattedVolume,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      children: [
        // Token icon
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              token.symbol[0],
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        
        SizedBox(width: 8.w),
        
        // Token info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                token.symbol,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                token.formattedPrice,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // Change
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: (token.isPositiveChange ? AppColors.success : AppColors.error)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            token.formattedChange,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: token.isPositiveChange ? AppColors.success : AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityBadge(TokenSecurity security) {
    Color badgeColor;
    String badgeText;
    
    switch (security.securityLevel) {
      case SecurityLevel.low:
        badgeColor = AppColors.success;
        badgeText = '安全';
        break;
      case SecurityLevel.medium:
        badgeColor = AppColors.warning;
        badgeText = '注意';
        break;
      case SecurityLevel.high:
        badgeColor = AppColors.error;
        badgeText = '风险';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildMiniChart() {
    if (token.priceHistory.isEmpty) {
      return Container(
        width: 60.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Center(
          child: Text(
            'N/A',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 60.w,
      height: 30.h,
      child: CustomPaint(
        painter: MiniChartPainter(
          points: token.priceHistory,
          color: token.isPositiveChange ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}

class MiniChartPainter extends CustomPainter {
  final List<PricePoint> points;
  final Color color;

  MiniChartPainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    final minPrice = points.map((p) => p.price).reduce((a, b) => a < b ? a : b);
    final maxPrice = points.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;
    
    if (priceRange == 0) return;

    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = size.height - ((points[i].price - minPrice) / priceRange) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}