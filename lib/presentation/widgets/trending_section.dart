import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../providers/market_provider.dart';
import 'token_card.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, _) {
        if (marketProvider.isLoading) {
          return _buildLoadingSection();
        }

        final trendingTokens = marketProvider.trendingTokens;
        if (trendingTokens.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.whatshot,
                      color: AppColors.warning,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '热门趋势',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full market page
                  },
                  child: Text(
                    '查看全部',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Filter tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    '热门',
                    isSelected: marketProvider.currentFilter == MarketFilter.trending,
                    onTap: () => marketProvider.setFilter(MarketFilter.trending),
                  ),
                  SizedBox(width: 8.w),
                  _buildFilterChip(
                    '涨幅榜',
                    isSelected: marketProvider.currentFilter == MarketFilter.gainers,
                    onTap: () => marketProvider.setFilter(MarketFilter.gainers),
                  ),
                  SizedBox(width: 8.w),
                  _buildFilterChip(
                    '新币',
                    isSelected: marketProvider.currentFilter == MarketFilter.new_,
                    onTap: () => marketProvider.setFilter(MarketFilter.new_),
                  ),
                  SizedBox(width: 8.w),
                  _buildFilterChip(
                    '全部',
                    isSelected: marketProvider.currentFilter == MarketFilter.all,
                    onTap: () => marketProvider.setFilter(MarketFilter.all),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Trending tokens list
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingTokens.take(10).length,
                itemBuilder: (context, index) {
                  final token = trendingTokens[index];
                  return Container(
                    width: 300.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: TokenCard(
                      token: token,
                      onTap: () {
                        // TODO: Navigate to token detail page
                        _showTokenDetail(context, token);
                      },
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Market summary
            _buildMarketSummary(marketProvider),
          ],
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 80.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Filter chips skeleton
        Row(
          children: List.generate(4, (index) => 
            Container(
              margin: EdgeInsets.only(right: 8.w),
              width: 60.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Tokens list skeleton
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: 300.w,
              height: 140.h,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMarketSummary(MarketProvider marketProvider) {
    final totalTokens = marketProvider.tokens.length;
    final gainers = marketProvider.gainers.length;
    final losers = marketProvider.losers.length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            label: '代币总数',
            value: totalTokens.toString(),
            icon: Icons.token,
            color: AppColors.primary,
          ),
          
          Container(
            width: 1.w,
            height: 32.h,
            color: AppColors.borderColor,
          ),
          
          _buildSummaryItem(
            label: '上涨',
            value: gainers.toString(),
            icon: Icons.trending_up,
            color: AppColors.success,
          ),
          
          Container(
            width: 1.w,
            height: 32.h,
            color: AppColors.borderColor,
          ),
          
          _buildSummaryItem(
            label: '下跌',
            value: losers.toString(),
            icon: Icons.trending_down,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 4.h),
        
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showTokenDetail(BuildContext context, token) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              
              SizedBox(height: 20.h),
              
              // Token header
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Center(
                      child: Text(
                        token.symbol[0],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 16.w),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          token.symbol,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          token.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24.h),
              
              // Price info
              Text(
                token.formattedPrice,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              Row(
                children: [
                  Icon(
                    token.isPositiveChange ? Icons.trending_up : Icons.trending_down,
                    color: token.isPositiveChange ? AppColors.success : AppColors.error,
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    token.formattedChange,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: token.isPositiveChange ? AppColors.success : AppColors.error,
                    ),
                  ),
                  Text(
                    ' (24h)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24.h),
              
              // Stats
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _buildStatRow('市值', token.formattedMarketCap),
                    SizedBox(height: 12.h),
                    _buildStatRow('24h成交量', token.formattedVolume),
                    if (token.security != null) ...[
                      SizedBox(height: 12.h),
                      _buildStatRow('持有人数', '${token.security!.holderCount}'),
                    ],
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Navigate to buy page
                      },
                      child: Text('买入'),
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Add to watchlist
                      },
                      child: Text('关注'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}