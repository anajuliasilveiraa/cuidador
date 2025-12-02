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