# StephGFood — Client Mobile (Flutter / Riverpod)

StephGFood est une application mobile cross-platform de commande de nourriture construite avec **Flutter** et **Riverpod**. Ce document fournit la documentation technique complète pour configurer l'environnement de développement, compiler le projet, comprendre la gestion d'état et maintenir l'architecture système.

---

## Spécifications & Stack Technique

- **Langage** : Dart `^3.0.0`
- **Framework** : Flutter SDK `^3.19.0`
- **Gestion d'État & DI** : `flutter_riverpod: ^2.5.1`
- **Notifications système** : `flutter_local_notifications: ^17.1.0`
- **UI & Système d'icônes** : `lucide_icons_flutter: ^0.1.0` / Material 3

---

## Architecture & Diagramme des Flux

L'application respecte une **Architecture par Fonctionnalité (Feature-First Layered Architecture)**. La logique métier est découplée de l'UI via le pattern `StateNotifier` et l'injection de dépendances réactive de Riverpod.

## Flux d'exécution d'une commande :
```text
[ CartScreen (UI) ]
       │
       ▼ (read cartNotifierProvider)
[ CartNotifier ] ──(Passe List<CartItem>)──► [ CommandeNotifier ]
                                                  │
                                                  ├─► Met à jour state (List<Commande>)
                                                  └─► Trigger NotificationService
                                                           │
                                                           ▼
                                                [ System Notification Engine ]
```

---

## Liste des Providers Riverpod

| Provider | Type | Description |
| :--- | :--- | :--- |
| **`themeNotifierProvider`** | `StateNotifierProvider<ThemeNotifier, ThemeMode>` | Gère le basculement dynamique du thème (Clair / Sombre) au sein de l'application. |
| **`productsListProvider`** | `FutureProvider<List<Product>>` | Charge la liste initiale des produits depuis la source de données (API ou mock repository). |
| **`userProvider`** | `StateNotifierProvider<UserNotifier, User>` | Gère l'état réactif des informations utilisateur (nom, email, adresse de livraison). |
| **`searchQueryProvider`** | `StateProvider<String>` | Stocke la requête de recherche saisie par l'utilisateur. |
| **`selectedCategoryProvider`** | `StateProvider<String?>` | Garde en mémoire le filtre de catégorie actuellement sélectionné. |
| **`filteredProductsProvider`** | `Provider<AsyncValue<List<Product>>>` | Calcule dynamiquement la liste filtrée et triée des produits selon les filtres de recherche et de catégorie. |
| **`favoritesNotifierProvider`** | `StateNotifierProvider<FavoritesNotifier, Set<String>>` | Gère l'ensemble des ID des produits favoris et leur persistance locale. |

---

## Modèle & Gestion du Thème

L'application prend en charge le changement de thème réactif via `ThemeNotifier` :

```dart
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
```

### Arborescence du projet 

lib/
├── main.dart                          # Entrypoint & ProviderScope & Async Services Init
├── core/                              # Noyau partagé & Services système
│   ├── services/
│   │   └── notification_service.dart  # Wrapper Singleton/Static pour flutter_local_notifications
│   └── theme/                         # Configuration ThemeData & charte graphique
└── features/                          # Modules applicatifs découplés
    ├── cart/                          # Gestion du panier
    │   ├── models/                    # CartItem data model
    │   ├── providers/                 # CartNotifier state management
    │   └── screens/                   # CartScreen View
    ├── commande/                      # Gestion du cycle de vie des commandes
    │   ├── models/                    # Commande, CommandeItem, CommandeStatus (Enum)
    │   ├── providers/                 # CommandeNotifier, activeCommandeProvider, pastCommandeProvider
    │   ├── screens/                   # CommandeScreen (DefaultTabController)
    │   └── widgets/                   # CommandeCard UI component
    └── product/                       # Catalogue & détails des produits

### Clonage et dépendances

``` bash
# 1. Cloner le repository
git clone [https://github.com/votre-user/steph_g_food.git](https://github.com/votre-user/steph_g_food.git)
cd steph_g_food

# 2. Récupérer les paquets Dart/Flutter
flutter pub get

```

### Structure des Tests

Les tests unitaires sur les recherches et filtrage sont situés dans `test/search/search_provider_test.dart` et couvrent trois grands axes :

1. **Filtres de Base** :
   * Renvoi exhaustif des produits par défaut (aucun filtre).
   * Filtrage textuel insensible à la casse.
   * Filtrage strict par catégorie sélectionnée.
   * Filtrage par plafond de prix.

2. **Options de Tri (`ProductSortOption`)** :
   * Tri par prix croissant (`priceAsc`).
   * Tri par prix décroissant (`priceDesc`).
   * Tri alphabétique par nom (`nameAsc`).

3. **Cas Limites (*Edge Cases*)** :
   * Comportement en cas de recherche sans résultat (liste vide `[]`).
   * Application combinée simultanée (Recherche + Catégorie + Prix max).
   * Prise en charge d'une liste initiale de produits vide.
   * Réinitialisation avec la catégorie `'Tous'`.

### Lancer l'application

``` bash
flutter run
```

### Exécution des tests 

``` bash
flutter test
```