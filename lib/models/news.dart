class News {
  final int id;
  final String titulo;
  final String conteudo;
  final String? dataPublicacao;
  final Categoria categoria;

  News({
    required this.id,
    required this.titulo,
    required this.conteudo,
    this.dataPublicacao,
    required this.categoria,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      titulo: json['titulo'],
      conteudo: json['conteudo'],
      dataPublicacao: json['dataPublicacao'],
      categoria: Categoria.fromJson(json['categoria']),
    );
  }
}

class Categoria {
  final int id;
  final String nome;
  final String description;

  Categoria({
    required this.id,
    required this.nome,
    required this.description,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'],
      description: json['description'],
    );
  }
}