# Configuration du Serveur MCP Firebase

Ce document explique comment activer et utiliser le serveur MCP Firebase pour accéder à vos données Firestore.

---

## 📋 Prérequis

- Avoir un projet Firebase configuré
- Être connecté avec `firebase login`
- Avoir les outils Google Cloud installés (`gcloud`)

---

## 🚀 Activation en 4 étapes

### Étape 1 : Vérifier le projet Firebase actif

```bash
firebase projects:list
```

Ou vérifier l'environnement actuel :

```bash
firebase use
```

### Étape 2 : Mettre à jour les composants gcloud

```bash
gcloud components update
```

**Pourquoi ?** Les commandes `gcloud beta services mcp` nécessitent la dernière version des composants.

### Étape 3 : Activer l'API Firestore pour MCP

⚠️ **IMPORTANT** : Il y a **DEUX** activations nécessaires :

#### 3a. Activer l'API Firestore (GCP)
```bash
gcloud services enable firestore.googleapis.com --project=YOUR_PROJECT_ID
```

**Exemple pour ce projet :**
```bash
gcloud services enable firestore.googleapis.com --project=reservation-kite
```

#### 3b. Activer l'accès MCP Firebase (CRITIQUE)
```bash
gcloud beta services mcp enable firestore.googleapis.com --project=YOUR_PROJECT_ID
```

**Exemple pour ce projet :**
```bash
gcloud beta services mcp enable firestore.googleapis.com --project=reservation-kite
```

> 🔴 **NOTE IMPORTANTE** : La commande `gcloud beta services mcp enable` est **DIFFÉRENTE** de `gcloud services enable`. 
> 
> - `gcloud services enable` → Active l'API au niveau GCP
> - `gcloud beta services mcp enable` → Active l'accès **via MCP Firebase Server**
>
> **Les deux sont nécessaires !**

### Étape 4 : Attendre la propagation

⏳ L'activation peut prendre **5 à 10 minutes** pour se propager aux systèmes Google.

---

## ✅ Vérification

Une fois activé, vous pouvez tester l'accès en demandant à l'assistant de :
- Lister vos collections Firestore
- Interroger des documents spécifiques
- Vérifier la configuration du projet

**Test rapide :**
```bash
# Dans l'éditeur, demander à l'assistant :
"Liste les collections Firestore du projet"
```

---

## 🔧 Commandes Utiles

| Commande | Description |
|----------|-------------|
| `firebase login` | Se connecter à Firebase |
| `firebase logout` | Se déconnecter |
| `firebase projects:list` | Lister les projets disponibles |
| `firebase use <project_id>` | Changer de projet actif |
| `gcloud services list --project=<id>` | Lister les API activées (GCP) |
| `gcloud beta services mcp list --project=<id>` | Lister les API activées pour MCP |

---

## 🛠️ Dépannage

### Erreur : "API not enabled" ou "disabled via MCP policy"

```
Cloud Firestore API has not been used in project XXX before or it is disabled via MCP policy.
Enable it by running gcloud command: `gcloud beta services mcp enable firestore.googleapis.com --project=XXX`
```

**Cause :** L'accès MCP Firebase n'est pas activé (même si l'API GCP l'est).

**Solution :**
```bash
# 1. Mettre à jour les composants gcloud
gcloud components update

# 2. Activer l'API Firestore pour MCP (CRITIQUE)
gcloud beta services mcp enable firestore.googleapis.com --project=YOUR_PROJECT_ID

# 3. Attendre 5-10 minutes

# 4. Reconnecter le serveur MCP dans l'éditeur
firebase logout
firebase login
```

**Vérification :**
```bash
# Vérifier que l'API est bien activée pour MCP
gcloud beta services mcp list --project=YOUR_PROJECT_ID
```

---

### Erreur : "Permission denied"

**Cause :** Votre compte n'a pas les droits sur le projet.

**Solution :** Demander l'accès au propriétaire du projet ou utiliser un compte avec les droits appropriés.

---

### Erreur : "gcloud command not found"

**Solution :** Installer Google Cloud SDK :
- macOS : `brew install --cask google-cloud-sdk`
- Linux : [Documentation officielle](https://cloud.google.com/sdk/docs/install)
- Windows : [Documentation officielle](https://cloud.google.com/sdk/docs/install)

---

### Erreur : "gcloud beta services mcp: command not found"

**Cause :** Composants gcloud obsolètes.

**Solution :**
```bash
gcloud components update
```

Puis réessayer :
```bash
gcloud beta services mcp enable firestore.googleapis.com --project=YOUR_PROJECT_ID
```

---

### Erreur : "Failed to connect to MCP Firebase Server"

**Cause :** Le serveur MCP dans l'éditeur n'est pas reconnecté après activation.

**Solution :**
1. **Dans l'éditeur (Antigravity/VS Code/Cursor)** :
   - Redémarrer le serveur MCP Firebase
   - Ou redémarrer l'éditeur complètement

2. **Reconnexion manuelle** :
   ```bash
   firebase logout
   firebase login
   ```

3. **Vérifier la configuration MCP** (si applicable) :
   ```json
   {
     "mcpServers": {
       "firebase": {
         "command": "npx",
         "args": ["-y", "firebase-tools@latest", "mcp"]
       }
     }
   }
   ```

---

## 📋 Checklist d'activation complète

- [ ] `gcloud components update` ✅
- [ ] `gcloud services enable firestore.googleapis.com --project=XXX` ✅
- [ ] `gcloud beta services mcp enable firestore.googleapis.com --project=XXX` ✅
- [ ] Attendre 5-10 minutes ⏳
- [ ] `firebase login` ✅
- [ ] Redémarrer le serveur MCP dans l'éditeur ✅
- [ ] Tester l'accès Firestore ✅

---

## 📚 Ressources

- [Documentation Firebase MCP](https://firebase.google.com/docs)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Firestore Dashboard](https://console.firebase.google.com/project/_/firestore)
- [gcloud beta services mcp](https://cloud.google.com/sdk/gcloud/reference/beta/services/mcp)

---

## 📝 Notes

### Projet actuel
- **Project ID** : `reservation-kite`
- **User authentifié** : `mckarot2@gmail.com`
- **API requises** : Firestore API, MCP Firebase Access

### Historique des activations
| Date | Action | Statut |
|------|--------|--------|
| 2026-03-05 | `gcloud services enable firestore.googleapis.com` | ✅ |
| 2026-03-05 | `gcloud beta services mcp enable firestore.googleapis.com` | ✅ |
| 2026-03-05 | MCP Firebase Server opérationnel | ✅ |

### Collections Firestore disponibles
- `admins` (2 docs)
- `credit_packs` (3 docs)
- `equipment_categories` (6 docs)
- `equipment_items` (2 docs)
- `equipment_rentals` (2 docs)
- `notifications` (~15 docs)
- `reservations` (~10 docs)
- `settings` (2 docs)
- `staff` (1 doc)
- `users` (4 docs)

---

**Dernière mise à jour** : 2026-03-05  
**Statut** : 🟢 MCP Firebase Server opérationnel
