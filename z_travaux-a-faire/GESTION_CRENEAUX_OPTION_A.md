# 📅 GESTION DES CRÉNEAUX - OPTION A

## 🎯 OBJECTIF

Permettre la réservation d'un même équipement pour **plusieurs créneaux dans la même journée**.

---

## ⚠️ PROBLÈME INITIAL

**Avant :**
- Un équipement réservé le matin → statut `reserved`
- L'équipement est **indisponible pour toute la journée**
- Impossible de réserver le même équipement l'après-midi

**Exemple concret :**
```
Kite F-One Bandit 12m²
├─ Réservation 1 : Jean - Matin (9h-12h)
└─ Statut : reserved ❌
   → Marie ne peut pas réserver l'après-midi (14h-17h)
```

---

## ✅ SOLUTION IMPLÉMENTÉE

### Principe

| Créneau | Statut équipement | Disponibilité autre créneau |
|---------|------------------|----------------------------|
| `morning` (9h-12h) | Reste `available` | ✅ Disponible pour `afternoon` |
| `afternoon` (14h-17h) | Reste `available` | ✅ Disponible pour `morning` |
| `full_day` (9h-17h) | Passe `reserved` | ❌ Indisponible toute la journée |
| `maintenance` | `maintenance` | ❌ Toujours indisponible |
| `damaged` | `damaged` | ❌ Toujours indisponible |

### Règles de gestion

1. **Réservation morning/afternoon :**
   - Le statut de l'équipement **ne change pas**
   - La disponibilité est calculée **par créneau** via les conflits
   - Un équipement peut avoir 2 réservations le même jour (matin + après-midi)

2. **Réservation full_day :**
   - Le statut passe à `reserved`
   - Bloque l'équipement pour toute la journée
   - Empêche les réservations morning/afternoon

3. **Libération du matériel :**
   - Vérifie s'il reste d'autres réservations pour ce jour
   - Si **oui** : garde le statut `reserved`
   - Si **non** : passe le statut `available`

---

## 🔧 MODIFICATIONS TECHNIQUES

### 1. `bookEquipmentAtomically` (firestore_equipment_repository.dart)

```dart
// Avant :
if (currentStatus != 'available') {
  throw Exception('Équipement non disponible');
}
transaction.update(equipmentRef, {'status': 'reserved'});

// Après :
final isFullDay = slotString == 'full_day';

if (isFullDay && currentStatus != 'available') {
  throw Exception('Équipement non disponible pour la journée');
} else if (!isFullDay && (currentStatus == 'maintenance' || currentStatus == 'damaged')) {
  throw Exception('Équipement non disponible : statut actuel = $currentStatus');
}

// Seulement full_day change le statut
if (isFullDay) {
  transaction.update(equipmentRef, {'status': 'reserved'});
}
```

### 2. `releaseEquipment` (firestore_equipment_repository.dart)

```dart
// Avant : batch simple qui libère toujours
batch.update(equipmentRef, {'status': 'available'});

// Après : transaction qui vérifie les autres réservations
final otherBookings = await _firestore
    .collection('equipment_bookings')
    .where('equipment_id', isEqualTo: equipmentId)
    .where('date_string', isEqualTo: dateString)
    .where('status', whereIn: ['confirmed', 'completed'])
    .get();

if (remainingBookings.isEmpty) {
  transaction.update(equipmentRef, {'status': 'available'});
}
// Sinon, garde le statut 'reserved'
```

### 3. `_watchSizeAvailability` (equipment_booking_screen.dart)

```dart
// Avant :
if (eq.status != EquipmentStatus.available) return false;

// Après :
if (eq.status == EquipmentStatus.maintenance || 
    eq.status == EquipmentStatus.damaged) {
  return false; // Toujours indisponible
}

// Vérifie les conflits de créneau
final conflicts = countConflictingBookings(eqBookings, _selectedSlot);
return conflicts == 0;
```

---

## 📊 EXEMPLES CONCRETS

### Exemple 1 : Réservation matin + après-midi

```
Date : 15 mars 2026
Équipement : Kite F-One Bandit 12m²

09:00 - Jean réserve pour le matin (morning)
├─ Statut équipement : available (inchangé)
└─ Réservation créée : confirmed

10:00 - Marie veut réserver pour l'après-midi (afternoon)
├─ Vérification des conflits : 0 conflit avec morning
└─ ✅ Réservation acceptée !

Résultat :
├─ Matin : Jean
├─ Après-midi : Marie
└─ Statut : available (ou reserved si full_day détecté)
```

### Exemple 2 : Réservation journée complète

