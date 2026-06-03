import 'usuario.dart';

class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final Usuario? administrador;
  final List<Usuario> membros;
  final bool status;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    this.administrador,
    this.membros = const [],
    this.status = false,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) => Tarefa(
        id: json['id'],
        titulo: json['titulo'] ?? '',
        descricao: json['descricao'] ?? '',
        administrador: json['administrador'] != null ? Usuario.fromJson(json['administrador']) : null,
        membros: (json['membros'] as List<dynamic>?)?.map((e) => Usuario.fromJson(e)).toList() ?? [],
        status: json['status'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'titulo': titulo,
        'descricao': descricao,
        if (administrador != null) 'administrador': {'id': administrador!.id},
        'membros': membros.map((m) => {'id': m.id}).toList(),
        'status': status,
      };

  Tarefa copyWith({
    int? id,
    String? titulo,
    String? descricao,
    Usuario? administrador,
    List<Usuario>? membros,
    bool? status,
  }) =>
      Tarefa(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descricao: descricao ?? this.descricao,
        administrador: administrador ?? this.administrador,
        membros: membros ?? this.membros,
        status: status ?? this.status,
      );
}