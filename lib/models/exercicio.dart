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