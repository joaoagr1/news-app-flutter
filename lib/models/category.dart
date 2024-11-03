class Category {
  final int id;
  final String nome;
  final String description;

  Category({
    required this.id,
    required this.nome,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nome: json['nome'],
      description: json['description'],
    );
  }
}