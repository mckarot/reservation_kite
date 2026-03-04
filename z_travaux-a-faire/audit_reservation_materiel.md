# 🔍 AUDIT COMPLET - SYSTÈME DE RÉSERVATION D'ÉQUIPEMENT

**Date :** 4 mars 2026
**Auteur :** Lead Dev Flutter Senior
**Objet :** Audit de la gestion de disponibilité du matériel dans le temps
**Statut :** ⚠️ **SYSTÈME FONCTIONNEL MAIS AVEC DES FAILLES CRITIQUES**

---

## 📊 RÉSUMÉ EXÉCUTIF

| Catégorie | Nombre |
|-----------|--------|
| ✅ Points forts | 4 |
| ⚠️ Problèmes identifiés | 8 |
| 🔴 **Bugs critiques** | **2** |
| 💡 Recommandations | 6 |
| 📋 Tasks TODO | 11 |

---

## 🎯 CONTEXTE DE L'AUDIT

L'utilisateur veut s'assurer que le système gère correctement la disponibilité du matériel dans le temps :

**Exemple concret :**
- Une voile réservée pour le **5 mars matin** doit être :
  - ✅ Indisponible le 5 mars matin
  - ✅ Disponible le 5 mars après-midi
  - ✅ Disponible le 6 mars toute la journée

**Question centrale :** Si un client réserve la même voile pour le jour suivant, le système vérifie-t-il correctement la disponibilité ?

---

## 1. ✅ CE QUI FONCTIONNE CORRECTEMENT

### 1.1 Modèles de données bien structurés

**Fichiers :**
- `lib/domain/models/equipment_booking.dart`
- `lib/domain/models/equipment_assignment.dart`
- `lib/domain/models/equipment_with_availability.dart`

**Points positifs :**
- ✅ Modèle `EquipmentBooking` avec les champs temporels nécessaires (`dateString`, `dateTimestamp`, `slot`)
- ✅ Modèle `EquipmentAssignment` similaire pour les assignments de séances
- ✅ Modèle enrichi `EquipmentWithAvailability` pour l'affichage UI avec disponibilité calculée

---

### 1.2 Logique de conflit de créneaux correcte

**Fichier :** `lib/utils/booking_conflict_utils.dart` (lignes 11-42)

```dart
bool slotsConflict(
  EquipmentBookingSlot existing,
  EquipmentBookingSlot requested,
) {
  // full_day bloque tout
  if (existing == EquipmentBookingSlot.fullDay) return true;
  if (requested == EquipmentBookingSlot.fullDay) return true;

  // Même créneau = conflit
  return existing == requested;
}
```

**✅ La logique est correcte et symétrique :**
- `full_day` entre en conflit avec `morning`, `afternoon`, et `full_day`
- `morning` entre en conflit avec `morning` et `full_day`
- `afternoon` entre en conflit avec `afternoon` et `full_day`

---

### 1.3 Transaction atomique pour createBooking

**Fichier :** `lib/data/repositories/firebase_equipment_booking_repository.dart` (lignes 26-73)

```dart
Future<String> createBooking(EquipmentBooking booking) async {
  await _firestore.runTransaction((transaction) async {
    // 1. Lire l'équipement
    final equipmentSnap = await transaction.get(equipmentRef);
    
    // 2. Vérifier la limite de 3 réservations actives
    final totalQty = (equipmentSnap.data()?['total_quantity'] ?? 0) as int;
    
    // 3. Compter les conflits avec countConflictingBookings
    final conflicts = countConflictingBookings(...);
    
    // 4. Écrire la réservation
    transaction.set(bookingRef, {...});
  });
}
```

**✅ La méthode utilise une transaction Firestore pour :**
1. Lire l'équipement
2. Vérifier la limite de 3 réservations actives
3. Compter les conflits avec `countConflictingBookings`
4. Écrire la réservation

---

### 1.4 Stream de disponibilité sans N+1 query

**Fichier :** `lib/data/repositories/firebase_equipment_booking_repository.dart` (lignes 145-220)

**✅ Utilisation de `Rx.combineLatest2` pour :**
- Combiner les streams équipement + réservations
- Éviter les lectures imbriquées (N+1 queries)
- Calculer la disponibilité en temps réel

