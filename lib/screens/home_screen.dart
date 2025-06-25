import 'package:flutter/material.dart';
import '../widgets/crypto_card.dart';
import '../models/crypto_token.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = '筛选';
  String _selectedSort = '暂停';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
            // 顶部搜索栏
            _buildSearchHeader(),
            // SOL价格显示
            _buildSolPriceCard(),
            // 功能按钮
            _buildActionButtons(),
            // 标签栏
            _buildTabBar(),
            // 筛选排序
            _buildFilterRow(),
            // 代币列表
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCryptoList(),
                  _buildCryptoList(),
                  _buildCryptoList(),
                  _buildCryptoList(),
                  _buildCryptoList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
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
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: '搜索代币/钱包',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Icon(Icons.qr_code_scanner, color: Colors.black),
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
          Tab(text: '自选列表'),
          Tab(text: '战绩'),
          Tab(text: '新币'),
          Tab(text: '热门'),
          Tab(text: '监控广场'),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.grey[600]),
          const SizedBox(width: 8),
          _buildFilterChip(_selectedFilter),
          const SizedBox(width: 8),
          const Icon(Icons.star_border, color: Colors.orange),
          const SizedBox(width: 8),
          Text('暂停', style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          const Icon(Icons.flash_on, color: Color(0xFF9CFF2A)),
          const Text('买入', style: TextStyle(color: Color(0xFF9CFF2A), fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text('SOL  P1', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 8),
          const Icon(Icons.settings, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildCryptoList() {
    final tokens = _getMockTokens();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        return CryptoCard(token: tokens[index]);
      },
    );
  }

  List<CryptoToken> _getMockTokens() {
    return [
      CryptoToken(
        symbol: 'TTT',
        name: '8BTQ...pump',
        price: '\$352.75',
        marketCap: '\$4.6K',
        change24h: 11.0,
        change1h: 4.0,
        change5m: 4.0,
        volume: '\$0',
        holders: 1,
        age: '2s',
        imageUrl: '',
        isNew: false,
      ),
      CryptoToken(
        symbol: 'Alphaledge',
        name: 'CXXX...pump',
        price: '\$417.22',
        marketCap: '\$4.74K',
        change24h: 11.0,
        change1h: 6.0,
        change5m: 6.0,
        volume: '\$0',
        holders: 1,
        age: '3s',
        imageUrl: '',
        isNew: false,
      ),
      CryptoToken(
        symbol: 'DOGMELON',
        name: 'ERak...pump',
        price: '\$127.54',
        marketCap: '\$4.14K',
        change24h: 1.0,
        change1h: 1.0,
        change5m: 1.0,
        volume: '\$0',
        holders: 3,
        age: '9s',
        imageUrl: '',
        isNew: false,
      ),
      CryptoToken(
        symbol: 'BTL',
        name: '7mNp...pump',
        price: '\$373.98',
        marketCap: '\$4.63K',
        change24h: 8.0,
        change1h: 6.0,
        change5m: 6.0,
        volume: '\$0',
        holders: 4,
        age: '12s',
        imageUrl: '',
        isNew: false,
      ),
    ];
  }
}