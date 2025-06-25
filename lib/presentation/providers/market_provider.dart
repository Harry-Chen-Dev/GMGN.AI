import 'package:flutter/foundation.dart';
import '../../data/models/crypto_token.dart';

class MarketProvider extends ChangeNotifier {
  List<CryptoToken> _tokens = [];
  List<CryptoToken> _trendingTokens = [];
  List<CryptoToken> _newTokens = [];
  List<CryptoToken> _gainers = [];
  List<CryptoToken> _losers = [];
  bool _isLoading = false;
  String? _errorMessage;
  MarketFilter _currentFilter = MarketFilter.all;

  // Getters
  List<CryptoToken> get tokens => _tokens;
  List<CryptoToken> get trendingTokens => _trendingTokens;
  List<CryptoToken> get newTokens => _newTokens;
  List<CryptoToken> get gainers => _gainers;
  List<CryptoToken> get losers => _losers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MarketFilter get currentFilter => _currentFilter;

  List<CryptoToken> get filteredTokens {
    switch (_currentFilter) {
      case MarketFilter.all:
        return _tokens;
      case MarketFilter.trending:
        return _trendingTokens;
      case MarketFilter.new_:
        return _newTokens;
      case MarketFilter.gainers:
        return _gainers;
      case MarketFilter.losers:
        return _losers;
    }
  }

  // Load market data
  Future<void> loadMarketData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _tokens = _generateMockTokens();
      _categorizeTokens();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh market data
  Future<void> refreshMarketData() async {
    await loadMarketData();
  }

