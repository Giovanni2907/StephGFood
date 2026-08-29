import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/core/theme/providers/theme_provider.dart';
import 'package:steph_g_food/features/profile/providers/user_provider.dart';
import 'package:steph_g_food/features/profile/screens/profile_screen.dart';

void main() {
  group('Tests Unitaires - UserNotifier & userProvider', () {
    test('L\'état initial de l\'utilisateur est correctement chargé', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final user = container.read(userProvider);

      expect(user.name, 'Stephanie Giovanni');
      expect(user.email, 'stephanie@example.com');
      expect(user.address, '123 Rue de l\'Informatique, Antananarivo');
      expect(user.complement, 'Appartement 4B');
    });

    test('updateName modifie le nom de l\'utilisateur', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(userProvider.notifier).updateName('Jean Dupont');

      final user = container.read(userProvider);
      expect(user.name, 'Jean Dupont');
      expect(user.email, 'stephanie@example.com');
    });

    test('updateEmail modifie l\'adresse email', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(userProvider.notifier).updateEmail('jean.dupont@test.com');

      final user = container.read(userProvider);
      expect(user.email, 'jean.dupont@test.com');
    });

    test('updateAddress modifie l\'adresse et le complément', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(userProvider.notifier)
          .updateAddress('456 Avenue Indépendance', 'Bâtiment C');

      final user = container.read(userProvider);
      expect(user.address, '456 Avenue Indépendance');
      expect(user.complement, 'Bâtiment C');
    });
  });

  group('Tests de Widget - ProfileScreen', () {
    testWidgets(
      'ProfileScreen affiche correctement les informations utilisateur initiales',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: ProfileScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Profil'), findsOneWidget);
        expect(find.text('Stephanie Giovanni'), findsOneWidget);
        expect(find.text('stephanie@example.com'), findsOneWidget);
        expect(
          find.text('123 Rue de l\'Informatique, Antananarivo'),
          findsOneWidget,
        );
        expect(find.text('Appartement 4B'), findsOneWidget);
        expect(find.text('Mode Sombre'), findsOneWidget);
      },
    );

    testWidgets('Modifier l\'adresse via le dialogue met à jour l\'affichage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Cliquer sur le bouton d'édition de l'adresse
      final editButton = find.byIcon(Icons.edit_outlined);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle(); // Attendre l'apparition complète du dialogue

      // 2. Vérifier la présence du dialogue
      expect(find.text('Modifier l\'adresse'), findsOneWidget);

      // 3. Remplir les champs du dialogue et notifier chaque champ avec pump()
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '789 Rue des Fleurs');
      await tester.pump();
      
      await tester.enterText(textFields.at(1), 'Étage 2');
      await tester.pump();

      // 4. Valider la modification
      final saveButton = find.text('Enregistrer');
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      
      // Laisser le dialogue se fermer et l'arbre de widgets se reconstruire entièrement
      await tester.pumpAndSettle();

      // 5. Vérifier que la nouvelle adresse est affichée dans l'écran de profil
      expect(find.text('789 Rue des Fleurs'), findsOneWidget);
      expect(find.text('Étage 2'), findsOneWidget);
    });

    testWidgets('Activer le Switch de Mode Sombre bascule le thème', (
      WidgetTester tester,
    ) async {
      // Instanciation propre du container avec nettoyage après test
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Vérifier le thème initial (Light)
      expect(container.read(themeNotifierProvider), ThemeMode.light);

      // Basculer le Switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      
      // Attendre la fin de l'animation d'ouverture/fermeture du Switch
      await tester.pumpAndSettle();

      // Vérifier que le thème est passé en Dark
      expect(container.read(themeNotifierProvider), ThemeMode.dark);
    });
  });
}