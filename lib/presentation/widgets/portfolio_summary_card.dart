import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../providers/wallet_provider.dart';

class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, _) {
        if (walletProvider.isLoading) {
          return _buildLoadingCard();
        }

        final totalValue = walletProvider.totalPortfolioValue;
        final change24h = walletProvider.totalPortfolioChange24h;
        final changePercentage = walletProvider.totalPortfolioChangePercentage24h;
        final isPositive = change24h >= 0;

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '总资产',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: () => walletProvider.refreshWallets(),
                    child: Icon(
                      Icons.refresh,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Total value
              Text(
                _formatCurrency(totalValue),
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // 24h change
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: (isPositive ? AppColors.success : AppColors.error)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: isPositive ? AppColors.success : AppColors.error,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${isPositive ? '+' : ''}${changePercentage.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isPositive ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  Text(
                    '${isPositive ? '+' : ''}${_formatCurrency(change24h)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  Text(
                    ' 24h',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20.h),
              
              // Quick stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      label: '钱包数量',
                      value: '${walletProvider.wallets.length}',
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ),
                  
                  Container(
                    width: 1.w,
                    height: 32.h,
                    color: AppColors.borderColor,
                  ),
                  
                  Expanded(
                    child: _buildStatItem(
                      label: '持仓币种',
                      value: _getTotalTokenCount(walletProvider),
                      icon: Icons.pie_chart_outline,
                    ),
                  ),
                  
                  Container(
                    width: 1.w,
                    height: 32.h,
                    color: AppColors.borderColor,
                  ),
                  
                  Expanded(
                    child: _buildStatItem(
                      label: '今日收益',
                      value: isPositive ? '盈利' : '亏损',
                      icon: isPositive ? Icons.trending_up : Icons.trending_down,
                      iconColor: isPositive ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '总资产',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Loading skeleton
          Container(
            height: 40.h,
            width: 200.w,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Container(
                height: 24.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 24.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          Row(
            children: List.generate(3, (index) => 
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    Color? iconColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: 20.sp,
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }

  String _getTotalTokenCount(WalletProvider walletProvider) {
    int totalTokens = 0;
    for (final wallet in walletProvider.wallets) {
      totalTokens += wallet.tokens.length;
    }
    return totalTokens.toString();
  }
}