# 🧪 GUIDE DE TESTS MANUELS - SYSTÈME DE RÉSERVATION

**Date :** 4 mars 2026
**Version :** 1.0
**Objectif :** Valider les corrections des bugs critiques et majeurs

---

## 📋 CHECKLIST RAPIDE

| Test | Priorité | Statut |
|------|----------|--------|
| **Test 1 :** full_day vs morning/afternoon | 🔴 Critique | ⏳ À faire |
| **Test 2 :** morning vs afternoon | 🔴 Critique | ⏳ À faire |
| **Test 3 :** Migration des statuts | 🔴 Critique | ⏳ À faire |
| **Test 4 :** Race condition assignEquipment | ⚠️ Majeur | ⏳ À faire |
| **Test 5 :** Conflit de slot (booking) | ⚠️ Majeur | ⏳ À faire |
| **Test 6 :** Conflit de slot (assignment) | ⚠️ Majeur | ⏳ À faire |

---

## 🔴 TESTS CRITIQUES (OBLIGATOIRES)

### Test 1 : full_day vs morning/afternoon

**Objectif :** Vérifier qu'une voile réservée en `full_day` est indisponible pour `morning` ET `afternoon`.

**Pré-requis :**
- Avoir un compte admin/moniteur
- Avoir au moins 1 voile (kite) disponible
- 2 comptes élèves différents (ou 1 admin + 1 élève)

**Scénario :**

```
ÉTAPE 1 : Réserver une voile en full_day
1.1. Se connecter en tant qu'élève A
1.2. Aller dans "Réserver du matériel"
1.3. Sélectionner une date future (ex: 15 mars 2026)
1.4. Sélectionner le slot "Journée complète" (full_day)
1.5. Choisir une voile (ex: F-One Bandit 12m²)
1.6. Cliquer sur "Réserver"
1.7. ✅ VÉRIFIER : La réservation est confirmée

ÉTAPE 2 : Vérifier la disponibilité pour morning
2.1. Se connecter en tant qu'élève B
2.2. Aller dans "Réserver du matériel"
2.3. Sélectionner la MÊME date (15 mars 2026)
2.4. Sélectionner le slot "Matin" (morning)
2.5. ✅ VÉRIFIER : La même voile apparaît "Indisponible" ou "0/1 disponible"

ÉTAPE 3 : Vérifier la disponibilité pour afternoon
3.1. Toujours en tant qu'élève B
3.2. Changer le slot pour "Après-midi" (afternoon)
3.3. ✅ VÉRIFIER : La même voile apparaît "Indisponible" ou "0/1 disponible"
```

**Résultat attendu :**
- ✅ La voile réservée en `full_day` est indisponible pour `morning`
- ✅ La voile réservée en `full_day` est indisponible pour `afternoon`

**Si le test échoue :**
- La voile apparaît comme disponible → Bug critique non corrigé !
- Prendre une capture d'écran et signaler le bug

---

### Test 2 : morning vs afternoon

**Objectif :** Vérifier qu'une voile réservée le `morning` est disponible l'`afternoon` (et vice-versa).

**Pré-requis :**
- Avoir un compte admin/moniteur
- Avoir au moins 1 voile (kite) disponible
- 2 comptes élèves différents

**Scénario :**

```
ÉTAPE 1 : Réserver une voile en morning
1.1. Se connecter en tant qu'élève A
1.2. Aller dans "Réserver du matériel"
1.3. Sélectionner une date future (ex: 20 mars 2026)
1.4. Sélectionner le slot "Matin" (morning)
1.5. Choisir une voile (ex: F-One Bandit 12m²)
1.6. Cliquer sur "Réserver"
1.7. ✅ VÉRIFIER : La réservation est confirmée

ÉTAPE 2 : Vérifier la disponibilité pour afternoon
2.1. Se connecter en tant qu'élève B
2.2. Aller dans "Réserver du matériel"
2.3. Sélectionner la MÊME date (20 mars 2026)
2.4. Sélectionner le slot "Après-midi" (afternoon)
2.5. ✅ VÉRIFIER : La même voile apparaît "Disponible" ou "1/1 disponible"
2.6. ✅ VÉRIFIER : Le bouton "Réserver" est actif

ÉTAPE 3 : Réserver la même voile en afternoon
3.1. Toujours en tant qu'élève B
3.2. Cliquer sur "Réserver" pour la même voile
3.3. ✅ VÉRIFIER : La réservation est confirmée
```

**Résultat attendu :**
- ✅ La voile réservée le `morning` est disponible l'`après-midi`
- ✅ On peut réserver la même voile le matin ET l'après-midi (à des élèves différents)

**Si le test échoue :**
- La voile apparaît comme indisponible l'après-midi → Bug critique !
- Prendre une capture d'écran et signaler le bug

---

### Test 3 : Migration des statuts

**Objectif :** Vérifier que la migration ne casse pas les statuts des équipements.

**Pré-requis :**
- Avoir un compte admin
- Avoir des équipements avec différents statuts (available, maintenance, damaged)

**Scénario :**

