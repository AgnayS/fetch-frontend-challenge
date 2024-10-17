import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dog_provider.dart';
import '../providers/theme_provider.dart';

class BreedBubble extends ConsumerWidget {
  final String breed;
  final bool isSelected;
  final VoidCallback onTap;
  final String? imageUrl;

  const BreedBubble({
    Key? key,
    required this.breed,
    required this.isSelected,
    required this.onTap,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkBrown = ref.watch(darkBrownColorProvider);
    final randomImage = imageUrl != null
        ? AsyncValue.data(imageUrl!)
        : ref.watch(randomImageByBreedProvider(breed));

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: darkBrown, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: randomImage.when(
                      data: (imageUrl) => FlashingDogImage(imageUrl: imageUrl),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Icon(Icons.error),
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: darkBrown.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            breed.capitalize(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.brown[900],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class FlashingDogImage extends StatefulWidget {
  final String imageUrl;

  const FlashingDogImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _FlashingDogImageState createState() => _FlashingDogImageState();
}

class _FlashingDogImageState extends State<FlashingDogImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2 + (widget.imageUrl.hashCode % 3)),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}