---

## 2. ⚠️ PROBLÈMES IDENTIFIÉS

### 2.1 ⚠️ CRITIQUE : Champ `total_quantity` manquant dans le modèle Equipment

**Fichier :** `lib/domain/models/equipment.dart`

**Problème :** Le modèle `Equipment` **ne contient PAS** le champ `total_quantity`, mais le repository le lit depuis Firestore :

```dart
// firebase_equipment_booking_repository.dart, ligne 39
final totalQty = (equipmentSnap.data()?['total_quantity'] ?? 0) as int;

// firebase_equipment_booking_repository.dart, ligne 197
final totalQty = equipmentData['total_quantity'] as int? ?? 1;
```

**Impact :** Risque d'erreurs de type si `total_quantity` n'est pas un entier. Incohérence entre le modèle domaine et les données Firestore.

---

### 2.2 ⚠️ CRITIQUE : Logique de disponibilité dans l'UI ne gère PAS les full_day

**Fichier :** `lib/presentation/screens/equipment_booking_screen.dart` (lignes 278-301)

```dart
Stream<_SizeAvailability> _watchSizeAvailability(List<Equipment> equipmentList) {
  return FirebaseFirestore.instance
      .collection('equipment_bookings')
      .where('date_string', isEqualTo: dateString)
      .where('slot', isEqualTo: slotString)  // ❌ PROBLÈME ICI
      .where('status', whereIn: ['confirmed', 'completed'])
      .snapshots()
      .map((snapshot) {
        final reservedEquipmentIds = snapshot.docs
            .map((d) => d.data()['equipment_id'] as String)
            .toSet();
        // ...
      });
}
```

**❌ Problème :** La requête filtre par `slot` exact. Si un utilisateur réserve `full_day`, la requête pour `morning` ne le verra PAS comme conflit.

**Exemple concret du bug :**
1. Utilisateur A réserve une voile en `full_day` le 5 mars
2. Utilisateur B ouvre l'écran pour le 5 mars `morning`
3. La requête `.where('slot', isEqualTo: 'morning')` ne retourne PAS la réservation full_day
4. L'UI affiche "Disponible" ❌ (FAUX !)
5. Si B tente de réserver, `bookEquipmentAtomically` échouera (car il vérifie le statut `reserved`)

**Incohérence :** L'UI utilise une logique différente du repository !

---

### 2.3 ⚠️ MAJEUR : Incohérence des valeurs de statut Equipment

**Fichier :** `lib/presentation/screens/equipment_init_screen.dart` (lignes 59-67)

```dart
// Migration du status
if (data.containsKey('status')) {
  final oldStatus = data['status'] as String;
  if (oldStatus == 'available') {
    updates['status'] = 'active';  // ❌ Change 'available' en 'active'
  } else if (oldStatus == 'damaged') {
    updates['status'] = 'retired'; // ❌ Change 'damaged' en 'retired'
  }
}
```

**Mais :**
- L'enum `EquipmentStatus` dans `lib/domain/models/equipment.dart` (lignes 7-14) contient : `available`, `maintenance`, `damaged`, `reserved`
- Le repository `lib/data/repositories/firestore_equipment_repository.dart` (ligne 103) vérifie : `if (currentStatus != 'available')`

**❌ Problème :** Après migration, le statut sera `'active'` au lieu de `'available'`, donc la vérification `currentStatus != 'available'` échouera toujours !

**Impact :** Toutes les réservations échoueront après migration avec l'erreur "Équipement non disponible : statut actuel = active".

---

### 2.4 ⚠️ MAJEUR : EquipmentAssignment ne vérifie PAS les conflits de date/slot

**Fichier :** `lib/data/repositories/firebase_equipment_assignment_repository.dart` (lignes 23-44)

```dart
Future<String> assignEquipment(EquipmentAssignment assignment) async {
  // Vérifier que l'équipement n'est pas déjà assigné
  final isAssigned = await isEquipmentAssigned(
    equipmentId: assignment.equipmentId,
    sessionId: assignment.sessionId,  // ❌ Vérifie seulement sessionId
  );

  if (isAssigned) {
    throw Exception('Cet équipement est déjà assigné pour cette séance');
  }
  // ...
}
```

