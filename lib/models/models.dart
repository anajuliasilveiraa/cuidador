// ==================== USUÁRIO ====================

class Usuario {
  final int id;
  final String nome;
  final String email;
  final int idade;
  final String sexo;
  final String? telefone;
  final Map<String, dynamic>? preferencias;
  final DateTime dataCadastro;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.idade,
    required this.sexo,
    this.telefone,
    this.preferencias,
    required this.dataCadastro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      idade: json['idade'],
      sexo: json['sexo'],
      telefone: json['telefone'],
      preferencias: json['preferencias'],
      dataCadastro: DateTime.parse(json['data_cadastro']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'idade': idade,
      'sexo': sexo,
      'telefone': telefone,
      'preferencias': preferencias,
      'data_cadastro': dataCadastro.toIso8601String(),
    };
  }
}

// ==================== REGISTRO DE DOR ====================

class RegistroDor {
  final int id;
  final int usuarioId;
  final int intensidade;
  final String localizacao;
  final String? observacoes;
  final DateTime dataHora;

  RegistroDor({
    required this.id,
    required this.usuarioId,
    required this.intensidade,
    required this.localizacao,
    this.observacoes,
    required this.dataHora,
  });

  factory RegistroDor.fromJson(Map<String, dynamic> json) {
    return RegistroDor(
      id: json['id'],
      usuarioId: json['usuario_id'],
      intensidade: json['intensidade'],
      localizacao: json['localizacao'],
      observacoes: json['observacoes'],
      dataHora: DateTime.parse(json['data_hora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'intensidade': intensidade,
      'localizacao': localizacao,
      'observacoes': observacoes,
      'data_hora': dataHora.toIso8601String(),
    };
  }

  String get descricaoIntensidade {
    if (intensidade == 0) return 'Sem dor';
    if (intensidade <= 2) return 'Dor Mínima';
    if (intensidade <= 4) return 'Dor Leve';
    if (intensidade <= 6) return 'Dor Moderada';
    if (intensidade <= 8) return 'Dor Intensa';
    return 'Dor Insuportável';
  }
}

// ==================== EXERCÍCIO ====================

class Exercicio {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final int duracaoMinutos;
  final String? videoUrl;
  final String? imagemUrl;
  final List<String> passos;
  final String? beneficios;
  final String? precaucoes;

  Exercicio({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.duracaoMinutos,
    this.videoUrl,
    this.imagemUrl,
    required this.passos,
    this.beneficios,
    this.precaucoes,
  });

  factory Exercicio.fromJson(Map<String, dynamic> json) {
    return Exercicio(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      categoria: json['categoria'],
      duracaoMinutos: json['duracao_minutos'],
      videoUrl: json['video_url'],
      imagemUrl: json['imagem_url'],
      passos: List<String>.from(json['passos'] ?? []),
      beneficios: json['beneficios'],
      precaucoes: json['precaucoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'duracao_minutos': duracaoMinutos,
      'video_url': videoUrl,
      'imagem_url': imagemUrl,
      'passos': passos,
      'beneficios': beneficios,
      'precaucoes': precaucoes,
    };
  }
}

// ==================== REGISTRO DE EXERCÍCIO ====================

class RegistroExercicio {
  final int id;
  final int usuarioId;
  final int exercicioId;
  final int duracao;
  final String? observacoes;
  final DateTime dataHora;
  final Exercicio? exercicio;

  RegistroExercicio({
    required this.id,
    required this.usuarioId,
    required this.exercicioId,
    required this.duracao,
    this.observacoes,
    required this.dataHora,
    this.exercicio,
  });

  factory RegistroExercicio.fromJson(Map<String, dynamic> json) {
    return RegistroExercicio(
      id: json['id'],
      usuarioId: json['usuario_id'],
      exercicioId: json['exercicio_id'],
      duracao: json['duracao'],
      observacoes: json['observacoes'],
      dataHora: DateTime.parse(json['data_hora']),
      exercicio: json['exercicio'] != null 
          ? Exercicio.fromJson(json['exercicio'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'exercicio_id': exercicioId,
      'duracao': duracao,
      'observacoes': observacoes,
      'data_hora': dataHora.toIso8601String(),
      if (exercicio != null) 'exercicio': exercicio!.toJson(),
    };
  }
}

// ==================== LEMBRETE ====================

class Lembrete {
  final int id;
  final int usuarioId;
  final String tipo;
  final String horario;
  final bool ativo;
  final Map<String, dynamic>? configuracoes;

  Lembrete({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.horario,
    required this.ativo,
    this.configuracoes,
  });

  factory Lembrete.fromJson(Map<String, dynamic> json) {
    return Lembrete(
      id: json['id'],
      usuarioId: json['usuario_id'],
      tipo: json['tipo'],
      horario: json['horario'],
      ativo: json['ativo'],
      configuracoes: json['configuracoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'tipo': tipo,
      'horario': horario,
      'ativo': ativo,
      'configuracoes': configuracoes,
    };
  }
}

// ==================== RELATÓRIO ====================

class Relatorio {
  final DateTime dataInicio;
  final DateTime dataFim;
  final double mediaDor;
  final int totalRegistros;
  final int totalExercicios;
  final Map<String, int> localizacoesMaisFrequentes;
  final List<Map<String, dynamic>> evolucaoDiaria;

  Relatorio({
    required this.dataInicio,
    required this.dataFim,
    required this.mediaDor,
    required this.totalRegistros,
    required this.totalExercicios,
    required this.localizacoesMaisFrequentes,
    required this.evolucaoDiaria,
  });

  factory Relatorio.fromJson(Map<String, dynamic> json) {
    return Relatorio(
      dataInicio: DateTime.parse(json['data_inicio']),
      dataFim: DateTime.parse(json['data_fim']),
      mediaDor: json['media_dor'].toDouble(),
      totalRegistros: json['total_registros'],
      totalExercicios: json['total_exercicios'],
      localizacoesMaisFrequentes: Map<String, int>.from(json['localizacoes_mais_frequentes']),
      evolucaoDiaria: List<Map<String, dynamic>>.from(json['evolucao_diaria']),
    );
  }
}