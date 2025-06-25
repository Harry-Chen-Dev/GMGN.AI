import 'package:flutter/material.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 顶部用户信息和操作按钮
            _buildHeader(),
            // SOL价格显示
            _buildSolPriceCard(),
            // 功能按钮
            _buildActionButtons(),
            // 标签栏
            _buildTabBar(),
            // 内容区域
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAnalysisTab(),
                  _buildProfitDistributionTab(),
                  _buildFishingDetectionTab(),
                  _buildOtherTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF9CFF2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.pets, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '6bis...sgkz',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.copy, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Icon(Icons.menu, size: 12, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '粉丝 0',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.school, color: Colors.black),
              const SizedBox(width: 4),
              const Text('教程', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              const Icon(Icons.refresh, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSolPriceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('SOL', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SOL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('总余额', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('≈ 0.0028205', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.currency_bitcoin, size: 14, color: Colors.grey),
                  Text(' SOL', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.arrow_downward, '充值'),
          _buildActionButton(Icons.arrow_upward, '提现'),
          _buildActionButtonWithHot(Icons.credit_card, '法币买币'),
          _buildActionButton(Icons.group_add, '邀请好友'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.black, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }

  Widget _buildActionButtonWithHot(IconData icon, String label) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildActionButton(icon, label),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('HOT', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: const Color(0xFF9CFF2A),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'PnL'),
          Tab(text: '分析'),
          Tab(text: '盈利分布'),
          Tab(text: '钓鱼检测'),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 总盈亏卡片
          _buildPnLCard(),
          const SizedBox(height: 16),
          // 持有代币标题
          _buildHoldingsHeader(),
          const SizedBox(height: 16),
          // 代币列表
          Expanded(child: _buildTokenList()),
        ],
      ),
    );
  }

  Widget _buildPnLCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('总盈亏', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('-0.145 SOL(-79.76%)', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          _buildPnLRow('未实现利润', '-- SOL'),
          const SizedBox(height: 8),
          _buildPnLRow('7d 平均持仓时长', '--'),
          const SizedBox(height: 8),
          _buildPnLRow('7d 买入总成本', '-- SOL'),
          const SizedBox(height: 8),
          _buildPnLRow('7d 代币平均买入成本', '-- SOL'),
          const SizedBox(height: 8),
          _buildPnLRow('7d 代币平均实现利润', '-- SOL'),
        ],
      ),
    );
  }

  Widget _buildPnLRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildHoldingsHeader() {
    return Row(
      children: [
        const Text('持有代币', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        const Text('活动', style: TextStyle(fontSize: 16, color: Colors.grey)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('U ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('闪兑', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTokenList() {
    return Column(
      children: [
        Row(
          children: [
            const Text('排序: ', style: TextStyle(color: Colors.grey)),
            const Text('最后活跃 ', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('从高到低', style: TextStyle(color: Colors.grey)),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
            const Spacer(),
            const Icon(Icons.filter_list, color: Colors.grey),
            const SizedBox(width: 4),
            const Text('筛选', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        _buildTokenCard('USDC', 'USDC图标', '最后活跃: 39d', '余额(≈)/数量', '0.042518 SOL', '416.5', '总买入/平均', '0.00599 SOL', '\$0.00208', '总利润/未实现利润', '-0.0×114 SOL(-96.38%)', '-0.0×114 SOL(-96.38%)'),
        const SizedBox(height: 16),
        _buildTokenCard('CASEY', 'CASEY图标', '最后活跃: 41d', '余额(≈)/数量', '-- SOL', '--', '总买入/平均', '-- SOL', '--', '总利润/未实现利润', '--', '--'),
      ],
    );
  }

  Widget _buildTokenCard(String symbol, String iconDescription, String lastActive, String balanceLabel, String balance, String quantity, String buyLabel, String totalBuy, String avgBuy, String profitLabel, String totalProfit, String unrealizedProfit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: symbol == 'USDC' ? Colors.blue : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    symbol.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(symbol, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Icon(Icons.copy, size: 12, color: Colors.grey),
                    ],
                  ),
                  Text(lastActive, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.share, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('分享', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 8),
                  const Text('更多', style: TextStyle(color: Colors.grey)),
                  const Icon(Icons.more_vert, color: Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(balanceLabel, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(balance, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(quantity, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buyLabel, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(totalBuy, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(avgBuy, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profitLabel, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(totalProfit, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text(unrealizedProfit, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfitDistributionTab() {
    return const Center(child: Text('盈利分布'));
  }

  Widget _buildFishingDetectionTab() {
    return const Center(child: Text('钓鱼检测'));
  }

  Widget _buildOtherTab() {
    return const Center(child: Text('其他'));
  }
}