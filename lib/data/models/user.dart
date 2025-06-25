class User {
  final String id;
  final String email;
  final String? username;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserSettings settings;
  final List<String> connectedWallets;

  User({
    required this.id,
    required this.email,
    this.username,
    this.avatar,
    required this.createdAt,
    this.lastLoginAt,
    required this.settings,
    this.connectedWallets = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['created_at']),
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
      settings: UserSettings.fromJson(json['settings'] ?? {}),
      connectedWallets: List<String>.from(json['connected_wallets'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'settings': settings.toJson(),
      'connected_wallets': connectedWallets,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserSettings? settings,
    List<String>? connectedWallets,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      settings: settings ?? this.settings,
      connectedWallets: connectedWallets ?? this.connectedWallets,
    );
  }

  String get displayName => username ?? email.split('@').first;
}

class UserSettings {
  final String currency;
  final String language;
  final bool enableNotifications;
  final bool enablePriceAlerts;
  final bool enableCopyTradeAlerts;
  final bool darkMode;
  final double riskTolerance;

  UserSettings({
    this.currency = 'USD',
    this.language = 'en',
    this.enableNotifications = true,
    this.enablePriceAlerts = true,
    this.enableCopyTradeAlerts = true,
    this.darkMode = true,
    this.riskTolerance = 0.5,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      currency: json['currency'] ?? 'USD',
      language: json['language'] ?? 'en',
      enableNotifications: json['enable_notifications'] ?? true,
      enablePriceAlerts: json['enable_price_alerts'] ?? true,
      enableCopyTradeAlerts: json['enable_copy_trade_alerts'] ?? true,
      darkMode: json['dark_mode'] ?? true,
      riskTolerance: (json['risk_tolerance'] ?? 0.5).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'language': language,
      'enable_notifications': enableNotifications,
      'enable_price_alerts': enablePriceAlerts,
      'enable_copy_trade_alerts': enableCopyTradeAlerts,
      'dark_mode': darkMode,
      'risk_tolerance': riskTolerance,
    };
  }

  UserSettings copyWith({
    String? currency,
    String? language,
    bool? enableNotifications,
    bool? enablePriceAlerts,
    bool? enableCopyTradeAlerts,
    bool? darkMode,
    double? riskTolerance,
  }) {
    return UserSettings(
      currency: currency ?? this.currency,
      language: language ?? this.language,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enablePriceAlerts: enablePriceAlerts ?? this.enablePriceAlerts,
      enableCopyTradeAlerts: enableCopyTradeAlerts ?? this.enableCopyTradeAlerts,
      darkMode: darkMode ?? this.darkMode,
      riskTolerance: riskTolerance ?? this.riskTolerance,
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        json['expires_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.millisecondsSinceEpoch,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isExpiringSoon => 
      DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);
}