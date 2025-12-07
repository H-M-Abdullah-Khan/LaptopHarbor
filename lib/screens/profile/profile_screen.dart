import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laptopharbor/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            // Navigate to settings (not implemented yet)
          },
        )
      ]),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Not logged in'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
                  child: user.profileImage == null ? Text(user.name[0].toUpperCase(), style: const TextStyle(fontSize: 32)) : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
                    Text(user.email, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              if (user.role == 'admin')
                Card(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin Dashboard'),
                    onTap: () => context.push('/admin'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text('My Orders'),
                onTap: () {
                   // Navigate to orders
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Shipping Address'),
                onTap: () {},
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                leading: const Icon(Icons.payment_outlined),
                title: const Text('Payment Methods'),
                onTap: () {},
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {},
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await ref.read(authServiceProvider).signOut();
                  // Router will redirect to login automatically
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
