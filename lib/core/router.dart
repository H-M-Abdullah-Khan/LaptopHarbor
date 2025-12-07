import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopharbor/providers/auth_provider.dart';
import 'package:laptopharbor/screens/auth/splash_screen.dart';
import 'package:laptopharbor/screens/auth/login_screen.dart';
import 'package:laptopharbor/screens/auth/signup_screen.dart';
import 'package:laptopharbor/screens/main_screen.dart';

import 'package:laptopharbor/screens/home/home_screen.dart';
import 'package:laptopharbor/screens/product/product_details_screen.dart';
import 'package:laptopharbor/screens/cart/cart_screen.dart';
import 'package:laptopharbor/models/product_model.dart';
import 'package:laptopharbor/screens/search/search_screen.dart';
import 'package:laptopharbor/screens/wishlist/wishlist_screen.dart';
import 'package:laptopharbor/screens/profile/profile_screen.dart';

import 'package:laptopharbor/screens/admin/admin_dashboard_screen.dart';
import 'package:laptopharbor/screens/admin/product_management_screen.dart';
import 'package:laptopharbor/screens/admin/add_product_screen.dart';
import 'package:laptopharbor/screens/admin/orders_management_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final hasError = authState.hasError;
      final isAuthenticated = authState.value != null;

      final isLogin = state.uri.toString() == '/login';
      final isSignup = state.uri.toString() == '/signup';
      final isSplash = state.uri.toString() == '/';
      final isAdmin = state.uri.toString().startsWith('/admin');

      if (isLoading || hasError) return null;

      if (isSplash && !isAuthenticated) return '/login'; 
      // Note: A real app might check persisted token or show onboarding here

      if (!isAuthenticated && !isLogin && !isSignup) return '/login';

      if (isAuthenticated && (isLogin || isSignup || isSplash)) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final product = state.extra as ProductModel?;
          return ProductDetailsScreen(productId: id, product: product);
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(path: 'products', builder: (context, state) => const ProductManagementScreen()),
          GoRoute(path: 'products/add', builder: (context, state) => const AddProductScreen()),
          GoRoute(path: 'orders', builder: (context, state) => const OrdersManagementScreen()),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wishlist',
                builder: (context, state) => const WishlistScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
