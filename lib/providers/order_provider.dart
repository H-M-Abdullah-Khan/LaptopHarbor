import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopharbor/models/order_model.dart';
import 'package:laptopharbor/providers/auth_provider.dart';
import 'package:laptopharbor/services/firestore_service.dart';
import 'package:laptopharbor/providers/product_providers.dart';

// Stream of orders for current user
final userOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  
  return ref.watch(firestoreServiceProvider).collectionStream(
    path: 'orders',
    queryBuilder: (query) => query.where('userId', isEqualTo: user.uid).orderBy('orderDate', descending: true),
    builder: (data, id) => OrderModel.fromMap(data, id),
  );
});

// Admin All Orders
final adminOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(firestoreServiceProvider).collectionStream(
    path: 'orders',
    queryBuilder: (query) => query.orderBy('orderDate', descending: true),
    builder: (data, id) => OrderModel.fromMap(data, id),
  );
});

class OrderController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  
  OrderController(this.ref) : super(const AsyncData(null));

  Future<void> placeOrder(OrderModel order) async {
    state = const AsyncLoading();
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      await firestoreService.addData(
        path: 'orders',
        data: order.toMap(),
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final orderControllerProvider = StateNotifierProvider<OrderController, AsyncValue<void>>((ref) => OrderController(ref));
