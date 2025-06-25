import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedPeriod = '7D';
  String _selectedSort = 'PnL 从高到低';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题栏
            _buildHeader(),
            // 筛选栏
            _buildFilterRow(),
            // 交易员列表
            Expanded(child: _buildTraderList()),
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
          const Text(
            '牛人榜',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          const Text(
            '钱包跟单',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Spacer(),
          const Icon(Icons.search, color: Colors.black),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.create, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text('创建', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildDropdownButton('周期: $_selectedPeriod', (value) {
            setState(() {
              _selectedPeriod = value;
            });
          }),
          const SizedBox(width: 16),
          _buildDropdownButton('排序: $_selectedSort', (value) {
            setState(() {
              _selectedSort = value;
            });
          }),
          const Spacer(),
          const Icon(Icons.filter_list, color: Colors.grey),
          const SizedBox(width: 4),
          const Text('筛选', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String text, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildTraderList() {
    final traders = _getMockTraders();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: traders.length,
      itemBuilder: (context, index) {
        return _buildTraderCard(traders[index], index + 1);
      },
    );
  }

  Widget _buildTraderCard(Map<String, dynamic> trader, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // 交易员基本信息
          Row(
            children: [
              // 排名徽章
              Container(
                width: 32,
                height: 20,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _getRankText(rank),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 头像
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              // 交易员信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          trader['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Icon(Icons.copy, size: 14, color: Colors.grey),
                      ],
                    ),
                    Text(
                      trader['sol'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // 收益
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    trader['profit'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CFF2A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    trader['profitPercent'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CFF2A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 统计信息
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('粉丝', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(trader['followers'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('交易数/胜率', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('${trader['trades']} (${trader['winRate']})/100%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('最后活动', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(trader['lastActivity'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 实现跟单功能
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('跟单', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 实现关注功能
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('关注', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getRankText(int rank) {
    switch (rank) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${rank}th';
    }
  }

  List<Map<String, dynamic>> _getMockTraders() {
    return [
      {
        'name': 'AdBd...vwdq',
        'sol': '0.404',
        'profit': '+\$699.05',
        'profitPercent': '+20K% PnL',
        'followers': 14,
        'trades': 6,
        'winRate': '5/1',
        'lastActivity': '1h以前',
      },
      {
        'name': 'A4aV...YKBA',
        'sol': '0.1',
        'profit': '+\$6.39K',
        'profitPercent': '+16.66K% PnL',
        'followers': 178,
        'trades': 3,
        'winRate': '1/2',
        'lastActivity': '2d以前',
      },
      {
        'name': 'C7gh...52Em',
        'sol': '0',
        'profit': '+\$5.83K',
        'profitPercent': '+13.91K% PnL',
        'followers': 50,
        'trades': 4,
        'winRate': '1/3',
        'lastActivity': '1d以前',
      },
      {
        'name': '7Ep1...dBcQ',
        'sol': '0',
        'profit': '+\$5.74K',
        'profitPercent': '+13.55K% PnL',
        'followers': 55,
        'trades': 5,
        'winRate': '1/4',
        'lastActivity': '2d以前',
      },
    ];
  }
}