**❌ Problème :** La vérification se fait uniquement sur `sessionId`, pas sur `dateString` + `slot`.

**Scénario de bug :**
1. Séance A le 5 mars matin → assigne voile V1
2. Séance B le 5 mars matin (différente) → peut assigner la MÊME voile V1 ❌

**Manque :** Une vérification `isEquipmentAssignedForDateSlot(equipmentId, dateString, slot)`

---

### 2.5 ⚠️ MAJEUR : Race condition dans assignEquipment

**Fichier :** `lib/data/repositories/firebase_equipment_assignment_repository.dart` (lignes 23-44)

```dart
Future<String> assignEquipment(EquipmentAssignment assignment) async {
  // 1. Lecture hors transaction
  final isAssigned = await isEquipmentAssigned(...);
  if (isAssigned) { /* ... */ }

  // 2. Écriture séparée
  final docRef = _col.doc();
  await docRef.set({...});

  // 3. Update séparé
  await _firestore.collection('equipment').doc(assignment.equipmentId).update({
    'status': 'reserved',
    // ...
  });
}
```

**❌ Problème :** Lecture + écriture ne sont **PAS atomiques**. Deux admins peuvent assigner le même équipement en parallèle.

**Solution requise :** Utiliser une transaction Firestore comme dans `createBooking`.

---

### 2.6 ⚠️ MOYEN : Stream watchEquipmentAvailability ne gère pas full_day correctement

**Fichier :** `lib/data/repositories/firebase_equipment_booking_repository.dart` (lignes 173-178)

```dart
final bookingsStream = _firestore
    .collection('equipment_bookings')
    .where('equipment_id', isEqualTo: equipmentId)
    .where('date_string', isEqualTo: dateString)
    .where('status', whereIn: ['confirmed', 'completed'])
    .snapshots()
```

**Problème :** Le stream récupère TOUTES les réservations de la date, mais la fonction `countConflictingBookings` est appelée avec le `slot` demandé. La logique `slotsConflict` est correcte, MAIS...

**Incohérence :** Dans la méthode `createBooking` (ligne 56), la requête filtre aussi par `date_string` mais pas par `slot`, ce qui est correct. Cependant, le commentaire ligne 172 dit "les réservations pour cette date" mais devrait préciser "toutes les réservations pour cette date (pour calculer les conflits avec le slot demandé)".

---

### 2.7 ⚠️ MOYEN : bookEquipmentAtomically ne vérifie PAS les conflits de slot

**Fichier :** `lib/data/repositories/firestore_equipment_repository.dart` (lignes 86-127)

```dart
Future<bool> bookEquipmentAtomically({...}) async {
  await _firestore.runTransaction((transaction) async {
    // 1. Lire l'équipement
    final equipmentDoc = await transaction.get(equipmentRef);
    
    // 2. Vérifier statut
    if (currentStatus != 'available') { /* ... */ }

    // 3. Update statut + création réservation
    // ...
  });
}
```

**❌ Problème :** Cette méthode vérifie le statut de l'équipement mais **ne vérifie PAS** si l'équipement est déjà réservé sur ce créneau !

**Comparaison avec `createBooking` :**
- `createBooking` (firebase_equipment_booking_repository.dart) : ✅ Vérifie les conflits avec `countConflictingBookings`
- `bookEquipmentAtomically` (firestore_equipment_repository.dart) : ❌ Ne vérifie PAS les conflits

**Incohérence :** Deux méthodes de réservation avec des logiques différentes !

---

### 2.8 ⚠️ MOYEN : ReleaseEquipment n'est pas atomique

**Fichier :** `lib/data/repositories/firestore_equipment_repository.dart` (lignes 129-154)

```dart
Future<void> releaseEquipment({...}) async {
  final batch = _firestore.batch();
  batch.update(_collection.doc(equipmentId), {...});
  batch.update(_firestore.collection(_bookingsCollectionPath).doc(bookingId), {...});
  await batch.commit();
}
```

