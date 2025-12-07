import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:laptopharbor/providers/product_providers.dart';
import 'package:laptopharbor/widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredProductsAsync = ref.watch(productsStreamProvider); // Using all products stream for now as featured might be empty
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LaptopHarbor'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Banner/Carousel
          SliverToBoxAdapter(
            child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 16),
               child: CarouselSlider(
                 options: CarouselOptions(
                   height: 180.0,
                   autoPlay: true,
                   enlargeCenterPage: true,
                   aspectRatio: 16/9,
                   autoPlayCurve: Curves.fastOutSlowIn,
                   enableInfiniteScroll: true,
                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
                   viewportFraction: 0.8,
                 ),
                 items: [1, 2, 3].map((i) {
                   return Builder(
                     builder: (BuildContext context) {
                       return Container(
                         width: MediaQuery.of(context).size.width,
                         margin: const EdgeInsets.symmetric(horizontal: 5.0),
                         decoration: BoxDecoration(
                           color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                           borderRadius: BorderRadius.circular(16),
                         ),
                         child: Center(child: Text('Promo Banner $i', style: const TextStyle(fontSize: 16.0))),
                       );
                     },
                   );
                 }).toList(),
               ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: categoriesAsync.when(
                data: (categories) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: category.imageUrl != null ? NetworkImage(category.imageUrl!) : null,
                            child: category.imageUrl == null ? const Icon(Icons.category) : null,
                          ),
                          const SizedBox(height: 8),
                          Text(category.name, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => const SizedBox(),
              ),
            ),
          ),

          // Popular/Featured Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Laptops', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
            ),
          ),

          // Product Grid
          featuredProductsAsync.when(
            data: (products) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCard(product: products[index]);
                  },
                  childCount: products.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (e, st) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
