import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/copy_trade_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/search_bar.dart';

class CopyTradePage extends StatefulWidget {
  const CopyTradePage({super.key});

  @override
  State<CopyTradePage> createState() => _CopyTradePageState();
}

class _CopyTradePageState extends State<CopyTradePage> 
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CopyTradeProvider>().loadTraders();
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
              child: const CustomSearchBar(
                hintText: '搜索交易员或钱包地址',
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Filter tabs
            _buildFilterTabs(),
            
            SizedBox(height: 16.h),
            
            // Content
            Expanded(
              child: Consumer<CopyTradeProvider>(
                builder: (context, copyTradeProvider, _) {
                  if (copyTradeProvider.isLoading) {
                    return _buildLoadingView();
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.cardBackground,
                    onRefresh: () => copyTradeProvider.refreshTraders(),
                    child: _buildTradersList(copyTradeProvider),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '跟单交易',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '复制专业交易员的策略',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Filter button
          GestureDetector(
            onTap: _showFilterOptions,
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
                    Icons.filter_list,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '筛选',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
            CopyTradeFilter.all,
            CopyTradeFilter.following,
            CopyTradeFilter.topPerformers,
            CopyTradeFilter.highWinRate,
          ];
          context.read<CopyTradeProvider>().setFilter(filters[index]);
        },
        tabs: [
          Tab(text: '全部'),
          Tab(text: '已跟单'),
          Tab(text: '收益榜'),
          Tab(text: '胜率榜'),
        ],
      ),
    );
  }

  Widget _buildTradersList(CopyTradeProvider copyTradeProvider) {
    final traders = copyTradeProvider.filteredTraders;
    
    if (traders.isEmpty) {
      return _buildEmptyView();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: traders.length,
      itemBuilder: (context, index) {
        final trader = traders[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          child: _buildTraderCard(trader, copyTradeProvider),
        );
      },
    );
  }

  Widget _buildTraderCard(trader, CopyTradeProvider copyTradeProvider) {
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
          // Header
          Row(
            children: [
              // Avatar
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Trader info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          trader.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (trader.totalTrades > 100)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      trader.shortAddress,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textTertiary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              
              // Follow button
              GestureDetector(
                onTap: () => _toggleFollow(trader, copyTradeProvider),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: trader.isFollowing 
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                    border: trader.isFollowing 
                        ? Border.all(color: AppColors.success)
                        : null,
                  ),
                  child: Text(
                    trader.isFollowing ? '已跟单' : '跟单',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: trader.isFollowing ? AppColors.success : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Specialties
          if (trader.specialties.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: trader.specialties.map((specialty) => 
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    specialty,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ).toList(),
            ),
          
          SizedBox(height: 16.h),
          
          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: '总资产',
                  value: trader.formattedTotalValue,
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              
              Expanded(
                child: _buildStatItem(
                  label: '7日收益',
                  value: trader.formattedRoi7d,
                  icon: Icons.trending_up,
                  valueColor: trader.roi7d >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
              
              Expanded(
                child: _buildStatItem(
                  label: '30日收益',
                  value: trader.formattedRoi30d,
                  icon: Icons.show_chart,
                  valueColor: trader.roi30d >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
              
              Expanded(
                child: _buildStatItem(
                  label: '胜率',
                  value: trader.formattedWinRate,
                  icon: Icons.percent,
                  valueColor: trader.winRate >= 70 ? AppColors.success : 
                             trader.winRate >= 50 ? AppColors.warning : AppColors.error,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Bottom info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    color: AppColors.textTertiary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${trader.followers}位跟单者',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              
              Row(
                children: [
                  Icon(
                    Icons.swap_horiz,
                    color: AppColors.textTertiary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${trader.totalTrades}笔交易',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              
              GestureDetector(
                onTap: () => _showTraderDetail(trader),
                child: Text(
                  '查看详情',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 16.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
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
            Icons.person_search,
            size: 64.sp,
            color: AppColors.textTertiary,
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            '暂无交易员',
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
              context.read<CopyTradeProvider>().setFilter(CopyTradeFilter.all);
              _tabController.animateTo(0);
            },
            child: Text('查看全部'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
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
              '筛选条件',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: 24.h),
            
            _buildFilterOption('收益率', '按30日收益率排序', Icons.trending_up),
            _buildFilterOption('胜率', '按胜率从高到低', Icons.percent),
            _buildFilterOption('交易量', '按总交易数排序', Icons.swap_horiz),
            _buildFilterOption('跟单数', '按跟单人数排序', Icons.people),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, String subtitle, IconData icon) {
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
        // TODO: Implement filtering
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('筛选功能即将推出'),
            backgroundColor: AppColors.cardBackground,
          ),
        );
      },
    );
  }

  void _toggleFollow(trader, CopyTradeProvider copyTradeProvider) async {
    if (trader.isFollowing) {
      final success = await copyTradeProvider.unfollowTrader(trader.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已取消跟单 ${trader.name}'),
            backgroundColor: AppColors.cardBackground,
          ),
        );
      }
    } else {
      _showCopyTradeDialog(trader, copyTradeProvider);
    }
  }

  void _showCopyTradeDialog(trader, CopyTradeProvider copyTradeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '跟单设置',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '您确定要跟单 ${trader.name} 吗？',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _buildInfoRow('交易员', trader.name),
                  _buildInfoRow('30日收益', trader.formattedRoi30d),
                  _buildInfoRow('胜率', trader.formattedWinRate),
                  _buildInfoRow('跟单费用', '免费'),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Text(
              '⚠️ 跟单有风险，投资需谨慎',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await copyTradeProvider.followTrader(trader.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('成功跟单 ${trader.name}'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: Text('确认跟单'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
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

  void _showTraderDetail(trader) {
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
                
                // Trader header
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                    
                    SizedBox(width: 16.w),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trader.name,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            trader.shortAddress,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                              fontFamily: 'monospace',
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
                
                // Performance overview
                Container(
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
                        '交易表现',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  trader.formattedTotalValue,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '总资产',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  trader.formattedRoi30d,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: trader.roi30d >= 0 ? AppColors.success : AppColors.error,
                                  ),
                                ),
                                Text(
                                  '30日收益',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  trader.formattedWinRate,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '胜率',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Trading info
                _buildTradingInfo(trader),
                
                SizedBox(height: 24.h),
                
                // Follow button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _toggleFollow(trader, context.read<CopyTradeProvider>());
                    },
                    child: Text(trader.isFollowing ? '取消跟单' : '开始跟单'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTradingInfo(trader) {
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
            '交易信息',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          _buildInfoRow('总交易次数', '${trader.totalTrades}'),
          _buildInfoRow('跟单人数', '${trader.followers}'),
          _buildInfoRow('7日收益', trader.formattedRoi7d),
          _buildInfoRow('擅长领域', trader.specialties.join(', ')),
        ],
      ),
    );
  }
}