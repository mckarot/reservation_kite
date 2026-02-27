# Règles Agent Gemini pour le Projet Reservation Kite

## 1. VISION DU PRODUIT
Application complète de gestion pour écoles de Kite Surf : réservations, abonnements, suivi pédagogique, gestion dynamique du Staff et des Horaires.

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

---

## 3. INSTRUCTIONS POUR L'AGENT (RÈGLES NON-NÉGOCIABLES)

### Avant Toute Modification
1. **Analyser le code existant** avant toute modification non triviale.
2. **Vérifier `firestore_schema.md`** comme source de vérité pour toute structure de données.
3. Travailler par **Todo List interactive** pour les tâches complexes.

### Contraintes de Développement
- **Zéro théorie**, fournir **uniquement des diffs** (jamais de fichiers complets).
- **Aucun effet de bord** sans validation explicite (écriture, suppression, envoi, mutation).
- **Aucune écriture directe Firestore** pour les données critiques → passer par Cloud Function.
- **Pas de retry automatique** sur les écritures.

### Operations Git
- **Jamais d'initiative git** (add, commit, push, restore, etc.) sans instruction explicite de l'utilisateur.
- L'utilisateur gère lui-même les commits et l'envoi vers le dépôt distant.

### Internationalisation (i18n)
- **Toujours utiliser `AppLocalizations`** pour les textes affichés à l'utilisateur (jamais de texte en dur).
- Les nouvelles chaînes de caractères doivent être ajoutées dans **tous les fichiers `.arb`** (`app_fr.arb`, `app_en.arb`, `app_es.arb`, `app_pt.arb`, `app_zh.arb`).
- Le français (`app_fr.arb`) sert de template de référence.
- Après ajout de traductions : exécuter `flutter gen-l10n` pour générer le code.
- Vérifier que les textes dynamiques utilisent les placeholders : `"welcomeMessage": "Bonjour, {name}"` avec `@welcomeMessage` définissant les paramètres.

### Qualité & Validation
- Si `flutter analyze`, un test ou une règle échoue : **STOP**, expliquer le problème, ne pas corriger en boucle.
- Toute exception doit être **justifiée, validée, explicitement mentionnée**.
- Répondre en **Français**.

### Revue d'Impact (Obligatoire pour Firestore/Auth/Cloud Functions)
Préciser pour toute modification :
- **Impact coût** (requêtes Firestore, lectures/écritures).
- **Impact sécurité** (règles Firestore, accès données).
- **Impact UX** (messages d'erreur clairs, génériques, jamais techniques).

### Protocole de Validation
1. **Vérification Statique** : `flutter analyze` — corriger warnings (`prefer_const_constructors`, `use_build_context_synchronously`).
2. **Vérification d'Architecture** : Si modèle/Provider modifié → `dart run build_runner build --delete-conflicting-outputs`.
3. **Contrôle Firebase** : Valider la présence du `.limit()` et l'existence des champs dans `firestore_schema.md`.
4. **Audit de Performance** : Aucun widget > 100 lignes (extraire sous-widgets si nécessaire).

---

## 4. COMMANDES UTILES

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
