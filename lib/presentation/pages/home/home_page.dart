import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/market_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/token_card.dart';
import '../../widgets/portfolio_summary_card.dart';
import '../../widgets/trending_section.dart';
import '../../widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadWallets();
      context.read<MarketProvider>().loadMarketData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.cardBackground,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                titleSpacing: 0,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      // Logo
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.auto_graph_rounded,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                      
                      SizedBox(width: 12.w),
                      
                      // Title
                      Text(
                        'GMGN.AI',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Notification icon
                      IconButton(
                        onPressed: _showNotifications,
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textSecondary,
                          size: 24.sp,
                        ),
                      ),
                      
                      // Profile icon
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return GestureDetector(
                            onTap: _showProfileMenu,
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 16.h),
                    
                    // Search bar
                    const CustomSearchBar(),
                    
                    SizedBox(height: 20.h),
                    
                    // Portfolio summary
                    const PortfolioSummaryCard(),
                    
                    SizedBox(height: 24.h),
                    
                    // Quick actions
                    _buildQuickActions(),
                    
                    SizedBox(height: 24.h),
                    
                    // Trending section
                    const TrendingSection(),
                    
                    SizedBox(height: 24.h),
                    
                    // Market overview
                    _buildMarketOverview(),
                    
                    SizedBox(height: 24.h),
                    
                    // New tokens
                    _buildNewTokens(),
                    
                    SizedBox(height: 24.h),
                    
                    // Gainers & Losers
                    _buildGainersLosers(),
                    
                    SizedBox(height: 100.h), // Bottom padding for navigation
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              color: AppColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              '快速操作',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.trending_up,
                title: 'MEME 狙击',
                subtitle: '发现新币机会',
                color: AppColors.success,
                onTap: () {},
              ),
            ),
            
            SizedBox(width: 12.w),
            
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.copy,
                title: '跟单交易',
                subtitle: '复制高手策略',
                color: AppColors.accent,
                onTap: () {},
              ),
            ),
            
            SizedBox(width: 12.w),
            
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.security,
                title: '安全检测',
                subtitle: '代币风险分析',
                color: AppColors.warning,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            
            SizedBox(height: 12.h),
            
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 4.h),
            
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketOverview() {
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, _) {
        if (marketProvider.isLoading) {
          return _buildLoadingCard('市场总览');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '市场总览',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    '查看更多',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: marketProvider.tokens.take(5).length,
                itemBuilder: (context, index) {
                  final token = marketProvider.tokens[index];
                  return Container(
                    width: 280.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: TokenCard(token: token),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewTokens() {
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, _) {
        if (marketProvider.isLoading) {
          return _buildLoadingCard('新币发现');
        }

        final newTokens = marketProvider.newTokens;
        if (newTokens.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.new_releases,
                  color: AppColors.warning,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  '新币发现',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'HOT',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            Column(
              children: newTokens.take(3).map((token) => 
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: TokenCard(token: token),
                )
              ).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGainersLosers() {
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, _) {
        if (marketProvider.isLoading) {
          return _buildLoadingCard('涨跌排行');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.leaderboard,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  '涨跌排行',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            Row(
              children: [
                Expanded(
                  child: _buildRankingSection(
                    title: '涨幅榜',
                    tokens: marketProvider.gainers.take(3).toList(),
                    isGainers: true,
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                Expanded(
                  child: _buildRankingSection(
                    title: '跌幅榜',
                    tokens: marketProvider.losers.take(3).toList(),
                    isGainers: false,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildRankingSection({
    required String title,
    required List tokens,
    required bool isGainers,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isGainers ? Icons.trending_up : Icons.trending_down,
                color: isGainers ? AppColors.success : AppColors.error,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          Column(
            children: tokens.map((token) => 
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        token.symbol,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      token.formattedChange,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: token.isPositiveChange ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(String title) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '加载$title中...',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<WalletProvider>().refreshWallets(),
      context.read<MarketProvider>().refreshMarketData(),
    ]);
  }

  void _showNotifications() {
    // TODO: Implement notifications
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('暂无新通知'),
        backgroundColor: AppColors.cardBackground,
      ),
    );
  }

  void _showProfileMenu() {
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
          children: [
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final user = authProvider.currentUser;
                return Column(
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
                        size: 30.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      user?.displayName ?? '用户',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
            
            SizedBox(height: 24.h),
            
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.textSecondary),
              title: Text('设置', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            
            ListTile(
              leading: Icon(Icons.help_outline, color: AppColors.textSecondary),
              title: Text('帮助', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text('退出登录', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}