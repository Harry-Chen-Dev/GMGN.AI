import 'package:flutter/foundation.dart';
import '../../data/models/wallet.dart';

class CopyTradeProvider extends ChangeNotifier {
  List<CopyTrader> _traders = [];
  List<CopyTrader> _followingTraders = [];
  bool _isLoading = false;
  String? _errorMessage;
  CopyTradeFilter _currentFilter = CopyTradeFilter.all;

  // Getters
  List<CopyTrader> get traders => _traders;
  List<CopyTrader> get followingTraders => _followingTraders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CopyTradeFilter get currentFilter => _currentFilter;

  List<CopyTrader> get filteredTraders {
    switch (_currentFilter) {
      case CopyTradeFilter.all:
        return _traders;
      case CopyTradeFilter.following:
        return _followingTraders;
      case CopyTradeFilter.topPerformers:
        return List.from(_traders)..sort((a, b) => b.roi30d.compareTo(a.roi30d));
      case CopyTradeFilter.highWinRate:
        return List.from(_traders)..sort((a, b) => b.winRate.compareTo(a.winRate));
    }
  }

  // Load traders
  Future<void> loadTraders() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _traders = _generateMockTraders();
      _followingTraders = _traders.where((trader) => trader.isFollowing).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Follow trader
  Future<bool> followTrader(String traderId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final traderIndex = _traders.indexWhere((trader) => trader.id == traderId);
      if (traderIndex != -1) {
        _traders[traderIndex] = CopyTrader(
          id: _traders[traderIndex].id,
          address: _traders[traderIndex].address,
          name: _traders[traderIndex].name,
          avatar: _traders[traderIndex].avatar,
          totalValue: _traders[traderIndex].totalValue,
          roi7d: _traders[traderIndex].roi7d,
          roi30d: _traders[traderIndex].roi30d,
          winRate: _traders[traderIndex].winRate,
          totalTrades: _traders[traderIndex].totalTrades,
          followers: _traders[traderIndex].followers + 1,
          isFollowing: true,
          specialties: _traders[traderIndex].specialties,
        );

        _followingTraders = _traders.where((trader) => trader.isFollowing).toList();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Unfollow trader
  Future<bool> unfollowTrader(String traderId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final traderIndex = _traders.indexWhere((trader) => trader.id == traderId);
      if (traderIndex != -1) {
        _traders[traderIndex] = CopyTrader(
          id: _traders[traderIndex].id,
          address: _traders[traderIndex].address,
          name: _traders[traderIndex].name,
          avatar: _traders[traderIndex].avatar,
          totalValue: _traders[traderIndex].totalValue,
          roi7d: _traders[traderIndex].roi7d,
          roi30d: _traders[traderIndex].roi30d,
          winRate: _traders[traderIndex].winRate,
          totalTrades: _traders[traderIndex].totalTrades,
          followers: _traders[traderIndex].followers - 1,
          isFollowing: false,
          specialties: _traders[traderIndex].specialties,
        );

        _followingTraders = _traders.where((trader) => trader.isFollowing).toList();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Set filter
  void setFilter(CopyTradeFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Refresh traders
  Future<void> refreshTraders() async {
    await loadTraders();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Generate mock trader data
  List<CopyTrader> _generateMockTraders() {
    return [
      CopyTrader(
        id: 'trader_1',
        address: '7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU',
        name: '神秘狙击手',
        avatar: null,
        totalValue: 2580000,
        roi7d: 45.8,
        roi30d: 185.6,
        winRate: 87.5,
        totalTrades: 1250,
        followers: 8950,
        isFollowing: true,
        specialties: ['MEME代币', '早期发现', '高频交易'],
      ),
      CopyTrader(
        id: 'trader_2',
        address: '4J8kMnQ9pL5hF2dNrEwS6vG1zX3cY7tA8qB9mKjH5nPr',
        name: 'DeFi猎手',
        avatar: null,
        totalValue: 1850000,
        roi7d: 28.4,
        roi30d: 95.2,
        winRate: 72.1,
        totalTrades: 890,
        followers: 5420,
        isFollowing: false,
        specialties: ['DeFi', '流动性挖矿', '收益农场'],
      ),
      CopyTrader(
        id: 'trader_3',
        address: '9H2bWnR5vL3gF6pMQjYxB8UzD4hJ2kS7nE1fZcPqXmRt',
        name: 'Alpha发现者',
        avatar: null,
        totalValue: 1200000,
        roi7d: 65.2,
        roi30d: 225.8,
        winRate: 91.3,
        totalTrades: 650,
        followers: 12450,
        isFollowing: false,
        specialties: ['新币发现', 'IDO投资', '私募轮次'],
      ),
      CopyTrader(
        id: 'trader_4',
        address: '5K6bWnR9vL2gF4pMQjYxB6UzD7hJ3kS1nE9fZcPqXmRt',
        name: 'NFT专家',
        avatar: null,
        totalValue: 950000,
        roi7d: -5.8,
        roi30d: 45.6,
        winRate: 68.9,
        totalTrades: 420,
        followers: 3250,
        isFollowing: false,
        specialties: ['NFT交易', '艺术收藏', '游戏道具'],
      ),
      CopyTrader(
        id: 'trader_5',
        address: '8L7bWnR4vL9gF3pMQjYxB5UzD6hJ4kS2nE7fZcPqXmRt',
        name: '稳定收益王',
        avatar: null,
        totalValue: 3200000,
        roi7d: 8.5,
        roi30d: 35.2,
        winRate: 95.7,
        totalTrades: 2150,
        followers: 15680,
        isFollowing: true,
        specialties: ['稳定币策略', '套利交易', '风险管理'],
      ),
      CopyTrader(
        id: 'trader_6',
        address: '6N8bWnR7vL4gF5pMQjYxB3UzD5hJ7kS4nE6fZcPqXmRt',
        name: '波段大师',
        avatar: null,
        totalValue: 1680000,
        roi7d: 22.1,
        roi30d: 78.9,
        winRate: 79.4,
        totalTrades: 1580,
        followers: 7230,
        isFollowing: false,
        specialties: ['技术分析', '波段操作', '趋势跟踪'],
      ),
      CopyTrader(
        id: 'trader_7',
        address: '3M5bWnR6vL8gF7pMQjYxB4UzD8hJ5kS3nE4fZcPqXmRt',
        name: '量化机器人',
        avatar: null,
        totalValue: 4500000,
        roi7d: 15.8,
        roi30d: 58.7,
        winRate: 84.2,
        totalTrades: 5680,
        followers: 22100,
        isFollowing: false,
        specialties: ['量化交易', '算法策略', '高频交易'],
      ),
      CopyTrader(
        id: 'trader_8',
        address: '2P4bWnR8vL6gF8pMQjYxB7UzD9hJ6kS5nE8fZcPqXmRt',
        name: '潜力挖掘者',
        avatar: null,
        totalValue: 800000,
        roi7d: 95.4,
        roi30d: 320.5,
        winRate: 65.8,
        totalTrades: 380,
        followers: 18750,
        isFollowing: false,
        specialties: ['小市值币', '百倍潜力', '风险投资'],
      ),
    ];
  }
}

enum CopyTradeFilter {
  all,
  following,
  topPerformers,
  highWinRate,
}