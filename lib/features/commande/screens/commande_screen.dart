import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/commande_provider.dart';
import '../widget/commande_card.dart';

class CommandeScreen extends ConsumerWidget {
  const CommandeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCommande = ref.watch(activeCommandeProvider);
    final pastCommande = ref.watch(pastCommandeProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mes Commandes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'En cours'),
              Tab(text: 'Historique'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Onglet 1 : Commandes en cours
            _OrderList(
              orders: activeCommande,
              emptyIcon: LucideIcons.shoppingBag,
              emptyMessage: 'Aucune commande en cours pour le moment.',
              onRefresh: () async {
                // Rafraîchissement éventuel depuis l'API / State
                ref.invalidate(commandeProvider);
              },
            ),

            // Onglet 2 : Historique des commandes
            _OrderList(
              orders: pastCommande,
              emptyIcon: LucideIcons.history,
              emptyMessage: 'Votre historique de commandes est vide.',
              onRefresh: () async {
                ref.invalidate(commandeProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget interne réutilisable pour afficher une liste de commandes ou un état vide
class _OrderList extends StatelessWidget {
  final List<dynamic> orders;
  final IconData emptyIcon;
  final String emptyMessage;
  final Future<void> Function() onRefresh;

  const _OrderList({
    required this.orders,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      emptyIcon,
                      size: 56,
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      emptyMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return CommandeCard(order: orders[index]);
        },
      ),
    );
  }
}