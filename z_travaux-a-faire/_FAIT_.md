# 🔥 CONFIGURATION FIREBASE - THÈME GLOBAL

## Collection : `settings`

### Document : `theme_config`

**Structure :**
```json
{
  "primaryColor": 4280833746,
  "secondaryColor": 4282537461,
  "accentColor": 4278234324,
  "version": 1,
  "updatedBy": "user_id_here",
  "updatedAt": Timestamp
}
```

**Description :**
- `primaryColor` : Couleur principale (int, valeur ARGB)
- `secondaryColor` : Couleur secondaire (int, valeur ARGB)
- `accentColor` : Couleur d'accent (int, valeur ARGB)
- `version` : Version du thème (incrémentée à chaque changement)
- `updatedBy` : ID de l'utilisateur qui a fait la dernière modification
- `updatedAt` : Date de dernière modification

---

## 🔒 RÈGLES DE SÉCURITÉ FIRESTORE

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Collection settings
    match /settings/{document} {
      
      // Document theme_config
      match /theme_config {
        // Lecture : Tout le monde peut lire (pour récupérer les couleurs)
        allow read: if true;
        
        // Écriture : Admin seulement
        allow write: if request.auth != null 
                      && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
        
        // Création : Admin seulement
        allow create: if request.auth != null 
                       && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
        
        // Mise à jour : Admin seulement
        allow update: if request.auth != null 
                       && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
        
        // Suppression : Admin seulement (pour reset)
        allow delete: if request.auth != null 
                       && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
      }
    }
  }
}
```

---

## 📝 CRÉATION MANUELLE (Première fois)

### Via Firebase Console :

1. Aller dans **Firestore Database**
2. Créer la collection `settings`
3. Créer le document `theme_config`
4. Ajouter les champs :

| Champ | Type | Valeur |
|-------|------|--------|
| `primaryColor` | number | `4280833746` (0xFF1976D2) |
| `secondaryColor` | number | `4282537461` (0xFF42A5F5) |
| `accentColor` | number | `4278234324` (0xFF00BCD4) |
| `version` | number | `1` |
| `updatedBy` | string | `"system"` |
| `updatedAt` | timestamp | `[Date actuelle]` |

### Via Script :

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createDefaultThemeConfig() async {
  await FirebaseFirestore.instance.collection('settings').doc('theme_config').set({
    'primaryColor': 0xFF1976D2,
    'secondaryColor': 0xFF42A5F5,
    'accentColor': 0xFF00BCD4,
    'version': 1,
    'updatedBy': 'system',
    'updatedAt': FieldValue.serverTimestamp(),
  });
  print('✅ Theme config créé !');
}
```

---

## 🔄 FLUX DE DONNÉES

### **Lecture (Tous les utilisateurs) :**
```
1. Ouvrir l'app
2. Lire version depuis Firestore (léger)
3. Si version != cache local → Lire config complète
4. Sinon → Utiliser cache (0 lecture)
5. Stream écoute les changements (optionnel)
```

### **Écriture (Admin seulement) :**
```
1. Admin change une couleur
2. Incrémenter version automatiquement
3. Écrire dans Firestore
4. TOUS les appareils reçoivent le changement (stream)
5. Cache local mis à jour
```

---

## 💰 COÛTS ESTIMÉS

### **Pour 1000 utilisateurs :**
- Lectures : ~1000/mois (version check) + ~100/mois (changements) = **~0.01$/mois**
- Écritures : ~1/mois (admin) = **NÉGLIGEABLE**

### **Pour 100 000 utilisateurs :**
- Lectures : ~100 000/mois + ~10 000/mois = **~1.00$/mois**
- Écritures : ~1/mois = **NÉGLIGEABLE**

### **Free Tier :**
- 50 000 lectures/jour = **1 500 000 lectures/mois GRATUIT**
- Suffisant pour **~50 000 utilisateurs actifs/jour**

---

## 🎯 OPTIMISATIONS IMPLÉMENTÉES

1. ✅ **Versioning** : Vérifier version avant de lire config complète
2. ✅ **Cache local** : SharedPreferences pour éviter lectures inutiles
3. ✅ **Stream** : Écoute les changements en temps réel (optionnel)
4. ✅ **Lecture légère** : Version = entier (pas de gros document)

---

## 🧪 TESTER

1. **En tant qu'admin** :
   - Aller dans Paramètres → Apparence
   - Changer une couleur
   - Vérifier que `version` est incrémentée dans Firestore

2. **En tant qu'utilisateur** :
   - Ouvrir l'app (avec cache vide)
   - Vérifier que les couleurs par défaut s'affichent
   - Attendre qu'un admin change les couleurs
   - Vérifier que l'app se met à jour automatiquement (stream)

---

**Document créé le :** 2026-02-28
**Version :** 1.0
