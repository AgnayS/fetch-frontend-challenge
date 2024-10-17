class Dog {
  final String breed;
  final List<String> subBreeds;
  final List<String> images;

  Dog({required this.breed, required this.subBreeds, required this.images});

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      breed: json['breed'] as String,
      subBreeds: List<String>.from(json['subBreeds'] as List),
      images: List<String>.from(json['images'] as List),
    );
  }
}