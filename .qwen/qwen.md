# Reservation Kite — Contexte Projet & Instructions Agent

## 1. VISION DU PRODUIT
Application Flutter de gestion complète pour école de Kite Surf : réservations, abonnements, suivi pédagogique, gestion dynamique du Staff et des Horaires.

**Utilisateurs cibles :**
- **Élève** : Réserve, choisit son moniteur, consulte ses crédits et sa progression.
- **Moniteur** : Gère son profil (bio, photo, spécialités) et ses disponibilités.
- **Administrateur** : Pilote l'école via un Panneau de Contrôle (Horaires, Staff, Finances, Validations).

---

## 2. ARCHITECTURE TECHNIQUE

### Stack
- **Flutter/Dart**
- **Firebase** : Firestore, Auth, App Check (obligatoire)
- **Riverpod** : State management avec générateurs (`@riverpod`)
- **Freezed** : Modèles immuables
- **Clean Architecture** : Séparation stricte `data` / `domain` / `presentation`

### Structure
```
lib/
├── data/           # Repositories Firestore, providers
├── domain/         # Modèles, interfaces repositories
└── presentation/   # UI, screens, widgets, notifiers
```

### Conventions de Code
- Fichiers générés : `.g.dart` (riverpod_generator)
- `FieldValue.serverTimestamp()` obligatoire pour les timestamps Firestore
- **`DateTime.now()` INTERDIT** pour Firestore
- Toute requête Firestore doit avoir un `.limit()`
- `if (!mounted)` obligatoire après `await` utilisant `BuildContext`
- Toute méthode de Provider/Notifier doit retourner un `AsyncValue` ou être wrappée dans un guard pour une gestion d'erreur uniforme
- **Thème dynamique** : L'application doit supporter les modes clair/sombre et la personnalisation des couleurs par l'admin
- **Couleurs centralisées** : Utiliser `Theme.of(context)` et `ColorScheme` (jamais de couleurs en dur dans les widgets)

---

## 3. SCHÉMA FIRESTORE (SOURCE DE VÉRITÉ)

### Collections Principales

| Collection | Description | Champs Clés |
|------------|-------------|-------------|
| `settings/school_config` | Configuration école | `opening_hours`, `days_off`, `max_students_per_instructor` |
| `users/{uid}` | Profils utilisateurs | `display_name`, `email`, `role`, `weight`, `wallet_balance`, `progress` |
| `staff/{uid}` | Fiches moniteurs | `bio`, `photo_url`, `specialties`, `certificates`, `is_active` |
| `availabilities/{id}` | Disponibilités staff | `instructor_id`, `date`, `slot`, `status`, `reason` |
| `sessions/{id}` | Cours de Kite | `date`, `slot`, `instructor_id`, `students`, `max_capacity`, `status` |
| `equipment/{id}` | Matériel école | `type`, `brand`, `model`, `size`, `status` |
| `transactions/{id}` | Historique paiements | `user_id`, `amount`, `type`, `payment_method` |
| `credit_packs/{id}` | Catalogue packs crédits | `name`, `credits`, `price`, `is_active` |
| `products/{id}` | Boutique (neuf/occasion) | `name`, `price`, `category`, `condition`, `stock_quantity` |

**Règles Firestore :**
- Champs système immuables (`created_at`)
- Index requis pour toute requête composite
- App Check obligatoire

---

## 4. RÈGLES MÉTIER (BUSINESS RULES)

### Réservations & Capacité
- **Capacité dynamique** : `Nb moniteurs actifs × Quota` (défaut : 4 élèves/moniteur)
- Un moniteur "indisponible" disparaît automatiquement des choix de réservation
- Slots : Matin (08h-12h) / Après-midi (13h-18h) — ajustables via Panneau Admin

### Paiements & Wallet
- Paiement **toujours physique**, validé manuellement par l'admin
- Saisie libre des crédits par l'admin après paiement
- Activation manuelle des abonnements

### Gestion RH (Staff)
- Indisponibilités : Grillage des slots par admin ou staff (validation admin requise)
- Fiche moniteur : Bio, photo, spécialités (Strapless, Freestyle, Foil), diplômes

### Suivi Pédagogique
- Carnet de progression avec checklist IKO et notes après chaque cours
- Poids de l'élève stocké pour sélection du matériel adapté (sécurité)

---

## 5. CONFORMITÉ RGPD (GDPR)

### Données Collectées
| Type | Finalité |
|------|----------|
| Identité (nom, email, photo) | Auth & Profil |
| Poids (kg) | Sélection matériel adapté (sécurité) |
| Données Staff (bio, diplômes) | Présentation commerciale |
| Suivi pédagogique | Continuité pédagogique |
| Transactions | Comptabilité et gestion wallet |

### Durée de Rétention
- **Comptes utilisateurs** : 3 ans d'inactivité ou demande de suppression
- **Données de progression** : 5 ans
- **Données de transaction** : 10 ans (obligation légale comptable)
- **Staff** : Suppression immédiate bio/photos en cas de départ, anonymisation des liens dans les sessions historiques

