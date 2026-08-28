import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:steph_g_food/core/constants/app_colors.dart';
import 'package:steph_g_food/features/cart/widgets/cart_fab.dart';
import '../theme/providers/theme_provider.dart';
import '../../features/notifications/providers/notifications_provider.dart';

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadNotifs = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('SGF', style: TextStyle(fontWeight: FontWeight.values[7], fontSize: 15, color: AppColors.primary)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.sunMedium),  
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(false),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.bell),
                onPressed: () => context.push('/notifications'),
              ),
              if (unreadNotifs > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadNotifs',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: navigationShell,
      floatingActionButton: const CartFloatingActionButton(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(LucideIcons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(LucideIcons.search), label: 'Recherche'),
          NavigationDestination(icon: Icon(LucideIcons.shoppingCart), label: 'Commandes'),
          NavigationDestination(icon: Icon(LucideIcons.user), label: 'Profil'),
        ],
      ),
    );
  }
}