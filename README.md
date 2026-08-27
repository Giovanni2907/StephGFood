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

### Flux d'exécution d'une commande :
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

### Lancer l'application

``` bash
flutter run
```