import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:steph_g_food/features/cart/screens/cart_screen.dart';
import 'package:steph_g_food/features/commande/screens/commande_screen.dart';
import 'package:steph_g_food/features/profile/screens/profile_screen.dart';
import 'main_shell.dart';
import 'package:steph_g_food/features/catalog/screens/home_screen.dart';
import 'package:steph_g_food/features/search/screens/search_screen.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/commande',
                name: 'commande',
                builder: (context, state) => const CommandeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const Center(child: Text('Écran Notifications')),
      ),
    ],
  );
}