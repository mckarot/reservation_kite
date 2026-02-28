# 🎯 GESTION DES CATÉGORIES D'ÉQUIPEMENT

**Document de suivi des fonctionnalités pour la gestion des catégories d'équipement**

**Créé le :** 2026-02-27
**Statut :** 🔴 À faire
**Priorité :** Moyenne
**Fichier concerné :** `lib/presentation/screens/equipment_admin_screen.dart`

---

## 📋 VUE D'ENSEMBLE

### Contexte

Actuellement, l'écran `EquipmentAdminScreen` permet de :
- ✅ Filtrer les équipements par type (kite, foil, board, etc.)
- ✅ Ajouter un nouvel équipement
- ✅ Modifier le statut d'un équipement (disponible, maintenance, endommagé)
- ✅ Supprimer un équipement

### Fonctionnalités manquantes

Les **types/catégories d'équipement** sont actuellement **en dur** dans le code :
```dart
enum EquipmentType { kite, foil, board, harness, wetsuit, accessories }
```

L'administrateur devrait pouvoir :
- ✏️ **Modifier** les noms des catégories
- ➕ **Ajouter** de nouvelles catégories
- ❌ **Supprimer** des catégories inutilisées
- 🔄 **Réorganiser** l'ordre d'affichage des catégories

---

## 🎯 OBJECTIFS

### Objectif principal

Permettre à l'administrateur de gérer dynamiquement les catégories d'équipement depuis l'interface, sans modification du code.

### Objectifs secondaires

