class Camp {
  final String about;
  final String category;
  final String id;
  final String image;
  final String level;
  final String name;
  final num price;
  final num rating;
  final String release;
  Camp({
    required this.about,
    required this.category,
    required this.id,
    required this.image,
    required this.level,
    required this.name,
    required this.price,
    required this.rating,
    required this.release,
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Camp(
      about: json['about'] ?? "",
      category: json['category'] ?? "",
      id: json['id'] ?? "",
      image: json['image'] ?? "",
      level: json['level'] ?? "",
      name: json['name'] ?? "",
      price: json['price'] ?? 0,
      rating: json['rating'] ?? 0,
      release: json['release'] ?? "",
    );
  }

  static Camp get empty => Camp(
      about: "",
      category: "",
      id: "",
      image: "",
      level: "",
      name: "",
      price: 0,
      rating: 0,
      release: "");
}