**❌ Problème :** Utilise un `batch` au lieu d'une `transaction`. Un batch ne lit pas les données avant d'écrire.

**Risque :** Si l'équipement a été modifié entre-temps, le batch va écraser les modifications.

---

## 3. 🔴 BUGS CRITIQUES

### 3.1 🔴 BUG CRITIQUE : Migration casse la vérification de disponibilité

**Combinaison de fichiers :**
- `lib/presentation/screens/equipment_init_screen.dart` (lignes 59-67) : Migration `available` → `active`
- `lib/data/repositories/firestore_equipment_repository.dart` (ligne 103) : Vérifie `currentStatus != 'available'`

**Scénario du bug :**
1. Migration exécutée → tous les statuts `available` deviennent `active`
2. Utilisateur tente de réserver
3. `bookEquipmentAtomically` lit `status = 'active'`
4. Vérification `if (currentStatus != 'available')` → TRUE
5. Exception : "Équipement non disponible : statut actuel = active"
6. **Toutes les réservations échouent** 🔴

**Corrections possibles :**
- Soit ne pas migrer les statuts
- Soit mettre à jour toutes les vérifications pour utiliser `'active'` au lieu de `'available'`
- Soit ajouter `'active'` dans l'enum `EquipmentStatus`

---

### 3.2 🔴 BUG CRITIQUE : L'UI affiche "Disponible" alors que l'équipement est réservé en full_day

**Fichier :** `lib/presentation/screens/equipment_booking_screen.dart` (lignes 278-301)

**Scénario du bug :**
1. Utilisateur A réserve voile V1 le 5 mars `full_day`
2. Utilisateur B ouvre l'écran pour le 5 mars `morning`
3. Requête UI : `.where('slot', isEqualTo: 'morning')` → ne retourne PAS la réservation full_day
4. UI affiche : "1/1 disponible" ✅ (faux !)
5. Utilisateur B clique sur "Réserver"
6. `bookEquipmentAtomically` vérifie le statut → `reserved` → échec
7. Message d'erreur : "Cet équipement vient d'être réservé"

**Impact :** Expérience utilisateur dégradée, réservations qui échouent sans raison apparente.

---

## 4. 💡 RECOMMANDATIONS D'AMÉLIORATION

### 4.1 Ajouter le champ `total_quantity` au modèle Equipment

**Fichier :** `lib/domain/models/equipment.dart`

```dart
@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    // ... champs existants
    @JsonKey(name: 'total_quantity') @Default(1) int totalQuantity,
    // ...
  }) = _Equipment;
}
```

---

### 4.2 Uniformiser la logique de conflit dans toute l'application

**Fichier :** `lib/presentation/screens/equipment_booking_screen.dart`

**Remplacer la méthode `_watchSizeAvailability` pour utiliser `countConflictingBookings` :**

```dart
Stream<_SizeAvailability> _watchSizeAvailability(List<Equipment> equipmentList) {
  return FirebaseFirestore.instance
      .collection('equipment_bookings')
      .where('date_string', isEqualTo: dateString)
      .where('status', whereIn: ['confirmed', 'completed'])
      .snapshots()
      .map((snapshot) {
        final bookings = snapshot.docs.map((d) => d.data()).toList();
        
        // Compter les conflits pour CHAQUE équipement
        final availableCount = equipmentList.where((eq) {
          if (eq.status != EquipmentStatus.available) return false;
          
          // Filtrer les réservations pour CET équipement
          final eqBookings = bookings.where((b) => b['equipment_id'] == eq.id).toList();
          final conflicts = countConflictingBookings(eqBookings, _selectedSlot);
          
          // Disponible si pas de conflit
          return conflicts == 0;
        }).length;
        
        return _SizeAvailability(availableCount: availableCount, totalCount: equipmentList.length);
      });
}
```

---

### 4.3 Corriger la migration des statuts

**Fichier :** `lib/presentation/screens/equipment_init_screen.dart`

**Option 1 : Ne pas migrer les statuts (recommandé)**
```dart
// Supprimer les lignes 59-67
```

