import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dog_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/breed_bubble.dart';
import 'selected_breeds_page.dart';

class BreedSelectionPage extends ConsumerStatefulWidget {
  const BreedSelectionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BreedSelectionPage> createState() => _BreedSelectionPageState();
}

class _BreedSelectionPageState extends ConsumerState<BreedSelectionPage> {
  String _searchQuery = '';
  Set<String> _selectedBreeds = {};

  @override
  Widget build(BuildContext context) {
    final allBreeds = ref.watch(allBreedsProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    final darkBrown = ref.watch(darkBrownColorProvider);
    final lightBrown = ref.watch(lightBrownColorProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'PawFetch!',
                style: theme.textTheme.headlineLarge?.copyWith(color: Colors.brown[900]),
              ),
              const SizedBox(height: 10),
              Text(
                'Select your favorite breeds',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search breeds...',
                    prefixIcon: Icon(Icons.search, color: darkBrown),
                    fillColor: lightBrown,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: allBreeds.when(
                  data: (breeds) {
                    final filteredBreeds = breeds
                        .where((breed) => breed.toLowerCase().contains(_searchQuery))
                        .toList();
                    return ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(scrollbars: false),
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredBreeds.length,
                        itemBuilder: (context, index) {
                          final breed = filteredBreeds[index];
                          return BreedBubble(
                            breed: breed,
                            isSelected: _selectedBreeds.contains(breed),
                            onTap: () {
                              setState(() {
                                if (_selectedBreeds.contains(breed)) {
                                  _selectedBreeds.remove(breed);
                                } else {
                                  _selectedBreeds.add(breed);
                                }
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: _selectedBreeds.isNotEmpty
            ? () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectedBreedsPage(selectedBreeds: _selectedBreeds.toList()),
            ),
          );
        }
            : null,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _selectedBreeds.isNotEmpty ? Colors.white : Colors.grey[400],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Transform.rotate(
            angle: 1.5708,  // 90 degrees in radians
            child: Icon(
              Icons.pets,
              size: 40,
              color: _selectedBreeds.isNotEmpty ? darkBrown : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}