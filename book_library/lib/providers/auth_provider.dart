import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Authentication Provider - manages user authentication state with Firebase
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // State variables
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  String? _userName;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  String? get userId => _currentUser?.uid;
  String? get userEmail => _currentUser?.email;
  String? get userName => _userName ?? _currentUser?.displayName;

  /// Constructor - initialize with current auth state
  AuthProvider() {
    _init();
  }

  /// Initialize auth state listener
  void _init() {
    _authService.authStateChanges.listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userName = null;
      }
      notifyListeners();
    });
  }

  /// Load additional user data from Firestore
  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    try {
      final userData = await _authService.getUserData(_currentUser!.uid);
      if (userData != null) {
        _userName = userData['name'] as String?;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set error state
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.login(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Register new user
  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.register(email, password, name);
      _userName = name;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _currentUser = null;
      _userName = null;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Check current auth status
  Future<void> checkAuthStatus() async {
    _setLoading(true);

    try {
      _currentUser = _authService.currentUser;
      if (_currentUser != null) {
        await _loadUserData();
      }
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
