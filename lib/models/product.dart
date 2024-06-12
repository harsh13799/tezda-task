class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String category;
  final Map<String, dynamic> rating;
  final String description;
  bool? isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.category,
      required this.rating,
      this.isFavorite});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'],
      price: json['price'].toDouble(),
      imageUrl: json['image'],
      description: json['description'],
      category: json['category'],
      rating: json['rating'],
      isFavorite: json['isFavorite'],
    );
  }
}
