# Configuration des serveurs MCP pour Qwen Code

## Serveurs configurés

| Serveur | Statut | Commande |
|---------|--------|----------|
| **Dart/Flutter** | ✅ Connecté | `dart mcp-server` |
| **Firebase** | ✅ Configuré | `npx -y firebase-tools@latest mcp` |

---

## 1. Serveur MCP Dart

### Problème rencontré

Le serveur MCP Dart apparaissait comme **déconnecté** (`🔴 dart - Disconnected`) car :
- Le chemin vers Dart était incorrect (`/opt/homebrew/bin/dart` n'existe pas)
- Dart est installé via Flutter à `/Users/mathieu/development/flutter/bin/dart`

### Configuration

**Vérifier l'installation de Dart :**

```bash
which dart
# Résultat attendu : /Users/mathieu/development/flutter/bin/dart
```

**Vérifier la version de Dart (3.9+ requis) :**

```bash
dart --version
# Résultat attendu : Dart SDK version 3.10.x ou supérieur
```

**Fichier : `.qwen/settings.json`**

```json
{
  "mcpServers": {
    "dart": {
      "command": "/Users/mathieu/development/flutter/bin/dart",
      "args": ["mcp-server"],
      "timeout": 30000
    }
  }
}
```

### Fonctionnalités

- Analyser et corriger les erreurs de code
- Résoudre les symboles et fetch documentation
- Introspecter les applications Flutter en cours d'exécution
- Rechercher des packages sur pub.dev
- Gérer les dépendances dans `pubspec.yaml`
- Exécuter et analyser les tests
- Formater le code (`dart format`)

---

## 2. Serveur MCP Firebase

### Configuration

**Prérequis :** Node.js (déjà installé)

**Fichier : `.qwen/settings.json`**

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

### Fonctionnalités

| Catégorie | Outils |
|-----------|--------|
| **Core** | `firebase_login`, `firebase_get_project`, `firebase_list_projects` |
| **Firestore** | `firestore_get_documents`, `firestore_query_collection`, `firestore_list_collections` |
| **Auth** | `auth_get_users`, `auth_update_user` |
| **Crashlytics** | `crashlytics_get_top_issues`, `crashlytics_get_issue` |
| **Functions** | `functions_get_logs` |
| **Security Rules** | `firebase_validate_security_rules`, `firebase_get_security_rules` |
| **Hosting** | `firebase_deploy` |

### Authentification

À la première utilisation, exécuter :

```
firebase_login
```

Suivre le flux d'authentification Google.

---

## Configuration complète `.qwen/settings.json`

```json
{
  "mcpServers": {
    "dart": {
      "command": "/Users/mathieu/development/flutter/bin/dart",
      "args": ["mcp-server"],
      "timeout": 30000
    },
    "firebase": {
      "command": "npx",
      "args": ["-y", "firebase-tools@latest", "mcp"]
    }
  },
  "$version": 3
}
```

---

## Commandes utiles

| Commande | Description |
|----------|-------------|
| `/mcp list` | Liste les serveurs MCP configurés |
| `/mcp desc` | Affiche les descriptions des outils |
| `/mcp schema` | Affiche les schémas de paramètres |
| `Ctrl+T` | Basculer l'affichage des descriptions |

---

## Dépannage

### Le serveur Dart reste déconnecté

1. Redémarrer Qwen Code
2. Vérifier que le chemin dans `.qwen/settings.json` correspond au résultat de `which dart`
3. Vérifier que la version de Dart est suffisante : `dart --version`

### Le serveur Firebase reste déconnecté

1. Vérifier que Node.js est installé : `node --version`
2. Vérifier que `npx` est disponible : `which npx`
3. Tester la commande manuellement :
   ```bash
   npx -y firebase-tools@latest mcp --help
   ```
4. S'authentifier si nécessaire : `firebase login`

### Commande `dart mcp-server` inconnue

Mettre à jour Dart/Flutter vers une version récente :

```bash
flutter upgrade
```

---

## Autres serveurs MCP utiles (optionnels)

### Git MCP

**Utilité :** Gérer branches, commits, diffs, status

```json
{
  "git": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-git"]
  }
}
```

### GitHub MCP

**Utilité :** Issues, PRs, reviews GitHub

**Prérequis :** GitHub Personal Access Token

```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "votre_token"
    }
  }
}
```

**Créer un token GitHub :**
1. Aller sur https://github.com/settings/tokens
2. Nouveau token avec scopes : `repo`, `read:user`
3. Copier le token dans `.qwen/settings.json`
