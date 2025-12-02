import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Usuario? _usuario;
  String? _token;
  bool _isLoading = false;
  String? _error;

  Usuario? get usuario => _usuario;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _usuario != null;

  AuthProvider() {
    _loadStoredAuth();
  }

  /// Carregar autenticação armazenada
  Future<void> _loadStoredAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      
      if (_token != null) {
        final usuarioJson = prefs.getString('usuario');
        if (usuarioJson != null) {
          _usuario = Usuario.fromJson(
            Map<String, dynamic>.from(
              await Future.value(usuarioJson as FutureOr<Map>?)
            )
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao carregar autenticação: $e');
    }
  }

  /// Registrar novo usuário
  Future<bool> register({
    required String nome,
    required String email,
    required String senha,
    required int idade,
    required String sexo,
    String? telefone,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.register(
        nome: nome,
        email: email,
        senha: senha,
        idade: idade,
        sexo: sexo,
        telefone: telefone,
      );

      _token = response['token'];
      _usuario = Usuario.fromJson(response['usuario']);
      
      await _saveAuth();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Fazer login
  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.login(
        email: email,
        senha: senha,
      );

      _token = response['token'];
      _usuario = Usuario.fromJson(response['usuario']);
      
      await _saveAuth();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Atualizar perfil
  Future<bool> updateProfile({
    String? nome,
    int? idade,
    String? telefone,
    Map<String, dynamic>? preferencias,
  }) async {
    if (_token == null) return false;

    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.updateProfile(
        token: _token!,
        nome: nome,
        idade: idade,
        telefone: telefone,
        preferencias: preferencias,
      );

      _usuario = Usuario.fromJson(response['usuario']);
      await _saveAuth();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Fazer logout
  Future<void> logout() async {
    _token = null;
    _usuario = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuario');
    
    notifyListeners();
  }

  /// Salvar autenticação localmente
  Future<void> _saveAuth() async {
    if (_token == null || _usuario == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('usuario', _usuario!.toJson().toString());
  }

  /// Configurar estado de loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Limpar erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}