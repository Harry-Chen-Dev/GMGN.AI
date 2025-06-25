import 'package:flutter/foundation.dart';
import '../../data/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  AuthTokens? _tokens;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  AuthTokens? get tokens => _tokens;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null && _tokens != null && !_tokens!.isExpired;

  // Mock login - In real app, this would call an API
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        throw Exception('请输入邮箱和密码');
      }

      if (!email.contains('@')) {
        throw Exception('请输入有效的邮箱地址');
      }

      if (password.length < 6) {
        throw Exception('密码至少需要6位字符');
      }

      // Mock successful login
      _currentUser = User(
        id: 'user_123',
        email: email,
        username: email.split('@').first,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginAt: DateTime.now(),
        settings: UserSettings(),
        connectedWallets: ['9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM'],
      );

      _tokens = AuthTokens(
        accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Mock register - In real app, this would call an API
  Future<bool> register(String email, String password, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        throw Exception('请填写所有必填字段');
      }

      if (!email.contains('@')) {
        throw Exception('请输入有效的邮箱地址');
      }

      if (password.length < 6) {
        throw Exception('密码至少需要6位字符');
      }

      if (password != confirmPassword) {
        throw Exception('两次输入的密码不一致');
      }

      // Mock successful registration and auto-login
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        username: email.split('@').first,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        settings: UserSettings(),
      );

      _tokens = AuthTokens(
        accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Mock forgot password
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (email.isEmpty || !email.contains('@')) {
        throw Exception('请输入有效的邮箱地址');
      }

      // Mock success
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _tokens = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    String? username,
    String? avatar,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = _currentUser!.copyWith(
        username: username ?? _currentUser!.username,
        avatar: avatar ?? _currentUser!.avatar,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update user settings
  Future<bool> updateSettings(UserSettings settings) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = _currentUser!.copyWith(settings: settings);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh token
  Future<bool> refreshToken() async {
    if (_tokens == null || _tokens!.refreshToken.isEmpty) {
      return false;
    }

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _tokens = AuthTokens(
        accessToken: 'new_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: _tokens!.refreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if token needs refresh
  bool shouldRefreshToken() {
    return _tokens != null && _tokens!.isExpiringSoon && !_tokens!.isExpired;
  }
}