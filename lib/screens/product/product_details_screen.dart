import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopharbor/models/cart_model.dart';
import 'package:laptopharbor/models/product_model.dart';
import 'package:laptopharbor/providers/cart_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel? product;
  final String productId;

  const ProductDetailsScreen({
    super.key,
    this.product,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  bool _isAddingToCart = false;

  Future<void> _addToCart(ProductModel product) async {
    setState(() => _isAddingToCart = true);
    try {
      final cartItem = CartItem(
        productId: product.id,
        productName: product.name,
        productImage: product.images.first,
        price: product.price,
        quantity: 1,
      );
      await ref.read(cartProvider.notifier).addItem(cartItem);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to Cart')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If product is passed in extra, use it. Otherwise, we would fetch it (logic to be added if needed, for now assuming it's passed or handled upstream)
    // For robustness, if product is null, we should show loading or fetch. 
    // In this MVP, we assume it's passed via extra or we handle loading.
    final product = widget.product; 

    if (product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Gallery
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 300.0,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                        items: product.images.map((img) {
                          return Builder(
                            builder: (BuildContext context) {
                              return CachedNetworkImage(
                                imageUrl: img,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                placeholder: (context, url) => Container(color: Colors.grey[100]),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      if (product.images.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: product.images.asMap().entries.map((entry) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).primaryColor)
                                      .withValues(alpha: _currentImageIndex == entry.key ? 0.9 : 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: product.rating,
                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 20.0,
                            ),
                            const SizedBox(width: 8),
                            Text('${product.rating} (${product.reviewCount} Reviews)',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (product.discountPrice != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  '\$${product.discountPrice}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Description', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
                        
                        const SizedBox(height: 24),
                        Text('Specifications', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...product.specs.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text(e.key, style: const TextStyle(color: Colors.grey))),
                              Expanded(flex: 2, child: Text(e.value.toString(), style: const TextStyle(fontWeight: FontWeight.w500))),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), // Specs spacing
                ],
              ),
            ),
          ),
          
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _isAddingToCart ? null : () => _addToCart(product),
                child: _isAddingToCart
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add to Cart'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
