// models/exercicio_concluido.dart

class ExercicioConcluido {
  final int id;
  final int exercicioId;
  final String exercicioNome;
  final int? duracaoMinutos;
  final DateTime dataHora;
  final int? intensidadeDor;
  final String? observacoes;

  ExercicioConcluido({
    required this.id,
    required this.exercicioId,
    required this.exercicioNome,
    this.duracaoMinutos,
    required this.dataHora,
    this.intensidadeDor,
    this.observacoes,
  });

  factory ExercicioConcluido.fromJson(Map<String, dynamic> json) {
    return ExercicioConcluido(
      id: json['id'] ?? 0,
      exercicioId: json['exercicio_id'] ?? 0,
      exercicioNome: json['exercicio_nome'] ?? json['nome'] ?? 'Exercício',
      duracaoMinutos: json['duracao_minutos'],
      dataHora: DateTime.parse(json['data_hora']),
      intensidadeDor: json['intensidade_dor'],
      observacoes: json['observacoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercicio_id': exercicioId,
      'exercicio_nome': exercicioNome,
      'duracao_minutos': duracaoMinutos,
      'data_hora': dataHora.toIso8601String(),
      'intensidade_dor': intensidadeDor,
      'observacoes': observacoes,
    };
  }
}