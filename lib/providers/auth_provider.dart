import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laptopharbor/services/auth_service.dart';
import 'package:laptopharbor/models/user_model.dart';
import 'package:laptopharbor/services/firestore_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) => ref.watch(authServiceProvider).authStateChanges);

final currentUserDataProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return await ref.watch(authServiceProvider).getCurrentUserData();
  }
  return null;
});

final userRoleProvider = FutureProvider<String>((ref) async {
  final user = await ref.watch(currentUserDataProvider.future);
  return user?.role ?? 'user';
});
