class CryptoToken {
  final String symbol;
  final String name;
  final String contractAddress;
  final double price;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double volume24h;
  final double marketCap;
  final String imageUrl;
  final double? userBalance;
  final double? userBalanceUsd;
  final List<PricePoint> priceHistory;
  final TokenSecurity? security;

  CryptoToken({
    required this.symbol,
    required this.name,
    required this.contractAddress,
    required this.price,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.volume24h,
    required this.marketCap,
    required this.imageUrl,
    this.userBalance,
    this.userBalanceUsd,
    this.priceHistory = const [],
    this.security,
  });

  factory CryptoToken.fromJson(Map<String, dynamic> json) {
    return CryptoToken(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      contractAddress: json['contract_address'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0.0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
      volume24h: (json['volume_24h'] ?? 0.0).toDouble(),
      marketCap: (json['market_cap'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      userBalance: json['user_balance']?.toDouble(),
      userBalanceUsd: json['user_balance_usd']?.toDouble(),
      priceHistory: (json['price_history'] as List<dynamic>?)
          ?.map((e) => PricePoint.fromJson(e))
          .toList() ?? [],
      security: json['security'] != null ? TokenSecurity.fromJson(json['security']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'contract_address': contractAddress,
      'price': price,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'volume_24h': volume24h,
      'market_cap': marketCap,
      'image_url': imageUrl,
      'user_balance': userBalance,
      'user_balance_usd': userBalanceUsd,
      'price_history': priceHistory.map((e) => e.toJson()).toList(),
      'security': security?.toJson(),
    };
  }

  bool get isPositiveChange => priceChangePercentage24h >= 0;
  
  String get formattedPrice {
    if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)}';
    } else {
      return '\$${price.toStringAsExponential(2)}';
    }
  }

  String get formattedChange {
    final sign = isPositiveChange ? '+' : '';
    return '$sign${priceChangePercentage24h.toStringAsFixed(2)}%';
  }

  String get formattedVolume {
    if (volume24h >= 1000000) {
      return '\$${(volume24h / 1000000).toStringAsFixed(1)}M';
    } else if (volume24h >= 1000) {
      return '\$${(volume24h / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${volume24h.toStringAsFixed(0)}';
    }
  }

  String get formattedMarketCap {
    if (marketCap >= 1000000000) {
      return '\$${(marketCap / 1000000000).toStringAsFixed(1)}B';
    } else if (marketCap >= 1000000) {
      return '\$${(marketCap / 1000000).toStringAsFixed(1)}M';
    } else if (marketCap >= 1000) {
      return '\$${(marketCap / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${marketCap.toStringAsFixed(0)}';
    }
  }
}

class PricePoint {
  final DateTime timestamp;
  final double price;

  PricePoint({
    required this.timestamp,
    required this.price,
  });

  factory PricePoint.fromJson(Map<String, dynamic> json) {
    return PricePoint(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'price': price,
    };
  }
}

class TokenSecurity {
  final bool isHoneypot;
  final bool hasLiquidity;
  final bool canTrade;
  final double liquidityPercentage;
  final int holderCount;
  final List<String> riskFactors;

  TokenSecurity({
    required this.isHoneypot,
    required this.hasLiquidity,
    required this.canTrade,
    required this.liquidityPercentage,
    required this.holderCount,
    required this.riskFactors,
  });

  factory TokenSecurity.fromJson(Map<String, dynamic> json) {
    return TokenSecurity(
      isHoneypot: json['is_honeypot'] ?? false,
      hasLiquidity: json['has_liquidity'] ?? true,
      canTrade: json['can_trade'] ?? true,
      liquidityPercentage: (json['liquidity_percentage'] ?? 0.0).toDouble(),
      holderCount: json['holder_count'] ?? 0,
      riskFactors: List<String>.from(json['risk_factors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_honeypot': isHoneypot,
      'has_liquidity': hasLiquidity,
      'can_trade': canTrade,
      'liquidity_percentage': liquidityPercentage,
      'holder_count': holderCount,
      'risk_factors': riskFactors,
    };
  }

  SecurityLevel get securityLevel {
    if (isHoneypot || riskFactors.length > 3) {
      return SecurityLevel.high;
    } else if (riskFactors.length > 1 || liquidityPercentage < 50) {
      return SecurityLevel.medium;
    } else {
      return SecurityLevel.low;
    }
  }
}

enum SecurityLevel {
  low,
  medium,
  high,
}