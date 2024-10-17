import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dog_provider.dart';
import '../providers/theme_provider.dart';
import 'dart:math';

class SelectedBreedsPage extends ConsumerWidget {
  final List<String> selectedBreeds;

  const SelectedBreedsPage({Key? key, required this.selectedBreeds}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final darkBrown = ref.watch(darkBrownColorProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Your Selected Breeds',
                style: theme.textTheme.headlineLarge?.copyWith(color: Colors.brown[900]),
              ),
              const SizedBox(height: 10),
              Text(
                'Enjoy your paw-some choices!',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedBreeds.length,
                  itemBuilder: (context, index) {
                    final breed = selectedBreeds[index];
                    return BreedSection(breed: breed);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Transform.rotate(
            angle: -1.5708, // -90 degrees in radians
            child: Icon(
              Icons.pets,
              size: 40,
              color: darkBrown,
            ),
          ),
        ),
      ),
    );
  }
}

class BreedSection extends ConsumerWidget {
  final String breed;

  const BreedSection({Key? key, required this.breed}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkBrown = ref.watch(darkBrownColorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            breed.capitalize(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: BreedImageRow(breed: breed),
        ),
      ],
    );
  }
}

class BreedImageRow extends ConsumerWidget {
  final String breed;

  const BreedImageRow({Key? key, required this.breed}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: List.generate(5, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: FlashingDogImage(breed: breed, index: index),
          ),
        );
      }),
    );
  }
}

class FlashingDogImage extends ConsumerStatefulWidget {
  final String breed;
  final int index;

  const FlashingDogImage({Key? key, required this.breed, required this.index}) : super(key: key);

  @override
  _FlashingDogImageState createState() => _FlashingDogImageState();
}

class _FlashingDogImageState extends ConsumerState<FlashingDogImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _random = Random();
  String? _currentImageUrl;
  String? _nextImageUrl;
  Timer? _changeImageTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2 + _random.nextInt(3)),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
    _fetchNewImage();

    // Set up a timer to change the image every 5-10 seconds
    _changeImageTimer = Timer.periodic(
      Duration(seconds: 5 + _random.nextInt(6)),
          (_) => _changeImage(),
    );
  }

  void _fetchNewImage() {
    ref.read(dogApiServiceProvider).getRandomImageByBreed(widget.breed).then((imageUrl) {
      if (mounted) {
        setState(() {
          _nextImageUrl = imageUrl;
          if (_currentImageUrl == null) {
            _currentImageUrl = _nextImageUrl;
          }
        });
      }
    });
  }

  void _changeImage() {
    setState(() {
      _currentImageUrl = _nextImageUrl;
    });
    _fetchNewImage();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _changeImage,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_currentImageUrl != null)
                AnimatedOpacity(
                  opacity: _currentImageUrl == _nextImageUrl ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Image.network(
                    _currentImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              if (_nextImageUrl != null)
                AnimatedOpacity(
                  opacity: _currentImageUrl == _nextImageUrl ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 500),
                  child: Image.network(
                    _nextImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              if (_currentImageUrl == null && _nextImageUrl == null)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _changeImageTimer?.cancel();
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}