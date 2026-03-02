# 🏗️ Reservation Kite — Guidelines & Contexte Projet

**Version :** 2.0 (Lead Architect)  
**Date :** 1 mars 2026  
**Statut :** En attente d'implémentation

---

## 1. VISION & PHILOSOPHIE

### Produit
Application Flutter de gestion complète pour école de Kite Surf : réservations, abonnements, suivi pédagogique, gestion dynamique du Staff et des Horaires.

**Utilisateurs cibles :**
| Rôle | Fonctionnalités |
|------|-----------------|
| **Élève** | Réserve, choisit son moniteur, consulte crédits et progression |
| **Moniteur** | Gère profil (bio, photo, spécialités) et disponibilités |
| **Administrateur** | Panneau de contrôle (Horaires, Staff, Finances, Validations) |

### Principes de Développement
| Principe | Exigence |
|----------|----------|
| **Zéro "Vibe Coding"** | Chaque ligne justifiée par contrainte technique/métier |
| **Architecture Immuable** | Données immuables + flux unidirectionnels (UDF) |
| **Performance Native** | Objectif 120 FPS constant. Tout jank = bug critique |
| **Clean Architecture+** | Séparation stricte data/domain/presentation |

---

## 2. ARCHITECTURE TECHNIQUE

### Stack
- **Flutter/Dart** (SDK ^3.10.7)
- **Firebase** : Firestore, Auth, App Check (obligatoire), Storage
- **Riverpod** : State management avec générateurs (`@riverpod`)
- **Freezed** : Modèles immuables
- **json_serializable** : Sérialisation JSON

### Structure des Couches (Strict)

```
lib/
├── data/                     # Data Layer
│   ├── providers/            # Riverpod providers (repositories)
│   ├── repositories/         # Implémentations Firestore
│   ├── sources/              # Data sources (Firestore, Local, API)
│   └── utils/                # Converters, constants
│
├── domain/                   # Domain Layer
│   ├── entities/             # Entités métier (immuables)
│   ├── models/               # Modèles de données (Freezed)
│   ├── repositories/         # Interfaces (contrats)
│   └── logic/                # Logique métier pure (Use Cases)
│
├── presentation/             # Presentation Layer
│   ├── screens/              # Écrans complets
│   ├── widgets/              # Widgets réutilisables
│   ├── providers/            # UI State (Notifiers)
│   └── theme/                # Configuration thème
│
└── services/                 # Services externes
```

### Flux de Données

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Domain    │ ←── │    Data     │ ←── │  Firebase   │
│  (Entities) │     │(Repositories)│    │ (Firestore) │
└──────┬──────┘     └─────────────┘     └─────────────┘
       │
       ↓
┌─────────────┐     ┌─────────────┐
│ Presentation│ ←── │    Riverpod │
│   (UI)      │     │  (Providers)│
└─────────────┘     └─────────────┘
```

---

## 3. INGÉNIERIE DE PERFORMANCE (LES 3 TREES)

### 3.1 Optimisation du Rendu

| Technique | Application | Exemple |
|-----------|-------------|---------|
| **Const Constructors** | Obligatoire sur sous-arbres statiques | `const SizedBox(height: 16)` |
| **Keys Explicites** | `ValueKey(id)` sur listes dynamiques | `key: ValueKey(user.id)` |
| **RepaintBoundary** | Autour animations/updates fréquentes | Weather card, progress indicators |
| **RelayoutBoundary** | Contraintes fixes pour isoler layout | `SizedBox`, `ConstrainedBox` |

### 3.2 Gestion Mémoire & Ressources

| Ressource | Règle | Exemple |
|-----------|-------|---------|
| **Controller** | `dispose()` obligatoire | `TextEditingController.dispose()` |
| **StreamSubscription** | `.cancel()` dans dispose | `_subscription?.cancel()` |
| **ScrollController** | `dispose()` obligatoire | `ScrollController.dispose()` |
| **Isolates** | `compute()` pour traitement >16ms | `await compute(heavyCalculation, data)` |

### 3.3 Checklist Performance (Pré-Commit)

- [ ] `const` sur tous les widgets statiques
- [ ] `key: ValueKey(id)` sur les listes dynamiques
- [ ] `RepaintBoundary` autour des animations/updates fréquentes
- [ ] `select()` pour les rebuilds ciblés
- [ ] `if (!context.mounted)` après chaque `await`
- [ ] Aucun `print()` en production
- [ ] Imports triés (dart: → flutter: → packages → app)

---

## 4. STATE MANAGEMENT (RIVERPOD)

### Règles Obligatoires

| Règle | Description |
|-------|-------------|
| **Riverpod Generator** | `@riverpod` obligatoire pour type safety |
| **Sélecteurs Fins** | `ref.watch(provider.select(...))` systématique |
| **AsyncValue Power** | Toute opération async → `AsyncValue` |
| **Immuabilité** | Modèles Freezed uniquement |

### Pattern Standard

```dart
// ✅ Bon pattern
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<List<User>> build() async {
    return ref.watch(userRepositoryProvider).getAllUsers();
  }

  Future<String?> updateUser(User user) async {
    final result = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).updateUser(user),
    );
    return result.fold(
      (data) => null,
      (error) => error.toString(),
    );
  }
}