- Stocker les catégories dans Firestore (au lieu d'un enum en dur)
- Permettre le réordonnancement par drag & drop
- Valider qu'une catégorie ne peut pas être supprimée si elle contient des équipements
- **Supprimé :** ~~Internationaliser les noms de catégories~~ (chaque admin utilise sa langue)

---

## 📊 ÉTAT ACTUEL

### Structure de données actuelle

```dart
// Dans lib/domain/models/equipment.dart
enum EquipmentType {
  kite,      // Index 0
  foil,      // Index 1
  board,     // Index 2
  harness,   // Index 3
  wetsuit,   // Index 4
  accessories // Index 5
}

class Equipment {
  final EquipmentType type; // ← Utilise l'enum
  // ...
}
```

### Problèmes identifiés

| Problème | Impact | Solution |
|----------|--------|----------|
| Types en dur dans le code | Nécessite un déploiement pour ajouter un type | Stocker dans Firestore |
| Ordre fixe (index enum) | Impossible de réorganiser | Ajouter un champ `order` |
| Noms en anglais uniquement | Affichage non localisé | **Un seul nom par catégorie (langue de l'admin)** |
| Pas de validation suppression | Risque de perdre des équipements | Vérifier avant suppression |

---

## 🏗️ ARCHITECTURE PROPOSÉE

### Nouvelle structure de données

```dart
// Dans lib/domain/models/equipment_category.dart
@freezed
class EquipmentCategory with _$EquipmentCategory {
  const factory EquipmentCategory({
    required String id,
    required String name, // ← Une seule langue (celle de l'admin)
    required int order, // Pour le tri
    required bool isActive, // Pour désactiver sans supprimer
    @Default([]) List<String> equipmentIds, // Équipements liés
  }) = _EquipmentCategory;
}
```

### Collection Firestore

```
/equipment_categories
  ├── /kite
  │     ├── name: "Kites" (ou "Kites" en FR, "Cometas" en ES...)
  │     ├── order: 1
  │     ├── isActive: true
  │     └── equipmentIds: ["eq1", "eq2", ...]
  ├── /foil
  ├── /board
  └── ...
```

**Note :** Le nom de la catégorie est dans la langue de l'admin qui l'a créée. Pas de traduction automatique.

---

## 📝 SPÉCIFICATIONS FONCTIONNELLES

### 4.1 Gestion des catégories

#### ➕ Ajouter une catégorie
- Bouton "+" dans la barre de filtres
- Formulaire avec :
  - Nom de la catégorie (obligatoire, dans la langue de l'admin)
- Validation : le nom ne doit pas exister déjà
- La nouvelle catégorie est ajoutée à la fin de la liste

#### ✏️ Modifier une catégorie
- Appui long sur un filtre → Menu contextuel
- Options : "Modifier", "Supprimer", "Déplacer"
- Modification : même formulaire que l'ajout
- Les équipements existants sont automatiquement mis à jour

#### ❌ Supprimer une catégorie
- Vérifier qu'aucun équipement n'est associé
- Si équipements présents :
  - Soit proposer de les déplacer vers une autre catégorie
  - Soit afficher une erreur bloquante
- Confirmation requise avant suppression

#### 🔄 Réorganiser les catégories
- Drag & drop des filtres
- Mise à jour du champ `order` dans Firestore
- Animation fluide pendant le déplacement

---

### 4.2 Interface utilisateur

#### Écran actuel (à conserver)
```
┌─────────────────────────────────────────┐
│  Gestion du Matériel           [+]     │
├─────────────────────────────────────────┤
│  [Kites] [Foil] [Boards] [Harnais] ... │ ← Filtres
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ North Orbit 12m² - Vert         │   │
│  │ [Disponible]              [...] │   │
│  └─────────────────────────────────┘   │
│                                         │
```

**Note :** Les noms de catégories sont affichés dans la langue de l'admin qui les a créées.

#### Nouvelles fonctionnalités
```
┌─────────────────────────────────────────┐
│  Gestion du Matériel           [+]     │
├─────────────────────────────────────────┤
│  [≡ Kites] [≡ Foil] [≡ Boards] ...     │ ← ≡ = Drag handle
│                                         │
│  Menu contextuel (appui long) :        │
│  ┌─────────────────────────┐           │
│  │ ✏️  Modifier            │           │
│  │ 🗑️  Supprimer           │           │
│  │ ↕️  Déplacer            │           │
│  └─────────────────────────┘           │
├─────────────────────────────────────────┤
```

---

## 🔧 IMPLÉMENTATION TECHNIQUE

### Fichiers à créer

| Fichier | Description | Priorité |
|---------|-------------|----------|
| `lib/domain/models/equipment_category.dart` | Modèle de catégorie | 🔴 Haute |
| `lib/data/sources/equipment_category_firestore.dart` | DataSource Firestore | 🔴 Haute |
| `lib/data/repositories/equipment_category_repository.dart` | Repository | 🔴 Haute |
| `lib/presentation/providers/equipment_category_notifier.dart` | Provider Riverpod | 🔴 Haute |
| `lib/presentation/screens/equipment_category_admin_screen.dart` | Écran de gestion | 🟠 Moyenne |
| `lib/presentation/widgets/equipment_category_filter.dart` | Widget de filtre | 🟠 Moyenne |

### Fichiers à modifier

| Fichier | Modification | Priorité |
|---------|--------------|----------|
| `lib/domain/models/equipment.dart` | Remplacer `EquipmentType` par `String categoryId` | 🔴 Haute |
| `lib/presentation/screens/equipment_admin_screen.dart` | Utiliser les catégories dynamiques | 🔴 Haute |
| `lib/l10n/app_*.arb` | Ajouter traductions pour UI | 🟡 Basse |
| `firestore_schema.md` | Ajouter documentation collection `equipment_categories` | 🟡 Basse |

---

## 📋 TODO LIST

### 📌 PHASE 1 : MODÈLES DE DONNÉES

#### Tâche 1.1 : Créer le modèle `EquipmentCategory`
- [ ] Créer `lib/domain/models/equipment_category.dart`
- [ ] Définir les champs : id, name, order, isActive, equipmentIds
- [ ] Ajouter les méthodes `fromJson` / `toJson`
- [ ] Ajouter Freezed + JsonSerializable
- [ ] Lancer `flutter pub run build_runner build --delete-conflicting-outputs`

#### Tâche 1.2 : Modifier le modèle `Equipment`
- [ ] Remplacer `EquipmentType type` par `String categoryId`
- [ ] Mettre à jour les constructeurs
- [ ] Mettre à jour `fromJson` / `toJson`
- [ ] Créer un script de migration pour les équipements existants

**✅ Phase 1 terminée quand :** [ ] 1.1 [ ] 1.2

---

### 📌 PHASE 2 : COUCHE DONNÉES

#### Tâche 2.1 : DataSource Firestore
- [ ] Créer `lib/data/sources/equipment_category_firestore.dart`
- [ ] Implémenter les méthodes :
  - [ ] `Stream<List<EquipmentCategory>> watchAll()`
  - [ ] `Future<void> create(EquipmentCategory category)`
  - [ ] `Future<void> update(EquipmentCategory category)`
  - [ ] `Future<void> delete(String categoryId)`
  - [ ] `Future<void> reorder(String categoryId, int newOrder)`

#### Tâche 2.2 : Repository
- [ ] Créer `lib/data/repositories/equipment_category_repository.dart`
- [ ] Ajouter la validation métier :
  - [ ] Nom unique
  - [ ] Impossible de supprimer si équipements liés
  - [ ] Ordre valide (1 à N)

#### Tâche 2.3 : Provider Riverpod
- [ ] Créer `lib/presentation/providers/equipment_category_notifier.dart`
- [ ] Implémenter `StateNotifierProvider`
- [ ] Gérer l'état : loading, data, error
- [ ] Exposer les actions : create, update, delete, reorder

**✅ Phase 2 terminée quand :** [ ] 2.1 [ ] 2.2 [ ] 2.3

---

### 📌 PHASE 3 : INTERFACE UTILISATEUR

#### Tâche 3.1 : Widget de filtre
- [ ] Créer `lib/presentation/widgets/equipment_category_filter.dart`
- [ ] Afficher le nom de la catégorie (tel qu'enregistré en base)
- [ ] Gérer le drag & drop (package : `flutter_reorderable_list` ou `drag_and_drop_lists`)
- [ ] Menu contextuel (appui long) : Modifier, Supprimer, Déplacer

#### Tâche 3.2 : Écran de gestion des catégories
- [ ] Créer `lib/presentation/screens/equipment_category_admin_screen.dart`
- [ ] Liste des catégories avec réordonnancement
- [ ] Dialog d'ajout/modification
- [ ] Validation des formulaires
- [ ] Confirmation de suppression

#### Tâche 3.3 : Intégration dans EquipmentAdminScreen
- [ ] Remplacer `_buildFilterBar()` par le nouveau widget
- [ ] Utiliser les catégories dynamiques au lieu de l'enum
- [ ] Gérer le cas où aucune catégorie n'existe (créer les défauts)
- [ ] Trier les équipements par `order` des catégories

**✅ Phase 3 terminée quand :** [ ] 3.1 [ ] 3.2 [ ] 3.3

---

### 📌 PHASE 4 : INTERNATIONALISATION (LÉGÈRE)

**Note :** Les catégories étant dans la langue de l'admin, pas besoin de traduire les noms. Seule l'interface de gestion doit être internationalisée.

#### Tâche 4.1 : Clés de traduction
- [ ] Ajouter dans les 5 fichiers `.arb` :
  - `equipmentCategories` : "Catégories d'équipement"
  - `categoryName` : "Nom de la catégorie"
  - `categoryOrder` : "Ordre d'affichage"
  - `categoryActive` : "Catégorie active"
  - `deleteCategory` : "Supprimer la catégorie"
  - `confirmDeleteCategory` : "Êtes-vous sûr de vouloir supprimer cette catégorie ?"
  - `cannotDeleteCategory` : "Impossible de supprimer : {count} équipements associés"
  - `moveEquipmentTo` : "Déplacer les équipements vers..."
  - `reorderCategories` : "Réorganiser les catégories"
  - `dragToReorder` : "Faites glisser pour réorganiser"

#### Tâche 4.2 : Traductions
- [ ] Français (app_fr.arb)
- [ ] Anglais (app_en.arb)
- [ ] Espagnol (app_es.arb)
- [ ] Portugais (app_pt.arb)
- [ ] Chinois (app_zh.arb)
- [ ] Lancer `flutter gen-l10n`
- [ ] Tester dans les 5 langues

**✅ Phase 4 terminée quand :** [ ] 4.1 [ ] 4.2

---

### 📌 PHASE 5 : CRÉATION DES DONNÉES

**Note importante :** Pas de migration des données existantes. On repart de zéro avec la nouvelle collection `equipment_categories`.

#### Tâche 5.1 : Créer les catégories par défaut
- [ ] Créer un script `tools/create_default_categories.dart`
- [ ] Catégories par défaut (en français) :
  - Kites → order: 1
  - Foils → order: 2
  - Planches → order: 3
  - Harnais → order: 4
  - Combinaisons → order: 5
  - Accessoires → order: 6
- [ ] Le script crée les documents dans `equipment_categories`
- [ ] Mettre à jour le champ `type` des équipements existants pour utiliser `categoryId`

#### Tâche 5.2 : Nettoyage de l'ancienne collection
- [ ] Supprimer l'ancienne collection `equipment` (optionnel, pour éviter la confusion)
- [ ] Ou renommer les documents pour utiliser le nouveau format avec `categoryId`

#### Tâche 5.3 : Documentation Firestore
- [ ] Mettre à jour `firestore_schema.md` avec la collection `equipment_categories`
- [ ] Documenter le format des données
- [ ] Ajouter un exemple de document

**✅ Phase 5 terminée quand :** [ ] 5.1 [ ] 5.2 [ ] 5.3

---

### 📌 PHASE 6 : TESTS ET VALIDATION

#### Tâche 6.1 : Tests unitaires
- [ ] Tester le modèle `EquipmentCategory`
- [ ] Tester le repository (validation métier)
- [ ] Tester le notifier (états et actions)

#### Tâche 6.2 : Tests d'intégration
- [ ] Tester l'ajout d'une catégorie
- [ ] Tester la modification d'une catégorie
- [ ] Tester la suppression (avec et sans équipements)
- [ ] Tester le réordonnancement

#### Tâche 6.3 : Tests manuels
- [ ] Tester dans les 5 langues
- [ ] Tester le drag & drop sur mobile et tablette
- [ ] Tester avec 0, 1, et N catégories
- [ ] Tester avec des équipements dans chaque catégorie
- [ ] Vérifier les performances avec 50+ équipements

#### Tâche 6.4 : Validation finale
- [ ] `flutter analyze` - 0 erreur
- [ ] `flutter test` - Tous les tests passent
- [ ] Build release : `flutter build apk --release` (Android)
- [ ] Build release : `flutter build ios --release` (iOS)

**✅ Phase 6 terminée quand :** [ ] 6.1 [ ] 6.2 [ ] 6.3 [ ] 6.4

---

## 📈 SUIVI DE PROGRESSION

| Phase | Tâches | Statut | % |
|-------|--------|--------|---|
| Phase 1 : Modèles de données | 2 | 🔴 À faire | 0% |
| Phase 2 : Couche données | 3 | 🔴 À faire | 0% |
| Phase 3 : Interface utilisateur | 3 | 🔴 À faire | 0% |
| Phase 4 : Internationalisation | 2 | 🔴 À faire | 0% |
| Phase 5 : Migration des données | 3 | 🔴 À faire | 0% |
| Phase 6 : Tests et validation | 4 | 🔴 À faire | 0% |
| **TOTAL** | **17** | **🔴 À faire** | **0%** |

---

## 🚧 RISQUES IDENTIFIÉS

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Perte de données pendant la migration | 🔴 Critique | 🟢 Nulle | **Pas de migration : on repart de zéro** |
| Équipements orphelins après suppression catégorie | 🔴 Critique | 🟠 Faible | Validation stricte + confirmation |
| Performances avec drag & drop | 🟡 Moyenne | 🟠 Faible | Utiliser un package optimisé |
| Conflits de réordonnancement (multi-utilisateurs) | 🟡 Moyenne | 🟢 Très faible | Firestore gère la cohérence |

---

## 📦 DÉPENDANCES À AJOUTER

```yaml
dependencies:
  flutter_reorderable_list: ^1.5.0  # Pour le drag & drop
  # OU
  drag_and_drop_lists: ^0.4.0

dev_dependencies:
  # Déjà présents pour Freezed et JsonSerializable
```

---

## 🎯 CRITÈRES D'ACCEPTATION

### Fonctionnels
- [ ] L'admin peut ajouter une nouvelle catégorie depuis l'UI
- [ ] L'admin peut modifier le nom d'une catégorie existante
- [ ] L'admin peut supprimer une catégorie vide
- [ ] L'admin ne peut pas supprimer une catégorie avec des équipements
- [ ] L'admin peut réorganiser les catégories par drag & drop
- [ ] Les noms de catégories sont dans la langue de l'admin
- [ ] Les changements sont persistés dans Firestore

### Techniques
- [ ] 0 erreur `flutter analyze`
- [ ] Tous les tests unitaires passent
- [ ] Tous les tests d'intégration passent
- [ ] Build release Android et iOS fonctionnels
- [ ] Performances acceptables (< 100ms pour les actions)

### UX
- [ ] Animations fluides pendant le drag & drop
- [ ] Feedback visuel clair (succès, erreur, confirmation)
- [ ] Messages d'erreur explicites
- [ ] Interface cohérente avec le reste de l'application

---

## 📝 NOTES

- **Package drag & drop recommandé :** `flutter_reorderable_list` (maintenu par l'équipe Flutter)
- **Alternative :** Implémenter un ReorderableListView natif (moins flexible mais pas de dépendance)
- **Migration :** Prévoir un rollback en cas de problème
- **Internationalisation :** Les catégories sont dans la langue de l'admin qui les crée. Pas de traduction automatique.
- **Modèle de données simplifié :** Un seul champ `name` au lieu de 5 champs (nameFr, nameEn, etc.)

---

## ✅ HISTORIQUE DES MODIFICATIONS

| Date | Version | Description | Auteur |
|------|---------|-------------|--------|
| 2026-02-27 | 1.0 | Création du document | IA |
| 2026-02-27 | 1.1 | Simplification i18n : une seule langue par catégorie (choix de l'admin) | IA |
| 2026-02-27 | 1.2 | Pas de migration : on repart de zéro avec la collection equipment_categories | IA |

---

**🎯 Prochaine étape :** Commencer la Phase 1 (Modèles de données)
