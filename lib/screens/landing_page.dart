import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../widgets/dog_bubble.dart';
import 'breed_selection_page.dart';

class PawFetchLanding extends ConsumerWidget {
  const PawFetchLanding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final darkBrown = ref.watch(darkBrownColorProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const DogBubbleGrid(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'PawFetch!',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'The ultimate apocalypse of endless dog pics!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BreedSelectionPage()),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Transform.rotate(
                      angle: 1.5708,  // 90 degrees in radians
                      child: Icon(
                        Icons.pets,
                        size: 40,
                        color: darkBrown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DogBubbleGrid extends ConsumerWidget {
  const DogBubbleGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => const DogBubble(),
      itemCount: 36,
    );
  }
}