import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/market_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/token_card.dart';
import '../../widgets/search_bar.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> 
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketProvider>().loadMarketData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const CustomSearchBar(),
            ),
            
            SizedBox(height: 16.h),
            
            // Filter tabs
            _buildFilterTabs(),
            
            SizedBox(height: 16.h),
            
            // Content
            Expanded(
              child: Consumer<MarketProvider>(
                builder: (context, marketProvider, _) {
                  if (marketProvider.isLoading) {
                    return _buildLoadingView();
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.cardBackground,
                    onRefresh: () => marketProvider.refreshMarketData(),
                    child: _buildTokensList(marketProvider),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Text(
            '市场行情',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          
          const Spacer(),
          
          // Sort button
          GestureDetector(
            onTap: _showSortOptions,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '排序',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Refresh button
          GestureDetector(
            onTap: () => context.read<MarketProvider>().refreshMarketData(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.refresh,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 48.h,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        onTap: (index) {
          final filters = [
            MarketFilter.all,
            MarketFilter.trending,
            MarketFilter.new_,
            MarketFilter.gainers,
            MarketFilter.losers,
          ];
          context.read<MarketProvider>().setFilter(filters[index]);
        },
        tabs: [
          Tab(text: '全部'),
          Tab(text: '热门'),
          Tab(text: '新币'),
          Tab(text: '涨幅榜'),
          Tab(text: '跌幅榜'),
        ],
      ),
    );
  }

  Widget _buildTokensList(MarketProvider marketProvider) {
    final tokens = marketProvider.filteredTokens;
    
    if (tokens.isEmpty) {
      return _buildEmptyView();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: TokenCard(
            token: token,
            showChart: true,
            onTap: () => _showTokenDetail(token),
          ),
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        height: 120.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: AppColors.textTertiary,
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            '暂无数据',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            '请尝试其他筛选条件',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          ElevatedButton(
            onPressed: () {
              context.read<MarketProvider>().setFilter(MarketFilter.all);
              _tabController.animateTo(0);
            },
            child: Text('查看全部'),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '排序方式',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: 24.h),
            
            _buildSortOption('市值', '按市值从高到低', Icons.pie_chart),
            _buildSortOption('价格', '按价格从高到低', Icons.attach_money),
            _buildSortOption('涨跌幅', '按24h涨跌幅排序', Icons.trending_up),
            _buildSortOption('成交量', '按24h成交量排序', Icons.bar_chart),
            _buildSortOption('名称', '按代币名称排序', Icons.sort_by_alpha),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String subtitle, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: () {
        Navigator.pop(context);
        // TODO: Implement sorting
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('排序功能即将推出'),
            backgroundColor: AppColors.cardBackground,
          ),
        );
      },
    );
  }

  void _showTokenDetail(token) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            controller: scrollController,
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
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      child: Center(
                        child: Text(
                          token.symbol[0],
                          style: TextStyle(
                            fontSize: 24.sp,
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
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            token.name,
                            style: TextStyle(
                              fontSize: 16.sp,
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
                
                SizedBox(height: 32.h),
                
                // Price section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前价格',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      Text(
                        token.formattedPrice,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: (token.isPositiveChange ? AppColors.success : AppColors.error)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  token.isPositiveChange ? Icons.trending_up : Icons.trending_down,
                                  color: token.isPositiveChange ? AppColors.success : AppColors.error,
                                  size: 18.sp,
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
                              ],
                            ),
                          ),
                          
                          SizedBox(width: 12.w),
                          
                          Text(
                            '24小时',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Stats section
                _buildStatsSection(token),
                
                SizedBox(height: 24.h),
                
                // Security section
                if (token.security != null)
                  _buildSecuritySection(token.security!),
                
                SizedBox(height: 24.h),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Navigate to trade page
                        },
                        icon: Icon(Icons.swap_horiz),
                        label: Text('交易'),
                      ),
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Add to watchlist
                        },
                        icon: Icon(Icons.star_border),
                        label: Text('关注'),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12.w),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Share token
                    },
                    icon: Icon(Icons.share),
                    label: Text('分享'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(token) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '代币信息',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          _buildStatRow('市值', token.formattedMarketCap),
          _buildStatRow('24h成交量', token.formattedVolume),
          _buildStatRow('合约地址', '${token.contractAddress.substring(0, 8)}...${token.contractAddress.substring(token.contractAddress.length - 8)}'),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(security) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '安全信息',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          _buildStatRow('蜜罐检测', security.isHoneypot ? '是' : '否'),
          _buildStatRow('流动性', '${security.liquidityPercentage.toStringAsFixed(1)}%'),
          _buildStatRow('持有人数', security.holderCount.toString()),
          
          if (security.riskFactors.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              '风险提示:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
            SizedBox(height: 8.h),
            ...security.riskFactors.map((risk) => 
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: AppColors.warning,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      risk,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
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
      ),
    );
  }
}