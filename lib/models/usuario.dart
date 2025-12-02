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