```
ÉTAPE 1 : Noter les statuts actuels
1.1. Aller dans Firestore Console (https://console.firebase.google.com)
1.2. Naviguer vers la collection "equipment"
1.3. Noter les statuts de quelques équipements :
    - Équipement A : status = "available"
    - Équipement B : status = "maintenance"
    - Équipement C : status = "damaged"
1.4. ✅ VÉRIFIER : Les statuts sont corrects

ÉTAPE 2 : Lancer la migration
2.1. Se connecter en tant qu'admin dans l'application
2.2. Aller dans l'écran d'initialisation (EquipmentInitScreen)
2.3. Lancer la migration
2.4. ✅ VÉRIFIER : La migration se termine sans erreur

ÉTAPE 3 : Vérifier les statuts après migration
3.1. Retourner dans Firestore Console
3.2. Vérifier les mêmes équipements :
    - Équipement A : status = "available" (doit être IDENTIQUE)
    - Équipement B : status = "maintenance" (doit être IDENTIQUE)
    - Équipement C : status = "damaged" (doit être IDENTIQUE)
3.3. ✅ VÉRIFIER : Les statuts n'ont PAS changé

ÉTAPE 4 : Tenter une réservation
4.1. Se connecter en tant qu'élève
4.2. Aller dans "Réserver du matériel"
4.3. Sélectionner une date et un slot
4.4. Choisir un équipement avec status = "available"
4.5. Cliquer sur "Réserver"
4.6. ✅ VÉRIFIER : La réservation réussit (pas d'erreur "Équipement non disponible")
```

**Résultat attendu :**
- ✅ Les statuts ne changent PAS après la migration
- ✅ Les réservations fonctionnent normalement après la migration

**Si le test échoue :**
- Les statuts changent (ex: "available" → "active") → Bug critique !
- Les réservations échouent → Bug critique !
- Prendre une capture d'écran et signaler le bug

---

## ⚠️ TESTS MAJEURS (RECOMMANDÉS)

### Test 4 : Race condition assignEquipment

**Objectif :** Vérifier que deux admins ne peuvent pas assigner le même équipement en même temps.

**Pré-requis :**
- Avoir 2 comptes admin/moniteur
- Avoir 2 séances différentes le même matin
- Avoir 1 voile disponible

**Scénario :**

```
ÉTAPE 1 : Préparer deux sessions
1.1. Ouvrir l'application sur deux appareils/navigateurs
1.2. Session 1 : Admin A
1.3. Session 2 : Admin B

ÉTAPE 2 : Tenter d'assigner la même voile en même temps
2.1. Admin A : Assignment Screen → Séance A → Voile V1 → Cliquer "Assigner"
2.2. Admin B : Assignment Screen → Séance B → Voile V1 → Cliquer "Assigner"
     (le plus simultanément possible)
2.3. ✅ VÉRIFIER : Un seul admin reçoit un message de succès
2.4. ✅ VÉRIFIER : L'autre admin reçoit un message d'erreur
     "Cet équipement est déjà assigné pour ce créneau"

ÉTAPE 3 : Vérifier dans Firestore
3.1. Aller dans Firestore Console
3.2. Collection "equipment_assignments"
3.3. ✅ VÉRIFIER : Une seule assignment pour la voile V1, cette date, ce slot
```

**Résultat attendu :**
- ✅ Un seul admin réussit à assigner la voile
- ✅ L'autre admin reçoit une erreur
- ✅ Une seule assignment dans Firestore

**Si le test échoue :**
- Les deux admins réussissent → Race condition non corrigée !
- Deux assignments dans Firestore → Bug majeur !
- Prendre une capture d'écran et signaler le bug

---

### Test 5 : Conflit de slot (bookEquipmentAtomically)

**Objectif :** Vérifier qu'on ne peut pas réserver un équipement déjà réservé sur un créneau conflictuel.

**Pré-requis :**
- Avoir 2 comptes élèves
- Avoir 1 voile disponible

**Scénario :**

```
ÉTAPE 1 : Réserver en full_day
1.1. Élève A : "Réserver du matériel"
1.2. Date : 25 mars 2026
1.3. Slot : "Journée complète" (full_day)
1.4. Choisir la voile V1
1.5. Cliquer sur "Réserver"
1.6. ✅ VÉRIFIER : Réservation confirmée

ÉTAPE 2 : Tenter de réserver en morning (conflit)
2.1. Élève B : "Réserver du matériel"
2.2. Date : 25 mars 2026 (MÊME date)
2.3. Slot : "Matin" (morning)
2.4. Choisir la MÊME voile V1
2.5. Cliquer sur "Réserver"
2.6. ✅ VÉRIFIER : La réservation ÉCHOUE
2.7. ✅ VÉRIFIER : Message d'erreur "Créneau déjà réservé" ou similaire

ÉTAPE 3 : Vérifier dans Firestore
3.1. Collection "equipment_bookings"
3.2. ✅ VÉRIFIER : Une seule réservation pour la voile V1, cette date
```

**Résultat attendu :**
- ✅ La réservation de l'élève B échoue
- ✅ Message d'erreur clair
- ✅ Une seule réservation dans Firestore

