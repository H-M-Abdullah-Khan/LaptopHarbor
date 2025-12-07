import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopharbor/models/cart_model.dart';
import 'package:laptopharbor/providers/auth_provider.dart';
import 'package:laptopharbor/services/firestore_service.dart';
import 'package:laptopharbor/providers/product_providers.dart';

// This is a simplified local cart provider that syncs to firestore if user is logged in
class CartNotifier extends StateNotifier<CartModel> {
  final Ref ref;
  
  CartNotifier(this.ref) : super(CartModel(userId: '', items: [])) {
    _init();
  }

  Future<void> _init() async {
    final user = ref.read(authStateProvider).value;
    if (user != null) {
      // Load cart from firestore
      final firestoreService = ref.read(firestoreServiceProvider);
      try {
        final doc = await firestoreService.documentStream(
          path: 'cart/${user.uid}',
          builder: (data, id) => CartModel.fromMap(data),
        ).first;
        state = doc;
      } catch (e) {
        // Cart might not exist yet
        state = CartModel(userId: user.uid, items: []);
      }
    }
  }

  Future<void> addItem(CartItem item) async {
    final items = [...state.items];
    final index = items.indexWhere((i) => i.productId == item.productId);
    
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + item.quantity);
    } else {
      items.add(item);
    }
    
    state = state.copyWith(items: items);
    await _syncToFirestore();
  }

  Future<void> removeItem(String productId) async {
    final items = state.items.where((i) => i.productId != productId).toList();
    state = state.copyWith(items: items);
    await _syncToFirestore();
  }
  
  Future<void> updateQuantity(String productId, int quantity) async {
    final items = [...state.items];
    final index = items.indexWhere((i) => i.productId == productId);
     if (index >= 0) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(quantity: quantity);
      }
      state = state.copyWith(items: items);
      await _syncToFirestore();
    }
  }

  Future<void> clear() async {
    state = state.copyWith(items: []);
    await _syncToFirestore();
  }

  Future<void> _syncToFirestore() async {
    final user = ref.read(authStateProvider).value;
    if (user != null) {
      final firestoreService = ref.read(firestoreServiceProvider);
      await firestoreService.setData(
        path: 'cart/${user.uid}',
        data: state.toMap(),
        merge: true,
      );
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartModel>((ref) => CartNotifier(ref));