**Option 2 : Ajouter les nouveaux statuts à l'enum**
```dart
enum EquipmentStatus {
  @JsonValue('available')
  available,
  @JsonValue('active')  // Nouveau
  active,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('damaged')
  damaged,
  @JsonValue('retired')  // Nouveau
  retired,
  @JsonValue('reserved')
  reserved,
}
```

---

### 4.4 Ajouter une transaction dans assignEquipment

**Fichier :** `lib/data/repositories/firebase_equipment_assignment_repository.dart`

```dart
Future<String> assignEquipment(EquipmentAssignment assignment) async {
  final docRef = _col.doc();
  
  await _firestore.runTransaction((transaction) async {
    // 1. Vérifier que l'équipement n'est pas déjà assigné pour cette date/slot
    final existingAssignments = await _firestore
        .collection(_collection)
        .where('equipment_id', isEqualTo: assignment.equipmentId)
        .where('date_string', isEqualTo: assignment.dateString)
        .where('slot', isEqualTo: assignment.slot)
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();
    
    if (existingAssignments.docs.isNotEmpty) {
      throw Exception('Cet équipement est déjà assigné pour ce créneau');
    }
    
    // 2. Vérifier le statut de l'équipement
    final equipmentDoc = await transaction.get(
      _firestore.collection('equipment').doc(assignment.equipmentId)
    );
    if (equipmentDoc.data()?['status'] != 'available') {
      throw Exception('Équipement non disponible');
    }
    
    // 3. Écrire l'assignment
    transaction.set(docRef, {
      ...assignment.toJson(),
      'id': docRef.id,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    
    // 4. Update statut équipement
    transaction.update(equipmentDoc.reference, {
      'status': 'reserved',
      'updated_at': FieldValue.serverTimestamp(),
    });
  });
  
  return docRef.id;
}
```

---

### 4.5 Ajouter la vérification de conflits dans bookEquipmentAtomically

**Fichier :** `lib/data/repositories/firestore_equipment_repository.dart`

```dart
Future<bool> bookEquipmentAtomically({...}) async {
  // ...
  await _firestore.runTransaction((transaction) async {
    // ... vérifications existantes
    
    // NOUVEAU : Vérifier les conflits de slot
    final existingBookings = await _firestore
        .collection(_bookingsCollectionPath)
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: bookingData['date_string'])
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();
    
    final conflicts = countConflictingBookings(
      existingBookings.docs.map((d) => d.data()).toList(),
      EquipmentBookingSlot.values.firstWhere((e) => e.name == bookingData['slot']),
    );
    
    if (conflicts > 0) {
      throw Exception('Créneau déjà réservé');
    }
    
    // ... suite de la transaction
  });
}
```

---

### 4.6 Utiliser une transaction dans releaseEquipment

**Fichier :** `lib/data/repositories/firestore_equipment_repository.dart`

```dart
Future<void> releaseEquipment({...}) async {
  final equipmentRef = _collection.doc(equipmentId);
  final bookingRef = _firestore.collection(_bookingsCollectionPath).doc(bookingId);
  
  await _firestore.runTransaction((transaction) async {
    // Vérifier que la réservation existe et a le bon statut
    final bookingDoc = await transaction.get(bookingRef);
    if (!bookingDoc.exists || bookingDoc.data()?['status'] != 'confirmed') {
      throw Exception('Réservation invalide');
    }
    
    transaction.update(equipmentRef, {
      'status': 'available',
      'updated_at': FieldValue.serverTimestamp(),
    });
    
    transaction.update(bookingRef, {
      'status': newBookingStatus,
      'updated_at': FieldValue.serverTimestamp(),
    });
  });
}
```

---

## 5. 📋 TODO LIST DES CORRECTIONS

### 🔴 Priorité 1 - Bugs Critiques (à corriger IMMÉDIATEMENT)

- [x] **5.1.1** : ~~Corriger la migration des statuts dans `lib/presentation/screens/equipment_init_screen.dart`~~
  - ✅ **CORRIGÉ :** Suppression de la migration des statuts (lignes 59-67)
  - Les statuts restent : `'available'`, `'maintenance'`, `'damaged'`, `'reserved'`
  - **Fichier :** `lib/presentation/screens/equipment_init_screen.dart`
  - **Lignes :** 62-65 (commentées)
  - **Date de correction :** 4 mars 2026