// ✅ Usage ciblé dans l'UI
final primaryColor = ref.watch(themeNotifierProvider.select(
  (value) => value.value?.primary ?? AppThemeSettings.defaultPrimary,
));
```

---

## 5. STRATÉGIE DE RÉSILIENCE (ERROR HANDLING)

### Guard Clauses

```dart
// ✅ Après chaque await utilisant BuildContext
await someAsyncOperation();
if (!context.mounted) return;
ScaffoldMessenger.of(context).showSnackBar(...);
```

### Pattern Result

```dart
// ✅ Pour opérations critiques
Future<Result<User, Error>> getUser(String id) async {
  try {
    final user = await repository.getUser(id);
    return Result.success(user);
  } catch (e) {
    return Result.failure(Error.fromException(e));
  }
}
```

### Transactions Firestore

**Obligatoires pour :**
- Réservations (vérification capacité)
- Écritures dépendantes de lectures précédentes
- Opérations multi-documents

```dart
// ✅ Pattern transactionnel
await FirebaseFirestore.instance.runTransaction((transaction) async {
  final sessionDoc = await transaction.get(sessionRef);
  final currentCount = sessionDoc.data()?['students'].length ?? 0;
  final maxCapacity = sessionDoc.data()?['max_capacity'] ?? 0;
  
  if (currentCount >= maxCapacity) {
    throw Exception('Capacité maximale atteinte');
  }
  
  transaction.update(sessionRef, {
    'students': FieldValue.arrayUnion([studentId]),
  });
});
```

---

## 6. FIRESTORE & SÉCURITÉ

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
| `products/{id}` | Boutique | `name`, `price`, `category`, `condition`, `stock_quantity` |

### Règles d'Écriture

| Règle | Application |
|-------|-------------|
| **FieldValue.serverTimestamp()** | Obligatoire pour timestamps |
| **DateTime.now() INTERDIT** | Pour Firestore uniquement |
| **.limit() obligatoire** | Toute requête doit limiter |
| **Index composites** | Requis pour requêtes complexes |
| **App Check** | Enforcement total |

### Règles de Lecture

```dart
// ✅ Bon pattern
final reservations = await FirebaseFirestore.instance
    .collection('reservations')
    .where('date', isEqualTo: date)
    .limit(100)  // OBLIGATOIRE
    .get();
```

---

## 6.5 SÉCURITÉ DES CLÉS API & SECRETS ⚠️

### 🚫 Fichiers JAMAIS committés (CRITIQUE)

| Fichier | Raison | Solution |
|---------|--------|----------|
| `lib/firebase_options.dart` | Contient `apiKey`, `appId`, `messagingSenderId` | Généré automatiquement par `flutterfire configure` |
| `.env` | Contient secrets, tokens, clés API | Ajouter dans `.gitignore` |
| `google-services.json` | Credentials Android Firebase | Ne pas committer |
| `GoogleService-Info.plist` | Credentials iOS Firebase | Ne pas committer |
| `keystore.properties` | Clés de signature Android | Ne pas committer |

### ✅ Bonnes Pratiques

| Pratique | Description |
|----------|-------------|
| **`.gitignore` à jour** | Vérifier avant CHAQUE commit/push |
| **`git status` systématique** | Review des fichiers avant `git add` |
| **Variables d'environnement** | Utiliser `flutter_dotenv` pour les secrets |
| **Restrictions API Google Cloud** | Limiter par package, bundle ID, domaine |
| **Rotation des clés** | Régénérer si exposition suspectée |

### 🔐 Checklist Pré-Commit (Sécurité)

```bash
# 1. Vérifier les fichiers sensibles
git status

# 2. Vérifier .gitignore
cat .gitignore | grep -E "firebase_options|\.env|google-services|GoogleService"

# 3. Scanner les secrets (optionnel)
# trufflehog . --only-verified
# gitleaks detect
```

### 📦 `.gitignore` Minimal (Firebase/Secrets)

```gitignore
# Firebase secrets (CRITIQUE - NE JAMAIS COMMITTER)
lib/firebase_options.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist

