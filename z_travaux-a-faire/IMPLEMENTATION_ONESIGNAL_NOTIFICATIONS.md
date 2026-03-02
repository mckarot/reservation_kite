# 📱 Implémentation des Notifications Push avec OneSignal

**Document de référence pour l'implémentation des notifications push avec OneSignal**

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'ensemble](#1-vue-densemble)
2. [Pourquoi OneSignal ?](#2-pourquoi-onesignal-)
3. [Prérequis](#3-prérequis)
4. [Configuration OneSignal](#4-configuration-onesignal)
5. [Installation des dépendances](#5-installation-des-dépendances)
6. [Configuration Android](#6-configuration-android)
7. [Configuration iOS](#7-configuration-ios)
8. [Implémentation du code](#8-implémentation-du-code)
9. [Intégration avec le système existant](#9-intégration-avec-le-système-existant)
10. [Dashboard OneSignal](#10-dashboard-onesignal)
11. [Tests et validation](#11-tests-et-validation)
12. [Checklist de déploiement](#12-checklist-de-déploiement)

---

## 1. VUE D'ENSEMBLE

### Objectif
Permettre l'envoi de notifications push aux utilisateurs **même lorsque l'application est fermée**, avec une configuration **plus simple que Firebase** :
- ✅ Confirmations de réservation
- ✅ Rappels de cours (1h avant)
- ✅ Annulations de session
- ✅ Nouvelles notifications dans le centre de notifications

### Architecture cible
```
┌─────────────────────────────────────────────────────────────┐
│  BookingNotifier / Admin Action                             │
│         ↓                                                   │
│  NotificationNotifier.sendNotification()                    │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ Firestore (collection: notifications)        │           │
│  └──────────────────────────────────────────────┘           │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ OneSignal API / Cloud Function               │           │
│  │ → Envoie via OneSignal SDK                   │           │
│  └──────────────────────────────────────────────┘           │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ OneSignal Servers                            │           │
│  └──────────────────────────────────────────────┘           │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ Téléphone (app ouverte OU fermée)            │           │
│  │ → Notification dans la barre d'état          │           │
│  └──────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

### Coût estimé
- **OneSignal** : Gratuit jusqu'à **10 000 utilisateurs** (illimité en notifications)
- **Firestore** : Inclus dans le plan gratuit (50k lectures/jour)
- **Cloud Functions** : Optionnel (2M invocations/mois gratuites)

### Avantages vs Firebase
| Critère | Firebase FCM | OneSignal |
|---------|--------------|-----------|
| **Configuration** | 🔴 Complexe (APNs, google-services.json) | 🟢 Simple (App ID uniquement) |
| **Dashboard** | ⚠️ Basique | ✅ Excellent (segmentation, A/B testing) |
| **Prix** | ✅ Gratuit illimité | ✅ Gratuit ≤ 10k users |
| **Documentation** | 🟡 Moyenne | ✅ Excellente |
| **Temps d'intégration** | 4-6 heures | 1-2 heures |

---

## 2. POURQUOI ONESIGNAL ?

### ✅ Points Forts
- **Configuration simplifiée** : Pas de gestion APNs manuelle pour iOS
- **Dashboard puissant** : Segmentation, A/B testing, analytics
- **Multi-plateforme** : iOS, Android, Web, Unity, React Native
- **Gratuit généreux** : 10k utilisateurs, notifications illimitées
- **Conforme RGPD** : Serveurs aux US mais options de confidentialité
- **Fallback automatique** : Gère automatiquement les tokens expirés

### ⚠️ Points de Vigilance
- **Limite gratuite** : 10 000 utilisateurs maximum
- **Service tiers** : Dépendance supplémentaire (mais fiable)
- **Prix au-delà** : ~$9/mois pour 10k-50k users

---

## 3. PRÉREQUIS

### Comptes nécessaires
- [ ] Compte OneSignal (gratuit) → https://onesignal.com
- [ ] Compte Apple Developer (pour iOS, si nécessaire)
- [ ] Projet Flutter fonctionnel

### Connaissances requises
- [ ] Bases de Flutter/Dart
- [ ] Compréhension de Riverpod
- [ ] Familiarité avec Firestore

---

## 4. CONFIGURATION ONESIGNAL

### Étape 4.1 : Créer un compte OneSignal

1. Aller sur [OneSignal.com](https://onesignal.com/)
2. Cliquer sur **Sign Up** (gratuit)
3. Se connecter avec GitHub/Google/Email

### Étape 4.2 : Créer une application

1. Dashboard → **New App**
2. **Create App**
3. Remplir :
   - **App Name** : `reservation_kite`
   - **Select Source** : Flutter
4. Cliquer sur **Next**

### Étape 4.3 : Configurer les plateformes

#### Pour Android :
1. **Google Project Number** : Optionnel (recommandé pour les notifications avancées)
2. **App Package Name** : `com.example.reservation_kite` (ou ton vrai package)
3. **SHA1 Fingerprint** : Optionnel en dev, requis pour prod
   ```bash
   cd android
   ./gradlew signingReport
   ```

#### Pour iOS :
1. **Bundle Identifier** : `com.example.reservation_kite`
2. **Apple Push Notification Key** :
   - Aller sur [Apple Developer](https://developer.apple.com/account/resources/authkeys/list)
   - Créer une clé : **Apple Push Notifications service (APNs)**
   - Télécharger le fichier `.p8`
   - Noter **Key ID** et **Team ID**
   - Uploader dans OneSignal

### Étape 4.4 : Récupérer l'App ID

1. OneSignal Dashboard → **Settings**
2. Section **App Id**
3. Copier l'**App ID** (ex: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)
4. **Garder précieusement** !

---

## 5. INSTALLATION DES DÉPENDANCES

### Étape 5.1 : Ajouter les packages Flutter

**Fichier :** `pubspec.yaml`

```yaml
dependencies:
  # ... dépendances existantes ...

  # Notifications Push avec OneSignal
  onesignal_flutter: ^5.1.4
  flutter_local_notifications: ^16.3.2  # Optionnel (pour notifications locales)
```

### Étape 5.2 : Installer les packages

```bash
flutter pub get
```

### Étape 5.3 : Configuration automatique

```bash
# Android (optionnel)
cd android && ./gradlew clean && cd ..

# iOS (si tu as un Mac - OBLIGATOIRE)
cd ios && pod install && cd ..
```

---

## 6. CONFIGURATION ANDROID

### Étape 6.1 : Modifier `AndroidManifest.xml`

**Fichier :** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Permissions pour les notifications push -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application
        android:label="reservation_kite"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- OneSignal Metadata -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="default" />
        <meta-data
            android:name="com.onesignal.NotificationOpened.DEFAULT"
            android:value="DISABLE" />

        <!-- Receiver pour les notifications locales -->
        <receiver
            android:exported="false"
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver
            android:exported="false"
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>

        <!-- ... reste de la configuration ... -->
    </application>
</manifest>
```

### Étape 6.2 : Modifier `build.gradle` (app)

**Fichier :** `android/app/build.gradle`

```gradle
android {
    defaultConfig {
        // ... configuration existante ...
        minSdkVersion 21  // Requis pour OneSignal
    }
}
```

---

## 7. CONFIGURATION iOS

### Étape 7.1 : Activer les Push Notifications dans Xcode

1. Ouvrir `ios/Runner.xcworkspace` dans Xcode
2. Sélectionner le projet **Runner**
3. Onglet **Signing & Capabilities**
4. Cliquer sur **+ Capability**
5. Ajouter **Push Notifications**
6. Ajouter **Background Modes** → cocher **Remote notifications**

### Étape 7.2 : Modifier `Info.plist`

**Fichier :** `ios/Runner/Info.plist`

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### Étape 7.3 : Configurer les Capabilities (automatique avec Xcode 14+)

Xcode devrait automatiquement ajouter :
- **Push Notifications**
- **Background Modes** → **Remote notifications**

---

## 8. IMPLÉMENTATION DU CODE

### Étape 8.1 : Créer le service OneSignal

**Nouveau fichier :** `lib/services/onesignal_service.dart`

```dart
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/providers/repository_providers.dart';
import '../presentation/providers/auth_state_provider.dart';

part 'onesignal_service.g.dart';

@Riverpod(keepAlive: true)
class OneSignalService extends _$OneSignalService {
  // ⚠️ REMPLACER PAR TON APP ID ONESIGNAL
  static const String _appId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

  @override
  FutureOr<void> build() async {
    await _initializeOneSignal();
  }

  Future<void> _initializeOneSignal() async {
    // Initialiser OneSignal
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(_appId);

    // Demander la permission (iOS 10+, Android 13+)
    OneSignal.Notifications.requestPermission(true);

    // Gérer les notifications en premier plan
    OneSignal.Notifications.addForegroundClickListener((event) {
      _handleNotificationTap(event.notification);
    });

    // Gérer l'ouverture de l'app via notification
    OneSignal.Notifications.addClickListener((event) {
      _handleNotificationTap(event.notification);
    });

    // Récupérer et sauvegarder le token
    await _getAndSaveExternalId();
  }

  void _handleNotificationTap(OSNotification notification) {
    // Logique de navigation
    // Ex: Navigator.push(context, MaterialPageRoute(...))
    print('Notification tap: ${notification.title}');
  }

  /// Récupère l'external ID (OneSignal User ID) et le sauvegarde
  Future<void> _getAndSaveExternalId() async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;

    OneSignal.login(userId);

    // OneSignal gère automatiquement le device token
    print('OneSignal initialized for user: $userId');
  }

  /// Mettre à jour l'external ID au login
  Future<void> updateUser(String userId) async {
    OneSignal.login(userId);
  }

  /// Se déconnecter (logout)
  Future<void> logout() async {
    OneSignal.logout();
  }

  /// Envoyer une notification push à un utilisateur spécifique
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    // Cette méthode appelle ton backend ou Cloud Function
    // OneSignal ne permet pas d'envoyer directement depuis le client
    // pour des raisons de sécurité (nécessite API Key)
    print('Notification request for user $userId: $title');
  }
}
```

### Étape 8.2 : Mettre à jour le modèle User (optionnel)

**Fichier :** `lib/domain/models/user.dart`

```dart
@freezed
class User with _$User {
  const factory User({
    // ... champs existants ...
    @JsonKey(name: 'onesignal_id') String? oneSignalId,  // ← AJOUTER (optionnel)
    // ... reste des champs ...
  }) = _User;

  // ... reste du code ...
}
```

Puis régénérer :
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Étape 8.3 : Initialiser au démarrage de l'app

**Fichier :** `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();

  // Initialiser OneSignal
  final container = ProviderContainer();
  await container.read(oneSignalServiceProvider.notifier).build();

  runApp(UncontrolledProviderScope(container: container, child: const MainApp()));
}
```

### Étape 8.4 : Mettre à jour au login/logout

**Fichier :** `lib/presentation/screens/login_screen.dart`

```dart
Future<void> _login() async {
  // ... code de login existant ...

  // Après succès du login, initialiser OneSignal
  if (mounted && user != null) {
    await ref.read(oneSignalServiceProvider.notifier).updateUser(user!.id);
  }
}
```

**Fichier :** `lib/presentation/providers/auth_notifier.dart`

```dart
Future<void> logout() async {
  // ... code de logout ...

  // Nettoyer OneSignal
  ref.read(oneSignalServiceProvider.notifier).logout();
}
```

---

## 9. INTÉGRATION AVEC LE SYSTÈME EXISTANT

### Option A : Via Cloud Function (Recommandé)

**Fichier :** `functions/index.js`

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const onesignal = require('onesignal-node');

admin.initializeApp();
const db = admin.firestore();

// Client OneSignal
const client = onesignal.createClient(
  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',  // App ID
  'yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy'   // REST API Key (from OneSignal Settings)
);

// Déclencheur : nouvelle notification dans Firestore
exports.sendPushNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    const userId = notification.userId;

    try {
      // Créer la notification OneSignal
      const response = await client.createNotification({
        contents: { en: notification.message },
        headings: { en: notification.title },
        include_external_user_ids: [userId],
        data: {
          type: notification.type,
          notificationId: snap.id,
        },
        android_channel_id: 'default',
        ios_badgeType: 'Increase',
        ios_badgeCount: 1,
      });

      console.log('OneSignal notification sent:', response.body);
    } catch (error) {
      console.error('Error sending OneSignal notification:', error);
    }

    return null;
  });
```

**Déploiement :**
```bash
cd functions
npm install onesignal-node
firebase deploy --only functions:sendPushNotification
```

### Option B : Via API OneSignal (Direct)

**Fichier :** `lib/services/onesignal_api_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OneSignalApiService {
  static const String _appId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
  static const String _restApiKey = 'yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy';
  static const String _baseUrl = 'https://onesignal.com/api/v1/notifications';

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $_restApiKey',
      },
      body: jsonEncode({
        'app_id': _appId,
        'include_external_user_ids': [userId],
        'contents': {'en': message},
        'headings': {'en': title},
        'data': {'type': 'notification'},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send notification: ${response.body}');
    }
  }
}
```

⚠️ **Attention** : Ne jamais exposer `REST API Key` dans le code client ! Utiliser Cloud Function.

### Étape 9.1 : Modifier `NotificationNotifier`

**Fichier :** `lib/presentation/providers/notification_notifier.dart`

```dart
Future<void> sendNotification({
  required String userId,
  required String title,
  required String message,
  NotificationType type = NotificationType.info,
}) async {
  final notification = AppNotification(
    id: const Uuid().v4(),
    userId: userId,
    title: title,
    message: message,
    type: type,
    timestamp: DateTime.now(),
  );

  final repo = ref.read(notificationRepositoryProvider);
  await repo.saveNotification(notification);  // ← Déclenchera Cloud Function

  // Rafraîchir l'UI
  final currentUserId = ref.read(currentUserProvider).value?.id;
  if (currentUserId == userId) {
    state = AsyncData(await _fetchNotifications(userId));
  }
}
```

### Étape 9.2 : Exemples d'utilisation

**Dans `booking_notifier.dart` :**

```dart
// Confirmation de réservation
await notifNotifier.sendNotification(
  userId: pupilId,
  title: 'Réservation confirmée 🤙',
  message: 'Ton cours de $slot le $date est confirmé avec $instructorName',
  type: NotificationType.success,
);

// Annulation de session
await notifNotifier.sendNotification(
  userId: studentId,
  title: 'Session annulée ⚠️',
  message: 'Ton cours du $date a été annulé. Contacte l\'admin pour reprogrammer.',
  type: NotificationType.alert,
);
```

---

## 10. DASHBOARD ONESIGNAL

### Fonctionnalités disponibles

1. **Messages** → Envoyer des notifications manuelles
2. **Audience** → Voir les utilisateurs, segments
3. **Analytics** → Stats d'ouverture, engagement
4. **Settings** → Clés API, webhooks

### Envoyer une notification manuelle

1. Dashboard → **Messages** → **New Message**
2. **Select Audience** :
   - Tous les utilisateurs
   - Segment spécifique
   - Utilisateur individuel (via External ID)
3. **Write Message** :
   - Title : "Test notification"
   - Message : "This is a test"
4. **Send** ou **Schedule**

### Créer un segment

1. Dashboard → **Audience** → **Segments**
2. **New Segment**
3. Critères :
   - `Session count > 5`
   - `Last session < 7 days`
   - `Tags.role = "student"`

---

## 11. TESTS ET VALIDATION

### Checklist de test

#### Test 1 : Initialisation
- [ ] Lancer l'application
- [ ] Vérifier les logs : `OneSignal initialized`
- [ ] Vérifier dans OneSignal Dashboard → **Audience** → Ton utilisateur apparaît

#### Test 2 : App en premier plan
- [ ] Lancer l'application
- [ ] Envoyer une notification depuis OneSignal Dashboard
- [ ] ✅ La notification apparaît dans la barre d'état
- [ ] ✅ Le son est joué
- [ ] ✅ Le badge est mis à jour

#### Test 3 : App en arrière-plan
- [ ] Lancer l'application
- [ ] Appuyer sur le bouton Home
- [ ] Envoyer une notification depuis OneSignal Dashboard
- [ ] ✅ La notification apparaît dans la barre d'état
- [ ] ✅ Taper sur la notification ouvre l'app

#### Test 4 : App fermée
- [ ] Fermer complètement l'application (swipe away)
- [ ] Envoyer une notification depuis OneSignal Dashboard
- [ ] ✅ La notification apparaît dans la barre d'état
- [ ] ✅ Taper sur la notification ouvre l'app

#### Test 5 : Intégration Firestore
- [ ] Créer une réservation (en tant qu'admin)
- [ ] ✅ Cloud Function se déclenche
- [ ] ✅ L'élève reçoit une notification push
- [ ] ✅ La notification apparaît dans le centre de notifications in-app

### Outils de débogage

```bash
# Voir les logs OneSignal
adb logcat | grep OneSignal  # Android

# iOS
Console.app sur Mac → Filtre : OneSignal

# OneSignal Dashboard
→ Audience → Voir si l'utilisateur est actif
```

---

## 12. CHECKLIST DE DÉPLOIEMENT

### Avant déploiement

- [ ] `flutter analyze` — aucun warning
- [ ] `flutter test` — tous les tests passent
- [ ] Cloud Function déployée : `firebase deploy --only functions`
- [ ] OneSignal App ID configuré
- [ ] Permissions demandées correctement (iOS + Android)

### OneSignal Dashboard

- [ ] App créée et configurée
- [ ] Plateformes Android et iOS ajoutées
- [ ] Clés APNs uploadées (iOS)
- [ ] Cloud Function `sendPushNotification` déployée et active
- [ ] REST API Key sécurisée (jamais dans le code client)

### Tests finaux

- [ ] Test sur appareil physique Android
- [ ] Test sur appareil physique iOS
- [ ] Test avec app ouverte
- [ ] Test avec app fermée
- [ ] Test de navigation après tap sur notification
- [ ] Vérifier Analytics dans OneSignal Dashboard

### Documentation

- [ ] Mettre à jour `README.md` avec les nouvelles fonctionnalités
- [ ] Documenter les nouveaux champs Firestore (`onesignal_id`)

---

## 📞 SUPPORT & RESSOURCES

### Documentation officielle
- [OneSignal Flutter SDK](https://documentation.onesignal.com/docs/flutter-sdk-setup)
- [OneSignal API](https://documentation.onesignal.com/reference/rest-api-overview)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

###常见问题
| Problème | Solution |
|----------|----------|
| Notification ne s'affiche pas | Vérifier les permissions dans les settings du téléphone |
| Utilisateur n'apparaît pas | Vérifier que `OneSignal.login()` est appelé |
| Cloud Function échoue | Vérifier les logs : `firebase functions:log` |
| Badge ne se met pas à jour | Vérifier `ios_badgeType` dans la payload |

---

## 💰 COÛTS & LIMITES

### Plan Gratuit (Starter)
- ✅ **10 000 utilisateurs** maximum
- ✅ **Notifications illimitées**
- ✅ **Dashboard complet**
- ✅ **Segmentation avancée**
- ✅ **A/B Testing**
- ✅ **Analytics de base**

### Plan Payant (Growth) - Au-delà de 10k users
- **10k - 50k users** : ~$9/mois
- **50k - 100k users** : ~$29/mois
- **100k+ users** : ~$79/mois

### Comparaison avec Firebase
| Volume | Firebase FCM | OneSignal |
|--------|--------------|-----------|
| **< 10k users** | Gratuit | Gratuit ⭐ |
| **10k - 50k users** | Gratuit | ~$9/mois |
| **> 50k users** | Gratuit | ~$29+/mois |
| **Configuration** | 4-6h 🔴 | 1-2h 🟢 |
| **Dashboard** | Basique ⚠️ | Excellent ✅ |

---

## 📝 NOTES IMPORTANTES

### Économie de tokens
Pour économiser les tokens lors de la génération avec l'IA :
1. **Copier ce fichier** dans le prompt
2. **Demander étape par étape** (ex: "Commence par l'étape 5.1")
3. **Valider chaque étape** avant de passer à la suivante

### Respect des conventions du projet
- Utiliser **uniquement des diffs** (jamais de fichiers complets)
- Respecter l'architecture **Clean Architecture** (data/domain/presentation)
- Utiliser `FieldValue.serverTimestamp()` pour Firestore
- Ajouter `if (!mounted)` après les `await` avec BuildContext
- Retourner des `AsyncValue` dans les Providers

### Sécurité
- ⚠️ **JAMAIS** exposer la `REST API Key` dans le code client
- ✅ Utiliser **Cloud Functions** pour envoyer les notifications
- ✅ Stocker la clé dans les **variables d'environnement** de Cloud Functions

---

**Dernière mise à jour :** 2 mars 2026
**Version du document :** 1.0
**Statut :** Prêt pour implémentation

---

## 🚀 PROCHAINES ÉTAPES

1. **Créer compte OneSignal** → https://onesignal.com
2. **Créer l'application** dans le dashboard
3. **Copier l'App ID** dans `lib/services/onesignal_service.dart`
4. **Suivre les étapes 5-8** de ce document
5. **Tester** avec une notification manuelle
6. **Déployer** la Cloud Function pour l'intégration automatique

**Temps estimé :** 1-2 heures ⏱️
