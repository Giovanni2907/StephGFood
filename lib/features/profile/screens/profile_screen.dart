import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/core/theme/providers/theme_provider.dart';
import 'package:steph_g_food/features/profile/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditAddressDialog(
    BuildContext context,
    WidgetRef ref,
    String currentAddress,
    String currentComplement,
  ) {
    final addressController = TextEditingController(text: currentAddress);
    final complementController = TextEditingController(text: currentComplement);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifier l\'adresse'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: complementController,
              decoration: const InputDecoration(
                labelText: 'Complément (ex: Appt, Étage)',
                prefixIcon: Icon(Icons.info_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              addressController.dispose();
              complementController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userProvider.notifier).updateAddress(
                    addressController.text.trim(),
                    complementController.text.trim(),
                  );
              addressController.dispose();
              complementController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // En-tête Avatar & Nom dynamique
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section Informations
          Text(
            'Informations personnelles',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email'),
              subtitle: Text(user.email),
            ),
          ),

          const SizedBox(height: 16),

          // Section Adresse avec bouton d'édition
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Adresse de livraison',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => _showEditAddressDialog(
                  context,
                  ref,
                  user.address,
                  user.complement,
                ),
              ),
            ],
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(
                user.address.isEmpty ? 'Aucune adresse renseignée' : user.address,
              ),
              subtitle: user.complement.isNotEmpty
                  ? Text(user.complement)
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          // Section Préférences
          Text(
            'Préférences',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Mode Sombre'),
              secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              value: isDarkMode,
              onChanged: (bool value) {
                ref.read(themeNotifierProvider.notifier).toggleTheme(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}