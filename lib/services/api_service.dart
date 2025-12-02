import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://najusilveira.pythonanywhere.com';
  
  // Headers padrão
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ==================== AUTENTICAÇÃO ====================
  
  /// Registro de novo usuário
  Future<Map<String, dynamic>> register({
    required String nome,
    required String email,
    required String senha,
    required int idade,
    required String sexo,
    String? telefone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'idade': idade,
          'sexo': sexo,
          'telefone': telefone,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao registrar: $e');
    }
  }

  /// Login do usuário
  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  // ==================== PERFIL DO USUÁRIO ====================
  
  /// Buscar perfil do usuário
  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao buscar perfil: $e');
    }
  }

  /// Atualizar perfil
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    String? nome,
    int? idade,
    String? telefone,
    Map<String, dynamic>? preferencias,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          if (nome != null) 'nome': nome,
          if (idade != null) 'idade': idade,
          if (telefone != null) 'telefone': telefone,
          if (preferencias != null) 'preferencias': preferencias,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  // ==================== REGISTRO DE DOR ====================
  
  /// Registrar nova avaliação de dor
  Future<Map<String, dynamic>> registerPain({
    required String token,
    required int intensidade,
    required String localizacao,
    String? observacoes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/pain/register'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'intensidade': intensidade,
          'localizacao': localizacao,
          'observacoes': observacoes,
          // 'data_hora' não precisa ser enviado do Flutter, pois o Flask usa datetime.now()
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao registrar dor: $e');
    }
  }

  /// Buscar histórico de dor
  Future<List<dynamic>> getPainHistory({
    required String token,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      String url = '$baseUrl/api/pain/history';
      if (dataInicio != null && dataFim != null) {
        url += '?start=${dataInicio.toIso8601String()}&end=${dataFim.toIso8601String()}';
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );
      
      final result = _handleResponse(response);
      return result['data'] as List<dynamic>;
    } catch (e) {
      throw Exception('Erro ao buscar histórico: $e');
    }
  }

  // ==================== EXERCÍCIOS E PRÁTICAS ====================
  
  /// Buscar exercícios disponíveis 
  Future<List<dynamic>> getExercises(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/exercises'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );
      
      final result = _handleResponse(response);
      return result['data'] as List<dynamic>;
    } catch (e) {
      throw Exception('Erro ao buscar exercícios: $e');
    }
  }
  
  // Registrar conclusão de exercício (Rota /api/exercises/complete)
  /// Registra um exercício como concluído (usado para o Diário Pós/Progresso)
  Future<Map<String, dynamic>> completeExercise({
    required String token,
    required int exercicioId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/exercises/complete'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'exercicio_id': exercicioId,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao registrar conclusão do exercício: $e');
    }
  }

  // Buscar exercícios concluídos (Rota /api/exercises/completed)
  /// Busca a lista de exercícios que o usuário já concluiu.
  Future<List<dynamic>> getCompletedExercises(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/exercises/completed'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );
      
      final result = _handleResponse(response);
      // Retorna a lista de dados (que são exercícios feitos)
      return result['data'] as List<dynamic>; 
    } catch (e) {
      throw Exception('Erro ao buscar exercícios concluídos: $e');
    }
  }

  /// Registrar prática de exercício 
  Future<Map<String, dynamic>> logExercise({
    required String token,
    required int exercicioId,
    required int duracao,
    String? observacoes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/exercises/log'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'exercicio_id': exercicioId,
          'duracao': duracao,
          'observacoes': observacoes,
          // 'data_hora' não precisa ser enviado
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao registrar exercício: $e');
    }
  }

  /// Buscar histórico de exercícios
  Future<List<dynamic>> getExerciseHistory(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/exercises/history'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );
      
      final result = _handleResponse(response);
      return result['data'] as List<dynamic>;
    } catch (e) {
      throw Exception('Erro ao buscar histórico de exercícios: $e');
    }
  }

  // ==================== RELATÓRIOS ====================
  
  /// Gerar relatório de evolução
  Future<Map<String, dynamic>> getReport({
    required String token,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/reports?start=${dataInicio.toIso8601String()}&end=${dataFim.toIso8601String()}'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao gerar relatório: $e');
    }
  }
// ============================================
  // MÉTODOS DE EXERCÍCIOS
  // ============================================

  /// Registra um exercício como concluído
  Future<Map<String, dynamic>> registrarExercicioConcluido({
    required String token,
    required int exercicioId,
    int? intensidadeDor,
    String? observacoes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/exercicios/concluir'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'exercicio_id': exercicioId,
          'intensidade_dor': intensidadeDor,
          'observacoes': observacoes,
          'data_hora': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao registrar exercício: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Busca exercícios concluídos (histórico)
  Future<List<dynamic>> getExerciciosConcluidos({
    required String token,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      String url = '$baseUrl/exercicios/concluidos';
      
      // Adiciona filtros de data se fornecidos
      List<String> params = [];
      if (dataInicio != null) {
        params.add('data_inicio=${dataInicio.toIso8601String()}');
      }
      if (dataFim != null) {
        params.add('data_fim=${dataFim.toIso8601String()}');
      }
      
      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao buscar exercícios concluídos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Busca estatísticas de exercícios
  Future<Map<String, dynamic>> getEstatisticasExercicios({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercicios/estatisticas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao buscar estatísticas: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Remove um registro de exercício concluído
  Future<void> removerExercicioConcluido({
    required String token,
    required int registroId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/exercicios/concluidos/$registroId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao remover registro: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // ==================== NOTIFICAÇÕES ====================
  
  /// Configurar lembretes
  Future<Map<String, dynamic>> setReminder({
    required String token,
    required String tipo,
    required String horario,
    required bool ativo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/reminders'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'tipo': tipo,
          'horario': horario,
          'ativo': ativo,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao configurar lembrete: $e');
    }
  }

  // ==================== HELPER METHODS ====================
  
  /// Processar resposta da API
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Verifica se o corpo da resposta não está vazio antes de decodificar
      if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
      }
      return {}; // Retorna um mapa vazio se a resposta for 204 No Content
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado. Por favor, faça login novamente.');
    } else if (response.statusCode == 404) {
      throw Exception('Recurso não encontrado.');
    } else if (response.statusCode >= 500) {
      throw Exception('Erro no servidor. Tente novamente mais tarde.');
    } else {
      // Tenta decodificar o erro, se houver
      if (response.body.isNotEmpty) {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Erro desconhecido');
      }
      throw Exception('Erro na requisição com status: ${response.statusCode}');
    }
  }
}