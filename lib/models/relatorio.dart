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