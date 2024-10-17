import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dog_provider.dart';
import '../widgets/dog_image_grid.dart';

class BreedDetailScreen extends ConsumerWidget {
  final String breed;

  const BreedDetailScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedDetails = ref.watch(breedDetailsProvider(breed));

    return Scaffold(
      appBar: AppBar(
        title: Text(breed.capitalize()),
      ),
      body: breedDetails.when(
        data: (dog) => Column(
          children: [
            if (dog.subBreeds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  children: dog.subBreeds
                      .map((subBreed) => Chip(label: Text(subBreed)))
                      .toList(),
                ),
              ),
            Expanded(
              child: DogImageGrid(images: dog.images),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(breedDetailsProvider(breed)),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}