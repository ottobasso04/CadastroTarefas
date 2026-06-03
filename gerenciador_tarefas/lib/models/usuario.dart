class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String ra;
  final String serie;

  Usuario({this.id, required this.nome, required this.email, required this.ra, required this.serie});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        nome: json['nome'] ?? '',
        email: json['email'] ?? '',
        ra: json['rA'] ?? json['ra'] ?? '',
        serie: json['serie'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nome': nome,
        'email': email,
        'rA': ra,
        'serie': serie,
      };
}