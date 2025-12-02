import 'exercicio.dart';

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