# Environment variables
.env
.env.local
.env.*.local

# Keystore/Signing
*.keystore
*.jks
keystore.properties
```

### ⚠️ En Cas d'Exposition Accidentelle

1. **URGENCE :** Régénérer la clé API dans Google Cloud Console
2. **Nettoyer Git :** `git rm --cached <fichier>` + `git push --force`
3. **Restreindre :** Ajouter restrictions dans Google Cloud Console
4. **Auditer :** Vérifier logs Cloud Logging pour usage suspect

---

## 7. RÈGLES MÉTIER

### Réservations & Capacité

| Règle | Description |
|-------|-------------|
| **Capacité dynamique** | `Nb moniteurs actifs × Quota` (défaut : 4 élèves/moniteur) |
| **Moniteur indisponible** | Disparaît des choix de réservation |
| **Slots** | Matin (08h-12h) / Après-midi (13h-18h) — ajustable via Admin |
| **Transaction obligatoire** | Vérification capacité avant écriture |
| **Idempotence** | `request_id` unique pour éviter doublons réseau |

### Paiements & Wallet

| Règle | Description |
|-------|-------------|
| **Paiement physique** | Validé manuellement par admin |
| **Saisie crédits** | Libre par admin après paiement |
| **Activation abonnement** | Manuelle par admin |

### Gestion RH (Staff)

| Règle | Description |
|-------|-------------|
| **Indisponibilités** | Grillage slots par admin ou staff (validation admin requise) |
| **Fiche moniteur** | Bio, photo, spécialités (Strapless, Freestyle, Foil), diplômes |
| **Départ** | Suppression immédiate bio/photos, anonymisation sessions historiques |

### Suivi Pédagogique

| Règle | Description |
|-------|-------------|
| **Carnet de progression** | Checklist IKO + notes après chaque cours |
| **Poids élève** | Stocké pour sélection matériel adapté (sécurité) |
| **Durée rétention** | 5 ans pour données pédagogiques |

---

## 8. DESIGN SYSTEM & I18N

### Thème Dynamique

| Mode | Description |
|------|-------------|
| **Clair** | Thème par défaut avec couleurs claires |
| **Sombre** | Thème optimisé pour utilisation nocturne |
| **Système** | Suit le thème du device (iOS/Android) |

### Personnalisation Admin

- **Couleur primaire** : Couleur principale de la marque
- **Couleur secondaire** : Couleur d'accentuation
- **Couleur d'accent** : Éléments importants
- **5 thèmes prédéfinis** : Kitesurf, Sunset, Ocean, Tropical, Midnight

### Règles d'Implémentation

| Règle | Description |
|-------|-------------|
| **Jamais de couleurs en dur** | `Theme.of(context).colorScheme.*` uniquement |
| **Contraste accessible** | WCAG AA (ratio 4.5:1 minimum) |
| **Animation fluide** | Transition 300ms lors changement thème |

### Internationalisation (i18n)

| Règle | Description |
|-------|-------------|
| **AppLocalizations obligatoire** | Jamais de texte en dur |
| **5 langues** | FR (référence), EN, ES, PT, ZH |
| **Placeholders** | `"welcomeMessage": "Bonjour, {name}"` |
| **Génération** | `flutter gen-l10n` après ajout |

---

## 9. CONFORMITÉ RGPD (GDPR)

### Données Collectées

| Type | Finalité | Rétention |
|------|----------|-----------|
| Identité (nom, email, photo) | Auth & Profil | 3 ans inactivité |
| Poids (kg) | Sélection matériel (sécurité) | 5 ans |
| Données Staff (bio, diplômes) | Présentation commerciale | Immédiate (départ) |
| Suivi pédagogique | Continuité pédagogique | 5 ans |
| Transactions | Comptabilité | 10 ans (légal) |

### Droits Utilisateurs

| Droit | Application |
|-------|-------------|
| **Accès** | Consultation via profil et carnet |
| **Oubli** | Suppression irréversible identité, anonymisation sessions |
| **Rectification** | Modification libre (poids, photo, nom) |

### Sécurité

- Firebase Auth + App Check
- Règles Firestore : accès restreint (élève → ses données, staff → élèves de sa session, admin → tout)

---

## 10. INSTRUCTIONS POUR L'AGENT (NON-NÉGOCIABLE)

### Avant Toute Modification

1. **Analyser le code existant** avant modification non triviale
2. **Vérifier `firestore_schema.md`** comme source de vérité
3. **Travailler par Todo List** pour tâches complexes

### Protocole d'Instruction

| Étape | Exigence |
|-------|----------|
| **1. Analyse Impact** | Expliquer impact sur `RenderObject Tree` |
| **2. Mode Diff Uniquement** | Blocs de code précis uniquement |
| **3. Linter First** | Code conforme au linter le plus strict |
| **4. Refactoring Mentality** | Découpage si > 40 lignes |

### Contraintes de Développement

| Contrainte | Description |
|------------|-------------|
| **Zéro effet de bord** | Sans validation explicite (écriture, suppression, envoi) |
| **Pas d'écriture directe Firestore** | Données critiques → Cloud Function |
| **Pas de retry automatique** | Sur les écritures |
| **Jamais d'initiative git** | Sans instruction explicite |
| **🚫 Secrets JAMAIS dans Git** | `firebase_options.dart`, `.env`, clés API → `.gitignore` obligatoire |

### 🔐 Sécurité des Secrets (NON-NÉGOCIABLE)

| Règle | Action |
|-------|--------|
| **`firebase_options.dart`** | JAMAIS committer → généré par `flutterfire configure` |
| **`.gitignore` vérifié** | Avant CHAQUE `git add` |
| **Clés API exposées** | Alert immédiate + régénération + nettoyage historique |
| **Variables sensibles** | Utiliser `flutter_dotenv` + `.gitignore` |

### Qualité & Validation

| Règle | Action |
|-------|--------|
| **flutter analyze échoue** | STOP, expliquer le problème |
| **Test échoue** | STOP, expliquer l'échec |
| **Exception** | Doit être justifiée et explicitement mentionnée |

### Revue d'Impact (Firestore/Auth/Cloud Functions)

Préciser pour toute modification :
- **Impact coût** : Requêtes Firestore, lectures/écritures
- **Impact sécurité** : Règles Firestore, accès données
- **Impact UX** : Messages d'erreur clairs, génériques, jamais techniques

### Protocole de Validation

```bash
# 1. Vérification Statique
flutter analyze

