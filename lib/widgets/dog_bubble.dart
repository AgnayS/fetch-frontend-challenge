import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dog_provider.dart';

class DogBubble extends ConsumerStatefulWidget {
  const DogBubble({Key? key}) : super(key: key);

  @override
  ConsumerState<DogBubble> createState() => _DogBubbleState();
}

class _DogBubbleState extends ConsumerState<DogBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3 + Random().nextInt(5)),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
    _fetchRandomImage();
  }

  void _fetchRandomImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final dogApiService = ref.read(dogApiServiceProvider);
      final newImageUrl = await dogApiService.getRandomImage();
      if (mounted) {
        setState(() {
          _imageUrl = newImageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _imageUrl != null
              ? Image.network(
            _imageUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          )
              : const Icon(Icons.error),
        ),
      ),
    );
  }
}