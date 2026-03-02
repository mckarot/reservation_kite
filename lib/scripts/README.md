# 🔧 Scripts d'Initialisation Firebase

## 📖 Vue d'ensemble

Ce dossier contient des scripts utilitaires pour initialiser et configurer Firebase pendant le développement.

---

## 🚀 Script d'Initialisation (`firebase_init_script.dart`)

### Fonctionnalités

Le script crée automatiquement :

| Collection | Document | Données créées |
|------------|----------|----------------|
| `admins` | `{uid}` | Document admin pour l'utilisateur connecté |
| `settings` | `school_config` | Paramètres de l'école (horaires, capacité, etc.) |
| `settings` | `theme_config` | Configuration du thème (couleurs) |
| `credit_packs` | (nouveaux) | 4 packs de crédits par défaut |

### Utilisation

#### Via l'interface (Recommandé)

1. **Ouvre l'application Flutter**
2. **Va à l'écran de login**
3. **Connecte-toi** avec un compte admin (ex: `admin@mail.com`)
4. **Scrolle tout en bas** de l'écran
5. **Clique sur le bouton "🔧 Init Firebase (DEV)"**
6. **Attends** la confirmation

![Bouton d'initialisation](../docs/images/firebase_init_button.png)

#### Logs d'initialisation

Après l'exécution, tu peux voir les logs détaillés :
- ✅ Opérations réussies
- ⚠️ Avertissements (déjà existant)
- ❌ Erreurs

Clique sur **"Voir les logs"** pour afficher le détail.

---

## 📦 Packs de Crédits par Défaut

Le script crée ces packs :

| Nom | Crédits | Prix (€) |
|-----|---------|----------|
| Pack Découverte | 1 | 50 € |
| Pack Progression | 5 | 225 € |
| Pack Passion | 10 | 400 € |
| Pack Illimité | 20 | 700 € |

---

## ⚠️ Avertissements

### Usage : Développement Uniquement

Ce script est conçu pour le **développement et les tests**. Ne pas utiliser en production.

### Données Existantes

Le script **n'écrase pas** les documents existants :
- Si un document existe déjà, il est ignoré
- Un message "⚠️ Existe déjà" est affiché dans les logs

### Sécurité

Le bouton d'initialisation :
- ✅ Crée un admin pour l'utilisateur **connecté**
- ✅ Nécessite une authentification Firebase
- ❌ Ne doit pas être accessible en production

---

## 🔒 Retirer le Bouton en Production

Pour retirer le bouton d'initialisation en production :

### Option 1: Condition Debug

```dart
// Dans login_screen.dart
if (kDebugMode) ...[
  const SizedBox(height: 8),
  const FirebaseInitButton(),
],
```

### Option 2: Supprimer Complètement

Supprime ces lignes de `login_screen.dart` :
```dart
// BOUTON D'INITIALISATION FIREBASE (DEBUG ONLY)
const SizedBox(height: 24),
const Divider(),
// ... (lignes 229-242)
const FirebaseInitButton(),
```

Et supprime l'import :
```dart
import '../../scripts/firebase_init_script.dart';
```

---

## 🧹 Nettoyer les Données d'Initialisation

Si tu veux supprimer les données créées par le script :

### Via Firebase Console

1. https://console.firebase.google.com/project/reservation-kite/firestore/data
2. Supprime les collections :
   - `admins` (sauf si tu veux garder les admins)
   - `settings` (school_config, theme_config)
   - `credit_packs` (si créés par le script)

### Via Script

Crée un script de nettoyage (à venir).

---

## 📚 Fichiers Liés

| Fichier | Description |
|---------|-------------|
| `firebase_init_script.dart` | Script d'initialisation |
| `login_screen.dart` | Écran de login avec bouton |
| `FIRESTORE_SECURITY_RULES.md` | Documentation des règles de sécurité |
| `firestore.rules` | Règles Firestore déployées |

---

## 🐛 Dépannage

### "Aucun utilisateur connecté"

**Problème :** Tu dois être connecté pour initialiser.

**Solution :**
1. Entre un email et mot de passe valides
2. Clique sur "Se connecter"
3. Une fois connecté, clique sur "Init Firebase"

### "Permission denied"

**Problème :** Les règles de sécurité bloquent l'écriture.

**Solution :**
1. Vérifie que les règles sont déployées : `firebase deploy --only firestore:rules`
2. Ou utilise les règles de développement (ouvertes) temporairement

### Le bouton n'apparaît pas

**Problème :** L'import est manquant ou le widget n'est pas dans l'arbre.

**Solution :**
1. Vérifie l'import dans `login_screen.dart` :
   ```dart
   import '../../scripts/firebase_init_script.dart';
   ```
2. Vérifie que le widget est ajouté dans le `Column`

---

**Dernière mise à jour :** 2 mars 2026  
**Version :** 1.0
