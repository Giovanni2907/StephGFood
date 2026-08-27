import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/commande_provider.dart';
import '../widget/commande_card.dart';

class CommandeScreen extends ConsumerWidget {
  const CommandeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute dynamique des commandes actives et de l'historique
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
            activeCommande.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.shoppingBag, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Aucune commande en cours pour le moment.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activeCommande.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: CommandeCard(order: activeCommande[index]),
                    ),
                  ),

            // Onglet 2 : Historique des commandes
            pastCommande.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.history, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Votre historique de commandes est vide.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pastCommande.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: CommandeCard(order: pastCommande[index]),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}