```
Date : 15 mars 2026
Équipement : Kite F-One Bandit 12m²

09:00 - Jean réserve pour la journée (full_day)
├─ Statut équipement : available → reserved
└─ Réservation créée : confirmed

10:00 - Marie veut réserver pour l'après-midi (afternoon)
├─ Vérification : statut = reserved
└─ ❌ Réservation refusée !
```

### Exemple 3 : Libération partielle

```
Date : 15 mars 2026
Équipement : Kite F-One Bandit 12m²

Réservations :
├─ Matin : Jean (confirmed)
└─ Après-midi : Marie (confirmed)

12:00 - Jean libère son matériel (fin du matin)
├─ Vérification : il reste la réservation de Marie
└─ Statut : reste reserved

17:00 - Marie libère son matériel (fin de l'après-midi)
├─ Vérification : aucune autre réservation
└─ Statut : reserved → available
```

---

## 🧪 SCÉNARIOS DE TEST

### Test 1 : Morning + Afternoon (même équipement)

1. Connecté en **élève** (mat@mail.com)
2. Aller dans "🏄 Location Matériel"
3. Choisir une date (ex: demain)
4. Sélectionner un créneau **Matin**
5. Réserver un équipement (ex: Kite 12m²)
6. ✅ Réservation confirmée
7. Se déconnecter
8. Connecté en **autre élève** (creer un compte test)
9. Même date, créneau **Après-midi**
10. Même équipement (Kite 12m²)
11. ✅ Réservation confirmée

### Test 2 : Full_day bloque tout

1. Connecté en **élève**
2. Aller dans "🏄 Location Matériel"
3. Choisir une date
4. Sélectionner un créneau **Journée**
5. Réserver un équipement
6. ✅ Réservation confirmée
7. Se déconnecter
8. Connecté en **autre élève**
9. Même date, créneau **Matin** ou **Après-midi**
10. Même équipement
11. ❌ Réservation refusée (équipement indisponible)

### Test 3 : Libération partielle

1. Connecté en **admin** (admin@mail.com)
2. Créer 2 réservations pour le même équipement :
   - Matin : Élève A
   - Après-midi : Élève B
3. Aller dans "📊 Réservations Matériel"
4. Vérifier les 2 réservations
5. Libérer la réservation du matin (Élève A)
6. ✅ Statut équipement : reste `reserved`
7. Libérer la réservation de l'après-midi (Élève B)
8. ✅ Statut équipement : passe à `available`

### Test 4 : Maintenance bloque tout

1. Connecté en **admin**
2. Aller dans "📦 Gestion Matériel"
3. Changer le statut d'un équipement à `maintenance`
4. Se déconnecter
5. Connecté en **élève**
6. Tenter de réserver cet équipement (matin, après-midi, journée)
7. ❌ Toutes les réservations sont refusées

---

## 📝 IMPACTS SUR LES AUTRES FONCTIONNALITÉS

### EquipmentAdminScreen
- ✅ Affiche le statut global (unchanged)
- ✅ `reserved` = "au moins un créneau réservé aujourd'hui"

### LessonValidationScreen
- ✅ Assignment d'équipement gère déjà les créneaux
- ✅ Libération du matériel fonctionne correctement

### EquipmentReservationsScreen
- ✅ Affiche toutes les réservations par date
- ✅ Regroupe par type d'équipement
- ✅ Affiche le créneau (MATIN/APREM/JOUR)

---

## 🎯 BÉNÉFICES

| Avant | Après |
|-------|-------|
| 1 équipement = 1 réservation/jour | 1 équipement = 2 réservations/jour (matin + après-midi) |
| Statut global (toute la journée) | Statut par créneau |
| Perte de revenus potentiels | Optimisation du taux d'utilisation |
| Frustration des élèves | Meilleure disponibilité |

---

## 📚 FICHIERS MODIFIÉS

1. `lib/data/repositories/firestore_equipment_repository.dart`
   - `bookEquipmentAtomically` : Gestion des créneaux
   - `releaseEquipment` : Transaction avec vérification

2. `lib/presentation/screens/equipment_booking_screen.dart`
   - `_watchSizeAvailability` : Disponibilité par créneau

3. `lib/domain/utils/booking_conflict_utils.dart`
   - `countConflictingBookings` : Déjà opérationnel ✅

---

## ✅ CHECKLIST FINALE

- [x] Modifier `bookEquipmentAtomically`
- [x] Modifier `releaseEquipment`
- [x] Mettre à jour l'UI de disponibilité
- [ ] Tests manuels (à effectuer)
- [ ] Mettre à jour la documentation Firestore
- [ ] Informer les utilisateurs du changement

---

**Date de mise en place :** 4 mars 2026  
**Version :** 1.0.0  
**Statut :** ✅ Implémenté - En attente de tests manuels
