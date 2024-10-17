import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dog_api_service.dart';
import '../models/dog.dart';

final dogApiServiceProvider = Provider((ref) => DogApiService());

final allBreedsProvider = FutureProvider<List<String>>((ref) async {
  final dogApiService = ref.watch(dogApiServiceProvider);
  return dogApiService.getAllBreeds();
});

final breedDetailsProvider = FutureProvider.family<Dog, String>((ref, breed) async {
  final dogApiService = ref.watch(dogApiServiceProvider);
  return dogApiService.getBreedDetails(breed);
});

final randomImageProvider = FutureProvider<String>((ref) async {
  final dogApiService = ref.watch(dogApiServiceProvider);
  return dogApiService.getRandomImage();
});

final randomImagesProvider = FutureProvider.family<List<String>, int>((ref, count) async {
  final dogApiService = ref.watch(dogApiServiceProvider);
  return dogApiService.getRandomImages(count);
});

final randomImageByBreedProvider = FutureProvider.family<String, String>((ref, breed) async {
  final dogApiService = ref.watch(dogApiServiceProvider);
  return dogApiService.getRandomImageByBreed(breed);
});

final breedImagesProvider = FutureProvider.family<List<String>, String>((ref, breed) async {
  final dogApiService = ref.watch(dogApiServiceProvider);
  final breedDetails = await dogApiService.getBreedDetails(breed);
  return breedDetails.images;
});