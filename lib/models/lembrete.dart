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