# 2. Vérification d'Architecture (si modèle/Provider modifié)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Contrôle Firebase
# - Valider .limit()
# - Vérifier champs dans firestore_schema.md

# 4. Audit de Performance
# - Aucun widget > 100 lignes
# - Extraire sous-widgets si nécessaire
```

---

## 11. COMMANDES UTILES

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

# Génération i18n
flutter gen-l10n

# Formater le code
dart format lib/

# 🔐 Sécurité - Vérifier les secrets avant commit
git status  # Review fichiers avant git add
git rm --cached <fichier>  # Supprimer fichier de Git (garde local)
git log --all --full-history -- <fichier>  # Historique fichier
```

---

## 12. LIENS & RÉFÉRENCES

| Document | Description |
|----------|-------------|
| `firestore_schema.md` | Schéma Firestore (source de vérité) |
| `FEATURE_THEME_SYSTEM.md` | Spécifications du système de thème |
| `AUDIT_ACTION_PLAN.md` | Plan d'amélioration qualité |
| `TODO_LATER.md` | TODO pour plus tard |
| `COMPLIANCE_GDPR.md` | Conformité RGPD détaillée |
| `README.md` | Documentation générale |
| **Section 6.5** | 🔐 Sécurité des Clés API & Secrets |

---

## 13. CONTACT & DÉPÔT

| Information | Détail |
|-------------|--------|
| **Dépôt distant** | https://github.com/mckarot/reservation_kite |
| **Responsable traitement** | Administrateur de l'école (via application) |
| **Langue de réponse** | Français |

---

## 📊 STATUT D'IMPLÉMENTATION

| Section | Statut | Notes |
|---------|--------|-------|
| 1. Vision & Philosophie | ✅ En place | |
| 2. Architecture Technique | ✅ En place | Clean Architecture respectée |
| 3. Ingénierie Performance | 🟡 Partiel | Const et Keys à améliorer |
| 4. State Management | ✅ En place | Riverpod bien implémenté |
| 5. Résilience | ✅ En place | Guard clauses implémentés |
| 6. Firestore & Sécurité | ✅ En place | App Check activé |
| 6.5 Sécurité des Clés API & Secrets | ✅ En place | Section ajoutée |
| 7. Règles Métier | ✅ En place | Transactions à renforcer |
| 8. Design System & I18N | ✅ En place | Thème dynamique fonctionnel |
| 9. Conformité RGPD | ✅ En place | |
| 10. Instructions Agent | ✅ En place | |

---

**Dernière mise à jour :** 2 mars 2026
**Prochaine revue :** Après implémentation des corrections d'audit
