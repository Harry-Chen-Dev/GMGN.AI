import 'crypto_token.dart';

class Wallet {
  final String address;
  final String name;
  final WalletType type;
  final double totalValue;
  final double totalValueChange24h;
  final double totalValueChangePercentage24h;
  final List<WalletToken> tokens;
  final List<Transaction> recentTransactions;
  final DateTime lastUpdated;

  Wallet({
    required this.address,
    required this.name,
    required this.type,
    required this.totalValue,
    required this.totalValueChange24h,
    required this.totalValueChangePercentage24h,
    required this.tokens,
    required this.recentTransactions,
    required this.lastUpdated,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      type: WalletType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => WalletType.connected,
      ),
      totalValue: (json['total_value'] ?? 0.0).toDouble(),
      totalValueChange24h: (json['total_value_change_24h'] ?? 0.0).toDouble(),
      totalValueChangePercentage24h: (json['total_value_change_percentage_24h'] ?? 0.0).toDouble(),
      tokens: (json['tokens'] as List<dynamic>?)
          ?.map((e) => WalletToken.fromJson(e))
          .toList() ?? [],
      recentTransactions: (json['recent_transactions'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e))
          .toList() ?? [],
      lastUpdated: DateTime.parse(json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'name': name,
      'type': type.toString(),
      'total_value': totalValue,
      'total_value_change_24h': totalValueChange24h,
      'total_value_change_percentage_24h': totalValueChangePercentage24h,
      'tokens': tokens.map((e) => e.toJson()).toList(),
      'recent_transactions': recentTransactions.map((e) => e.toJson()).toList(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  bool get isPositiveChange => totalValueChangePercentage24h >= 0;

  String get formattedTotalValue {
    if (totalValue >= 1000000) {
      return '\$${(totalValue / 1000000).toStringAsFixed(1)}M';
    } else if (totalValue >= 1000) {
      return '\$${(totalValue / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${totalValue.toStringAsFixed(2)}';
    }
  }

  String get formattedChange {
    final sign = isPositiveChange ? '+' : '';
    return '$sign${totalValueChangePercentage24h.toStringAsFixed(2)}%';
  }

  String get shortAddress {
    if (address.length < 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }
}

class WalletToken {
  final CryptoToken token;
  final double balance;
  final double value;
  final double valueChange24h;
  final double valueChangePercentage24h;

  WalletToken({
    required this.token,
    required this.balance,
    required this.value,
    required this.valueChange24h,
    required this.valueChangePercentage24h,
  });

  factory WalletToken.fromJson(Map<String, dynamic> json) {
    return WalletToken(
      token: CryptoToken.fromJson(json['token'] ?? {}),
      balance: (json['balance'] ?? 0.0).toDouble(),
      value: (json['value'] ?? 0.0).toDouble(),
      valueChange24h: (json['value_change_24h'] ?? 0.0).toDouble(),
      valueChangePercentage24h: (json['value_change_percentage_24h'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token.toJson(),
      'balance': balance,
      'value': value,
      'value_change_24h': valueChange24h,
      'value_change_percentage_24h': valueChangePercentage24h,
    };
  }

  bool get isPositiveChange => valueChangePercentage24h >= 0;

  String get formattedBalance {
    if (balance >= 1000000) {
      return '${(balance / 1000000).toStringAsFixed(1)}M';
    } else if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(1)}K';
    } else if (balance >= 1) {
      return balance.toStringAsFixed(2);
    } else {
      return balance.toStringAsFixed(6);
    }
  }

  String get formattedValue {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }
}

class Transaction {
  final String id;
  final String hash;
  final TransactionType type;
  final String fromAddress;
  final String toAddress;
  final CryptoToken token;
  final double amount;
  final double value;
  final double fee;
  final TransactionStatus status;
  final DateTime timestamp;
  final String? blockNumber;

  Transaction({
    required this.id,
    required this.hash,
    required this.type,
    required this.fromAddress,
    required this.toAddress,
    required this.token,
    required this.amount,
    required this.value,
    required this.fee,
    required this.status,
    required this.timestamp,
    this.blockNumber,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      hash: json['hash'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TransactionType.swap,
      ),
      fromAddress: json['from_address'] ?? '',
      toAddress: json['to_address'] ?? '',
      token: CryptoToken.fromJson(json['token'] ?? {}),
      amount: (json['amount'] ?? 0.0).toDouble(),
      value: (json['value'] ?? 0.0).toDouble(),
      fee: (json['fee'] ?? 0.0).toDouble(),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      blockNumber: json['block_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hash': hash,
      'type': type.toString(),
      'from_address': fromAddress,
      'to_address': toAddress,
      'token': token.toJson(),
      'amount': amount,
      'value': value,
      'fee': fee,
      'status': status.toString(),
      'timestamp': timestamp.toIso8601String(),
      'block_number': blockNumber,
    };
  }

  String get formattedAmount {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else if (amount >= 1) {
      return amount.toStringAsFixed(2);
    } else {
      return amount.toStringAsFixed(6);
    }
  }

  String get formattedValue {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }

  String get shortHash {
    if (hash.length < 10) return hash;
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 4)}';
  }

  String get typeDisplayName {
    switch (type) {
      case TransactionType.buy:
        return 'Buy';
      case TransactionType.sell:
        return 'Sell';
      case TransactionType.swap:
        return 'Swap';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.withdraw:
        return 'Withdraw';
    }
  }
}

enum WalletType {
  connected,
  imported,
  copy,
}

enum TransactionType {
  buy,
  sell,
  swap,
  transfer,
  deposit,
  withdraw,
}

enum TransactionStatus {
  pending,
  confirmed,
  failed,
  cancelled,
}

class CopyTrader {
  final String id;
  final String address;
  final String name;
  final String? avatar;
  final double totalValue;
  final double roi7d;
  final double roi30d;
  final double winRate;
  final int totalTrades;
  final int followers;
  final bool isFollowing;
  final List<String> specialties;

  CopyTrader({
    required this.id,
    required this.address,
    required this.name,
    this.avatar,
    required this.totalValue,
    required this.roi7d,
    required this.roi30d,
    required this.winRate,
    required this.totalTrades,
    required this.followers,
    required this.isFollowing,
    required this.specialties,
  });

  factory CopyTrader.fromJson(Map<String, dynamic> json) {
    return CopyTrader(
      id: json['id'] ?? '',
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      totalValue: (json['total_value'] ?? 0.0).toDouble(),
      roi7d: (json['roi_7d'] ?? 0.0).toDouble(),
      roi30d: (json['roi_30d'] ?? 0.0).toDouble(),
      winRate: (json['win_rate'] ?? 0.0).toDouble(),
      totalTrades: json['total_trades'] ?? 0,
      followers: json['followers'] ?? 0,
      isFollowing: json['is_following'] ?? false,
      specialties: List<String>.from(json['specialties'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'name': name,
      'avatar': avatar,
      'total_value': totalValue,
      'roi_7d': roi7d,
      'roi_30d': roi30d,
      'win_rate': winRate,
      'total_trades': totalTrades,
      'followers': followers,
      'is_following': isFollowing,
      'specialties': specialties,
    };
  }

  String get shortAddress {
    if (address.length < 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String get formattedRoi7d {
    final sign = roi7d >= 0 ? '+' : '';
    return '$sign${roi7d.toStringAsFixed(1)}%';
  }

  String get formattedRoi30d {
    final sign = roi30d >= 0 ? '+' : '';
    return '$sign${roi30d.toStringAsFixed(1)}%';
  }

  String get formattedWinRate => '${winRate.toStringAsFixed(1)}%';

  String get formattedTotalValue {
    if (totalValue >= 1000000) {
      return '\$${(totalValue / 1000000).toStringAsFixed(1)}M';
    } else if (totalValue >= 1000) {
      return '\$${(totalValue / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${totalValue.toStringAsFixed(2)}';
    }
  }
}