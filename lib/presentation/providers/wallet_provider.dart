import 'package:flutter/foundation.dart';
import '../../data/models/wallet.dart';
import '../../data/models/crypto_token.dart';

class WalletProvider extends ChangeNotifier {
  List<Wallet> _wallets = [];
  Wallet? _selectedWallet;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Wallet> get wallets => _wallets;
  Wallet? get selectedWallet => _selectedWallet;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalPortfolioValue {
    return _wallets.fold(0.0, (sum, wallet) => sum + wallet.totalValue);
  }

  double get totalPortfolioChange24h {
    return _wallets.fold(0.0, (sum, wallet) => sum + wallet.totalValueChange24h);
  }

  double get totalPortfolioChangePercentage24h {
    if (totalPortfolioValue == 0) return 0.0;
    return (totalPortfolioChange24h / (totalPortfolioValue - totalPortfolioChange24h)) * 100;
  }

  // Initialize with mock data
  Future<void> loadWallets() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _wallets = _generateMockWallets();
      if (_wallets.isNotEmpty) {
        _selectedWallet = _wallets.first;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load transactions for selected wallet
  Future<void> loadTransactions() async {
    if (_selectedWallet == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      _transactions = _generateMockTransactions();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select wallet
  void selectWallet(Wallet wallet) {
    _selectedWallet = wallet;
    notifyListeners();
    loadTransactions();
  }

  // Refresh wallet data
  Future<void> refreshWallets() async {
    await loadWallets();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Generate mock wallet data
  List<Wallet> _generateMockWallets() {
    return [
      Wallet(
        address: '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        name: '主钱包',
        type: WalletType.connected,
        totalValue: 12580.45,
        totalValueChange24h: 1250.32,
        totalValueChangePercentage24h: 11.05,
        tokens: [
          WalletToken(
            token: CryptoToken(
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
            ),
            balance: 45.5,
            value: 4479.47,
            valueChange24h: 259.36,
            valueChangePercentage24h: 6.15,
          ),
          WalletToken(
            token: CryptoToken(
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
            ),
            balance: 125000000,
            value: 4375.00,
            valueChange24h: 1003.45,
            valueChangePercentage24h: 29.8,
          ),
          WalletToken(
            token: CryptoToken(
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
            ),
            balance: 1250,
            value: 3562.50,
            valueChange24h: -562.50,
            valueChangePercentage24h: -13.6,
          ),
        ],
        recentTransactions: [],
        lastUpdated: DateTime.now(),
      ),
      Wallet(
        address: '7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU',
        name: '跟单钱包',
        type: WalletType.copy,
        totalValue: 5680.20,
        totalValueChange24h: -320.15,
        totalValueChangePercentage24h: -5.34,
        tokens: [],
        recentTransactions: [],
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  // Generate mock transaction data
  List<Transaction> _generateMockTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: 'tx_1',
        hash: '5J8...9K4',
        type: TransactionType.buy,
        fromAddress: '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        toAddress: 'DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263',
        token: CryptoToken(
          symbol: 'BONK',
          name: 'Bonk',
          contractAddress: 'DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263',
          price: 0.000035,
          priceChange24h: 0.000008,
          priceChangePercentage24h: 29.6,
          volume24h: 150000000,
          marketCap: 2800000000,
          imageUrl: 'https://assets.coingecko.com/coins/images/28600/small/bonk.jpg',
        ),
        amount: 50000000,
        value: 1750.00,
        fee: 0.25,
        status: TransactionStatus.confirmed,
        timestamp: now.subtract(const Duration(hours: 2)),
        blockNumber: '225847392',
      ),
      Transaction(
        id: 'tx_2',
        hash: '8L3...2F7',
        type: TransactionType.sell,
        fromAddress: '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        toAddress: 'EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm',
        token: CryptoToken(
          symbol: 'WIF',
          name: 'dogwifhat',
          contractAddress: 'EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm',
          price: 3.30,
          priceChange24h: -0.45,
          priceChangePercentage24h: -13.6,
          volume24h: 85000000,
          marketCap: 2850000000,
          imageUrl: 'https://assets.coingecko.com/coins/images/33767/small/wif.png',
        ),
        amount: 500,
        value: 1650.00,
        fee: 0.18,
        status: TransactionStatus.confirmed,
        timestamp: now.subtract(const Duration(hours: 6)),
        blockNumber: '225847125',
      ),
      Transaction(
        id: 'tx_3',
        hash: '9M4...6H8',
        type: TransactionType.swap,
        fromAddress: '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        toAddress: 'So11111111111111111111111111111111111111112',
        token: CryptoToken(
          symbol: 'SOL',
          name: 'Solana',
          contractAddress: 'So11111111111111111111111111111111111111112',
          price: 93.15,
          priceChange24h: 5.32,
          priceChangePercentage24h: 5.7,
          volume24h: 2500000000,
          marketCap: 45000000000,
          imageUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        ),
        amount: 10.5,
        value: 978.07,
        fee: 0.12,
        status: TransactionStatus.confirmed,
        timestamp: now.subtract(const Duration(days: 1)),
        blockNumber: '225840892',
      ),
    ];
  }

  // Generate mock price history
  List<PricePoint> _generatePriceHistory(double currentPrice) {
    final points = <PricePoint>[];
    final now = DateTime.now();
    var price = currentPrice * 0.8; // Start from 80% of current price

    for (int i = 24; i >= 0; i--) {
      final timestamp = now.subtract(Duration(hours: i));
      // Add some random variation
      price += (currentPrice * 0.02) * (0.5 - (i % 5) / 10.0);
      points.add(PricePoint(timestamp: timestamp, price: price));
    }

    return points;
  }
}