- [ ] **5.1.2** : Mettre à jour toutes les vérifications de statut
  - Remplacer `if (currentStatus != 'available')` par une vérification qui inclut `'active'`
  - **Fichier :** `lib/data/repositories/firestore_equipment_repository.dart`
  - **Ligne :** 103
  - **Statut :** ✅ **DÉJÀ CORRECT** - La vérification utilise `'available'` qui correspond à l'enum

- [ ] **5.1.3** : Corriger la logique de disponibilité dans l'UI
  - Modifier `_watchSizeAvailability` pour utiliser `countConflictingBookings`
  - **Fichier :** `lib/presentation/screens/equipment_booking_screen.dart`
  - **Lignes :** 278-301

---

### ⚠️ Priorité 2 - Problèmes Majeurs (à corriger sous 1 semaine)

- [ ] **5.2.1** : Ajouter le champ `total_quantity` au modèle `Equipment`
  - **Fichier :** `lib/domain/models/equipment.dart`
  - **Lignes :** 38-50 (dans le factory)

- [ ] **5.2.2** : Ajouter une transaction dans `assignEquipment`
  - **Fichier :** `lib/data/repositories/firebase_equipment_assignment_repository.dart`
  - **Lignes :** 23-44

- [ ] **5.2.3** : Ajouter la vérification de conflits de slot dans `assignEquipment`
  - Vérifier `date_string` + `slot` et pas seulement `sessionId`
  - **Fichier :** `lib/data/repositories/firebase_equipment_assignment_repository.dart`
  - **Lignes :** 23-44

- [ ] **5.2.4** : Ajouter la vérification de conflits dans `bookEquipmentAtomically`
  - **Fichier :** `lib/data/repositories/firestore_equipment_repository.dart`
  - **Lignes :** 86-127

---

### 💡 Priorité 3 - Améliorations (à corriger sous 2 semaines)

- [ ] **5.3.1** : Utiliser une transaction dans `releaseEquipment` au lieu d'un batch
  - **Fichier :** `lib/data/repositories/firestore_equipment_repository.dart`
  - **Lignes :** 129-154

- [ ] **5.3.2** : Uniformiser les noms de statuts dans toute l'application
  - Choisir entre `available`/`active` et `damaged`/`retired`
  - Mettre à jour tous les fichiers concernés

- [ ] **5.3.3** : Ajouter des tests unitaires pour la logique de conflit
  - Tester `slotsConflict` avec toutes les combinaisons
  - Tester `countConflictingBookings` avec des scénarios réels
  - **Fichier à créer :** `test/utils/booking_conflict_utils_test.dart`

- [ ] **5.3.4** : Ajouter des tests d'intégration pour les réservations concurrentes
  - Simuler deux utilisateurs réservant le même équipement en parallèle
  - Vérifier qu'une seule réservation réussit
  - **Fichier à créer :** `test/repositories/equipment_booking_repository_integration_test.dart`

---

## 📊 CONCLUSION

**État global :** ⚠️ **SYSTÈME FONCTIONNEL MAIS AVEC DES FAILLES CRITIQUES**

### Points forts :
✅ Modèles de données bien structurés
✅ Logique de conflit correcte dans `booking_conflict_utils.dart`
✅ Transaction atomique pour `createBooking`
✅ Stream de disponibilité sans N+1 query

### Points critiques à corriger :
🔴 Migration des statuts casse la vérification de disponibilité
🔴 L'UI ne gère pas correctement les réservations `full_day`
🔴 Race conditions dans `assignEquipment`
🔴 Incohérences entre les méthodes de réservation

### 🎯 RECOMMANDATION PRINCIPALE

**Corriger les bugs de priorité 1 AVANT toute mise en production**, car ils peuvent causer :
1. ❌ L'échec systématique de **toutes les réservations** après migration
2. ❌ Une expérience utilisateur dégradée avec des erreurs incompréhensibles
3. ❌ Des réservations doubles pour le même équipement

---

**Document créé le :** 4 mars 2026
**Prochaine revue :** Après correction des bugs critiques
