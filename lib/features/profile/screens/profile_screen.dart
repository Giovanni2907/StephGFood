import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/core/theme/providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 16),
          const Center(child: Text("Stephanie Giovanni", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          
          const SizedBox(height: 32),
          
          // Section Informations
          const Text("Informations", style: TextStyle(fontWeight: FontWeight.bold)),
          const ListTile(leading: Icon(Icons.email), title: Text("stephanie@example.com")),
          
          const Divider(),
          
          // Section Adresse
          const Text("Adresse de livraison", style: TextStyle(fontWeight: FontWeight.bold)),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text("123 Rue de l'Informatique, Antananarivo"),
            subtitle: Text("Appartement 4B"),
          ),
          
          const Divider(),
          
          // Section Paramètres
          const Text("Apparence", style: TextStyle(fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text("Mode Sombre"),
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            value: isDarkMode,
            onChanged: (bool value) {
              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
              ref.read(themeNotifierProvider.notifier).state = 
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
    );
  }
}