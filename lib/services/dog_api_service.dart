import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog.dart';

class DogApiService {
  static const String baseUrl = 'https://dog.ceo/api';

  Future<List<String>> getAllBreeds() async {
    final response = await http.get(Uri.parse('$baseUrl/breeds/list/all'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['message'] as Map<String, dynamic>).keys.toList();
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  Future<Dog> getBreedDetails(String breed) async {
    final subBreedsResponse = await http.get(Uri.parse('$baseUrl/breed/$breed/list'));
    final imagesResponse = await http.get(Uri.parse('$baseUrl/breed/$breed/images'));

    if (subBreedsResponse.statusCode == 200 && imagesResponse.statusCode == 200) {
      final subBreedsData = json.decode(subBreedsResponse.body);
      final imagesData = json.decode(imagesResponse.body);

      return Dog(
        breed: breed,
        subBreeds: List<String>.from(subBreedsData['message']),
        images: List<String>.from(imagesData['message']),
      );
    } else {
      throw Exception('Failed to load breed details');
    }
  }

  Future<String> getRandomImage() async {
    final response = await http.get(Uri.parse('$baseUrl/breeds/image/random'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'] as String;
    } else {
      throw Exception('Failed to load random image');
    }
  }

  Future<List<String>> getRandomImages(int count) async {
    final response = await http.get(Uri.parse('$baseUrl/breeds/image/random/$count'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['message']);
    } else {
      throw Exception('Failed to load random images');
    }
  }

  Future<String> getRandomImageByBreed(String breed) async {
    final response = await http.get(Uri.parse('$baseUrl/breed/$breed/images/random'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'] as String;
    } else {
      throw Exception('Failed to load random image for breed');
    }
  }
}