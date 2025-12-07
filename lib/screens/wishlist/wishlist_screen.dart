import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now showing dummy empty state or list if we had provider
    // Real implementation would fetch wishlist from User or dedicated collection
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Your wishlist is empty'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate home via shell
              },
              child: const Text('Explore Laptops'),
            ),
          ],
        ),
      ),
    );
  }
}
