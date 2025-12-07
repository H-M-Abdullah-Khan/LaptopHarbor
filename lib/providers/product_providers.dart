import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopharbor/models/product_model.dart';
import 'package:laptopharbor/models/category_model.dart';
import 'package:laptopharbor/models/brand_model.dart';
import 'package:laptopharbor/services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

// Products Stream
final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(firestoreServiceProvider).collectionStream(
    path: 'products',
    builder: (data, id) => ProductModel.fromMap(data, id),
  );
});

// Featured Products
final featuredProductsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(productsStreamProvider).value ?? [];
  return products.where((p) => p.isFeatured).toList();
});

// Categories Stream
final categoriesStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  return ref.watch(firestoreServiceProvider).collectionStream(
    path: 'categories',
    builder: (data, id) => CategoryModel.fromMap(data, id),
  );
});

// Brands Stream
final brandsStreamProvider = StreamProvider<List<BrandModel>>((ref) {
  return ref.watch(firestoreServiceProvider).collectionStream(
    path: 'brands',
    builder: (data, id) => BrandModel.fromMap(data, id),
  );
});

// Products by Category
final productsByCategoryProvider = Provider.family<List<ProductModel>, String>((ref, categoryId) {
  final products = ref.watch(productsStreamProvider).value ?? [];
  if (categoryId == 'All') return products;
  return products.where((p) => p.categoryId == categoryId).toList();
});