**Si le test échoue :**
- La réservation de B réussit → Bug majeur !
- Deux réservation dans Firestore → Bug majeur !
- Prendre une capture d'écran et signaler le bug

---

### Test 6 : Conflit de slot (assignEquipment)

**Objectif :** Vérifier que deux séances différentes ne peuvent pas assigner la même voile le même matin.

**Pré-requis :**
- Avoir un compte admin/moniteur
- Avoir 2 séances différentes le même matin
- Avoir 1 voile disponible

**Scénario :**

```
ÉTAPE 1 : Assigner la voile à la séance A
1.1. Admin : Assignment Screen
1.2. Séance A (10 mars matin, Moniteur X)
1.3. Choisir la voile V1
1.4. Cliquer sur "Assigner"
1.5. ✅ VÉRIFIER : Assignment confirmée

ÉTAPE 2 : Tenter d'assigner la même voile à la séance B
2.1. Admin : Assignment Screen
2.2. Séance B (10 mars matin, Moniteur Y) - MÊME DATE, MÊME SLOT
2.3. Choisir la MÊME voile V1
2.4. Cliquer sur "Assigner"
2.5. ✅ VÉRIFIER : Assignment ÉCHOUE
2.6. ✅ VÉRIFIER : Message d'erreur "Cet équipement est déjà assigné pour ce créneau"

ÉTAPE 3 : Vérifier dans Firestore
3.1. Collection "equipment_assignments"
3.2. Filtrer par equipment_id = V1, date_string = "2026-03-10", slot = "morning"
3.3. ✅ VÉRIFIER : Une seule assignment
```

**Résultat attendu :**
- ✅ La deuxième assignment échoue
- ✅ Message d'erreur clair
- ✅ Une seule assignment dans Firestore

**Si le test échoue :**
- La deuxième assignment réussit → Bug majeur !
- Deux assignments dans Firestore → Bug majeur !
- Prendre une capture d'écran et signaler le bug

---

## 📊 RÉSULTATS DES TESTS

### Template de rapport

```
## Résultats des tests manuels

**Date des tests :** [DATE]
**Testeur :** [NOM]
**Version de l'application :** [VERSION]

### Test 1 : full_day vs morning/afternoon
- [ ] ✅ PASS
- [ ] ❌ FAIL
- Commentaires : [Si échec, décrire le problème]

### Test 2 : morning vs afternoon
- [ ] ✅ PASS
- [ ] ❌ FAIL
- Commentaires : [Si échec, décrire le problème]

### Test 3 : Migration des statuts
- [ ] ✅ PASS
- [ ] ❌ FAIL
- Commentaires : [Si échec, décrire le problème]

### Test 4 : Race condition assignEquipment
- [ ] ✅ PASS
- [ ] ❌ FAIL
- [ ] ⚠️ NON TESTÉ (si impossible à tester)
- Commentaires : [Si échec, décrire le problème]

### Test 5 : Conflit de slot (booking)
- [ ] ✅ PASS
- [ ] ❌ FAIL
- Commentaires : [Si échec, décrire le problème]

### Test 6 : Conflit de slot (assignment)
- [ ] ✅ PASS
- [ ] ❌ FAIL
- [ ] ⚠️ NON TESTÉ (si impossible à tester)
- Commentaires : [Si échec, décrire le problème]

## Bugs découverts

### Bug #1
- **Test :** [Numéro du test]
- **Description :** [Description détaillée]
- **Capture d'écran :** [Si disponible]
- **Gravité :** 🔴 Critique / ⚠️ Majeur / 💡 Mineur

### Bug #2
- **Test :** [Numéro du test]
- **Description :** [Description détaillée]
- **Capture d'écran :** [Si disponible]
- **Gravité :** 🔴 Critique / ⚠️ Majeur / 💡 Mineur
```

---

## 🎯 CRITÈRES D'ACCEPTATION

Pour que les corrections soient considérées comme validées :

### Critères obligatoires (Priorité 1)
- [ ] **Test 1 :** ✅ PASS
- [ ] **Test 2 :** ✅ PASS
- [ ] **Test 3 :** ✅ PASS

### Critères recommandés (Priorité 2)
- [ ] **Test 4 :** ✅ PASS (ou ⚠️ NON TESTÉ si impossible)
- [ ] **Test 5 :** ✅ PASS
- [ ] **Test 6 :** ✅ PASS (ou ⚠️ NON TESTÉ si impossible)

### Critères optionnels (Priorité 3)
- [ ] Aucun bug critique découvert
- [ ] Aucun bug majeur découvert
- [ ] Les bugs mineurs sont documentés

---

## 📞 EN CAS DE PROBLÈME

Si un test échoue :

1. **Ne pas paniquer** - C'est pour ça qu'on teste !
2. **Prendre une capture d'écran** de l'erreur
3. **Noter les étapes exactes** pour reproduire le bug
4. **Vérifier dans Firestore** si les données sont correctes
5. **Remplir le rapport de bug** (section "Bugs découverts" ci-dessus)
6. **Signaler le bug** pour correction

---

**Document créé le :** 4 mars 2026
**À compléter après les tests manuels**
