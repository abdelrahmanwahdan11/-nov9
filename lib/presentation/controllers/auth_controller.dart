import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  AuthController() {
    passwordController.addListener(_onPasswordChanged);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscure = true;
  bool _rememberMe = false;
  double _strength = 0;

  bool get obscure => _obscure;
  bool get rememberMe => _rememberMe;
  double get strength => _strength;

  bool get hasMinLength => passwordController.text.trim().length >= 8;
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(passwordController.text);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(passwordController.text);
  bool get hasNumber => RegExp(r'[0-9]').hasMatch(passwordController.text);
  bool get hasSymbol => RegExp(r'[^A-Za-z0-9]').hasMatch(passwordController.text);

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email required';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      _updateStrength(0);
      return 'Password required';
    }
    final score = _calculateStrength(value);
    _updateStrength(score);
    if (score < 0.3) {
      return 'Weak password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onPasswordChanged() {
    final text = passwordController.text;
    if (text.isEmpty) {
      _updateStrength(0);
      return;
    }
    _updateStrength(_calculateStrength(text));
  }

  void _updateStrength(double value) {
    if ((_strength - value).abs() > 0.001) {
      _strength = value;
    }
    notifyListeners();
  }

  double _calculateStrength(String password) {
    var score = 0.0;
    if (password.length >= 8) score += 0.3;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.2;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score += 0.2;
    if (password.length >= 12) score += 0.1;
    return score.clamp(0, 1);
  }

  void disposeControllers() {
    passwordController.removeListener(_onPasswordChanged);
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