### Droits Utilisateurs
- **Droit d'accès** : Consultation via profil et carnet de progression
- **Droit à l'oubli** : Suppression irréversible des données d'identité, conservation anonymisée des sessions pour statistiques
- **Droit de rectification** : Modification libre du profil (poids, photo, nom)

### Sécurité
- Firebase Auth + App Check
- Règles Firestore : accès restreint (élève → ses données, staff → élèves de sa session, admin → tout)

---

## 5.5 SYSTÈME DE THÈME (FEATURE COMPLÈTE)

### Modes de Thème
- **Clair** : Thème par défaut avec couleurs claires
- **Sombre** : Thème optimisé pour une utilisation nocturne
- **Système** : Suit le thème du device (iOS/Android)

### Personnalisation Admin
- **Couleur primaire** : Couleur principale de la marque
- **Couleur secondaire** : Couleur d'accentuation
- **Couleur d'accent** : Couleur pour les éléments importants
- **5 thèmes prédéfinis** : Kitesurf (défaut), Sunset, Ocean, Tropical, Midnight
- **Personnalisation complète** : Color picker pour chaque couleur

### Architecture
- **Modèle** : `AppThemeSettings` (Freezed) avec themeMode, primaryColor, secondaryColor, accentColor
- **Provider** : `themeNotifierProvider` (StateNotifier) pour gérer l'état du thème
- **Persistance** : SharedPreferences pour sauvegarder les préférences
- **Application** : `MaterialApp.themeMode`, `theme`, `darkTheme`

### Règles d'Implémentation
- **Jamais de couleurs en dur** : Toujours utiliser `Theme.of(context).colorScheme.*`
- **Migration progressive** : Remplacer toutes les couleurs en dur par des références au thème
- **Contraste accessible** : Respecter WCAG AA (ratio 4.5:1 minimum)
- **Animation fluide** : Transition de 300ms lors du changement de thème

### Références
- Voir `FEATURE_THEME_SYSTEM.md` pour les spécifications complètes (8 phases, 21 tâches)

---

## 6. INSTRUCTIONS POUR L'AGENT (RÈGLES NON-NÉGOCIABLES)

### Avant Toute Modification
1. **Analyser le code existant** avant toute modification non triviale
2. **Vérifier `firestore_schema.md`** comme source de vérité pour toute structure de données
3. Travailler par **Todo List interactive** pour les tâches complexes

### Contraintes de Développement
- **Zéro théorie**, fournir **uniquement des diffs** (jamais de fichiers complets)
- **Aucun effet de bord** sans validation explicite (écriture, suppression, envoi, mutation)
- **Aucune écriture directe Firestore** pour les données critiques → passer par Cloud Function
- **Pas de retry automatique** sur les écritures

### Operations Git
- **Jamais d'initiative git** (add, commit, push, restore, etc.) sans instruction explicite de l'utilisateur
- L'utilisateur gère lui-même les commits et l'envoi vers le dépôt distant

### Internationalisation (i18n)
- **Toujours utiliser `AppLocalizations`** pour les textes affichés à l'utilisateur (jamais de texte en dur)
- Les nouvelles chaînes de caractères doivent être ajoutées dans **tous les fichiers `.arb`** (`app_fr.arb`, `app_en.arb`, `app_es.arb`, `app_pt.arb`, `app_zh.arb`)
- Le français (`app_fr.arb`) sert de template de référence
- Après ajout de traductions : exécuter `flutter gen-l10n` pour générer le code
- Vérifier que les textes dynamiques utilisent les placeholders : `"welcomeMessage": "Bonjour, {name}"` avec `@welcomeMessage` définissant les paramètres

### Qualité & Validation
- Si `flutter analyze`, un test ou une règle échoue : **STOP**, expliquer le problème, ne pas corriger en boucle
- Toute exception doit être **justifiée, validée, explicitement mentionnée**
- Répondre en **Français**

### Revue d'Impact (Obligatoire pour Firestore/Auth/Cloud Functions)
Préciser pour toute modification :
- **Impact coût** (requêtes Firestore, lectures/écritures)
- **Impact sécurité** (règles Firestore, accès données)
- **Impact UX** (messages d'erreur clairs, génériques, jamais techniques)

### Protocole de Validation
1. **Vérification Statique** : `flutter analyze` — corriger warnings (`prefer_const_constructors`, `use_build_context_synchronously`)
2. **Vérification d'Architecture** : Si modèle/Provider modifié → `dart run build_runner build --delete-conflicting-outputs`
3. **Contrôle Firebase** : Valider la présence du `.limit()` et l'existence des champs dans `firestore_schema.md`
4. **Audit de Performance** : Aucun widget > 100 lignes (extraire sous-widgets si nécessaire)

---

## 7. COMMANDES UTILES

```bash
# Build runner pour code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Analyse statique
flutter analyze

# Tests
flutter test

# Run avec device
flutter run

# Clean build
flutter clean && flutter pub get
```

---

## 8. CONTACT & RESPONSABLE
- **Responsable du traitement** : Administrateur de l'école (contact via l'application)
- **Dépôt distant** : https://github.com/mckarot/reservation_kite
