import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopharbor/core/router.dart';
import 'package:laptopharbor/core/theme.dart';
// import 'firebase_options.dart'; // Uncomment when firebase is actually configured via CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Using dummy options or waiting for user to run flutterfire configure)
  // For now, we will assume the user has run flutterfire configure or we wrap in try/catch to avoid crash if not configured 
  // but strictly we need it. 
  // Since we are generating code, we will add standard init.
  try {
     await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(const ProviderScope(child: LaptopHarborApp()));
}

class LaptopHarborApp extends ConsumerWidget {
  const LaptopHarborApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'LaptopHarbor',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