  // Set filter
  void setFilter(MarketFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Categorize tokens
  void _categorizeTokens() {
    // Trending tokens (high volume)
    _trendingTokens = List.from(_tokens)
      ..sort((a, b) => b.volume24h.compareTo(a.volume24h))
      ..take(10);

    // New tokens (recent listings)
    _newTokens = _tokens.where((token) => 
        token.symbol == 'PEPE2' || 
        token.symbol == 'WOJAK' || 
        token.symbol == 'RIBBIT'
    ).toList();

    // Gainers (positive change > 10%)
    _gainers = _tokens.where((token) => 
        token.priceChangePercentage24h > 10
    ).toList()
      ..sort((a, b) => b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));

    // Losers (negative change < -10%)
    _losers = _tokens.where((token) => 
        token.priceChangePercentage24h < -10
    ).toList()
      ..sort((a, b) => a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h));
  }

  // Generate mock token data
  List<CryptoToken> _generateMockTokens() {
    return [
      CryptoToken(
        symbol: 'SOL',
        name: 'Solana',
        contractAddress: 'So11111111111111111111111111111111111111112',
        price: 98.45,
        priceChange24h: 5.32,
        priceChangePercentage24h: 5.7,
        volume24h: 2500000000,
        marketCap: 45000000000,
        imageUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        priceHistory: _generatePriceHistory(98.45),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 85.5,
          holderCount: 1250000,
          riskFactors: [],
        ),
      ),
      CryptoToken(
        symbol: 'BONK',
        name: 'Bonk',
        contractAddress: 'DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263',
        price: 0.000035,
        priceChange24h: 0.000008,
        priceChangePercentage24h: 29.6,
        volume24h: 150000000,
        marketCap: 2800000000,
        imageUrl: 'https://assets.coingecko.com/coins/images/28600/small/bonk.jpg',
        priceHistory: _generatePriceHistory(0.000035),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 75.2,
          holderCount: 850000,
          riskFactors: ['High volatility'],
        ),
      ),
      CryptoToken(
        symbol: 'WIF',
        name: 'dogwifhat',
        contractAddress: 'EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm',
        price: 2.85,
        priceChange24h: -0.45,
        priceChangePercentage24h: -13.6,
        volume24h: 85000000,
        marketCap: 2850000000,
        imageUrl: 'https://assets.coingecko.com/coins/images/33767/small/wif.png',
        priceHistory: _generatePriceHistory(2.85),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 68.8,
          holderCount: 450000,
          riskFactors: ['Meme token', 'High volatility'],
        ),
      ),
      CryptoToken(
        symbol: 'PEPE',
        name: 'Pepe',
        contractAddress: '6GCVWv9LUcSJE5pLB1a3Hc8j8cE9qKNp7v8ZD3U1mKLk',
        price: 0.00000125,
        priceChange24h: 0.00000018,
        priceChangePercentage24h: 16.8,
        volume24h: 95000000,
        marketCap: 525000000,
        imageUrl: 'https://assets.coingecko.com/coins/images/29850/small/pepe-token.jpeg',
        priceHistory: _generatePriceHistory(0.00000125),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 72.4,
          holderCount: 320000,
          riskFactors: ['Meme token', 'High volatility'],
        ),
      ),
      CryptoToken(
        symbol: 'SHIB',
        name: 'Shiba Inu',
        contractAddress: '8UbQGvTVwjbEpV3MpgXGvMnQ4PZz6LJk5H2k1VvGkLpP',
        price: 0.0000085,
        priceChange24h: -0.0000012,
        priceChangePercentage24h: -12.4,
        volume24h: 125000000,
        marketCap: 5000000000,
        imageUrl: 'https://assets.coingecko.com/coins/images/11939/small/shiba.png',
        priceHistory: _generatePriceHistory(0.0000085),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 80.1,
          holderCount: 1350000,
          riskFactors: ['Meme token'],
        ),
      ),
      CryptoToken(
        symbol: 'MOODENG',
        name: 'Moo Deng',
        contractAddress: '9H7BfW2b4Y8kF3LkE5pMQNqZjD6vW8UjS7nG1RfKcPqX',
        price: 0.285,
        priceChange24h: 0.156,
        priceChangePercentage24h: 121.7,
        volume24h: 45000000,
        marketCap: 285000000,
        imageUrl: 'https://assets.coingecko.com/coins/images/52210/small/photo_2024-09-27_19-34-00.jpg',
        priceHistory: _generatePriceHistory(0.285),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 65.3,
          holderCount: 85000,
          riskFactors: ['New token', 'Meme token', 'High volatility'],
        ),
      ),
      CryptoToken(
        symbol: 'PEPE2',
        name: 'Pepe 2.0',
        contractAddress: '5K8bWnR9vL2gF4pMQjYxB6UzD7hJ3kS1nE9fZcPqXmRt',
        price: 0.00000045,
        priceChange24h: 0.00000025,
        priceChangePercentage24h: 125.0,
        volume24h: 25000000,
        marketCap: 45000000,
        imageUrl: 'https://assets.coingecko.com/coins/images/29850/small/pepe-token.jpeg',
        priceHistory: _generatePriceHistory(0.00000045),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 55.8,
          holderCount: 15000,
          riskFactors: ['New token', 'Meme token', 'High volatility', 'Low liquidity'],
        ),
      ),
      CryptoToken(
        symbol: 'WOJAK',
        name: 'Wojak Coin',
        contractAddress: '7N3mPvQ8hJ2gE9rKjYwB5UzF4pL6kS8nD1fZcXqRmKs',
        price: 0.00125,
        priceChange24h: -0.00085,
        priceChangePercentage24h: -40.5,
        volume24h: 8500000,
        marketCap: 12500000,
        imageUrl: 'https://assets.coingecko.com/coins/images/30323/small/wojak.png',
        priceHistory: _generatePriceHistory(0.00125),
        security: TokenSecurity(
          isHoneypot: false,
          hasLiquidity: true,
          canTrade: true,
          liquidityPercentage: 48.2,
          holderCount: 8500,
          riskFactors: ['New token', 'Meme token', 'High volatility', 'Low liquidity'],
        ),
      ),
    ];
  }

  // Generate mock price history
  List<PricePoint> _generatePriceHistory(double currentPrice) {
    final points = <PricePoint>[];
    final now = DateTime.now();
    var price = currentPrice * 0.8;

    for (int i = 24; i >= 0; i--) {
      final timestamp = now.subtract(Duration(hours: i));
      price += (currentPrice * 0.02) * (0.5 - (i % 5) / 10.0);
      points.add(PricePoint(timestamp: timestamp, price: price));
    }

    return points;
  }
}

enum MarketFilter {
  all,
  trending,
  new_,
  gainers,
  losers,
}