# 📱 Implémentation des Notifications Push - Plan Détaillé

**Document de référence pour l'implémentation des notifications push avec Firebase Cloud Messaging (FCM)**

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'ensemble](#1-vue-densemble)
2. [Prérequis](#2-prérequis)
3. [Configuration Firebase](#3-configuration-firebase)
4. [Installation des dépendances](#4-installation-des-dépendances)
5. [Configuration Android](#5-configuration-android)
6. [Configuration iOS](#6-configuration-ios)
7. [Implémentation du code](#7-implémentation-du-code)
8. [Intégration avec le système existant](#8-intégration-avec-le-système-existant)
9. [Tests et validation](#9-tests-et-validation)
10. [Checklist de déploiement](#10-checklist-de-déploiement)

---

## 1. VUE D'ENSEMBLE

### Objectif
Permettre l'envoi de notifications push aux utilisateurs **même lorsque l'application est fermée**, pour :
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
│  │ Firebase Cloud Functions (trigger onCreate)  │           │
│  │ → Envoie via FCM                             │           │
│  └──────────────────────────────────────────────┘           │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ Firebase Cloud Messaging (FCM)               │           │
│  └──────────────────────────────────────────────┘           │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ Téléphone (app ouverte OU fermée)            │           │
│  │ → Notification dans la barre d'état          │           │
│  └──────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

### Coût estimé
- **FCM** : 100% gratuit (illimité)
- **Firestore** : Inclus dans le plan gratuit (50k lectures/jour)
- **Cloud Functions** : 2M invocations/mois gratuites

---

## 2. PRÉREQUIS

### Comptes nécessaires
- [ ] Compte Firebase actif
- [ ] Accès à la Firebase Console
- [ ] Projet Flutter fonctionnel

### Connaissances requises
- [ ] Bases de Flutter/Dart
- [ ] Compréhension de Riverpod
- [ ] Familiarité avec Firestore

---

## 3. CONFIGURATION FIREBASE

### Étape 3.1 : Activer Cloud Messaging dans Firebase Console

1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionner le projet `reservation_kite`
3. Menu de gauche → **Engage** → **Cloud Messaging**
4. Cliquer sur **Get started** (si pas déjà activé)

### Étape 3.2 : Générer les clés d'authentification

#### Pour Android :
- Rien à faire (utilise automatiquement `google-services.json`)

#### Pour iOS :
1. Firebase Console → **Project Settings** (roue dentée)
2. Onglet **Cloud Messaging**
3. Section **iOS app configuration** → **Upload your APNs authentication key**
4. Créer une clé sur [Apple Developer](https://developer.apple.com/account/resources/authkeys/list) :
   - Key Type : **Apple Push Notifications service (APNs)**
   - Télécharger le fichier `.p8`
   - Noter le **Key ID** et **Team ID**
5. Uploader le fichier `.p8` dans Firebase Console

### Étape 3.3 : Créer les Cloud Functions (optionnel mais recommandé)

**Fichier :** `functions/index.js`

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// Déclencheur : nouvelle notification dans Firestore
exports.sendPushNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    const userId = notification.userId;
    
    // Récupérer le FCM token de l'utilisateur
    const userDoc = await db.collection('users').doc(userId).get();
    const fcmToken = userDoc.data()?.fcmToken;
    
    if (!fcmToken) {
      console.log('No FCM token for user:', userId);
      return null;
    }
    
    // Configurer la notification
    const message = {
      notification: {
        title: notification.title,
        body: notification.message,
      },
      data: {
        type: notification.type,
        notificationId: snap.id,
      },
      token: fcmToken,
      android: {
        priority: 'high',
        notification: {
          sound: 'default',
          channelId: 'default',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };
    
    try {
      await admin.messaging().send(message);
      console.log('Push notification sent successfully');
    } catch (error) {
      console.error('Error sending push notification:', error);
    }
    
    return null;
  });
```

**Déploiement :**
```bash
cd functions
npm install
firebase deploy --only functions:sendPushNotification
```

---

## 4. INSTALLATION DES DÉPENDANCES

### Étape 4.1 : Ajouter les packages Flutter

**Fichier :** `pubspec.yaml`

```yaml
dependencies:
  # ... dépendances existantes ...
  
  # Notifications Push
  firebase_messaging: ^14.7.9
  flutter_local_notifications: ^16.3.2
```

### Étape 4.2 : Installer les packages

```bash
flutter pub get
```

### Étape 4.3 : Configuration automatique

```bash
# Android
cd android && ./gradlew clean && cd ..

# iOS (si tu as un Mac)
cd ios && pod install && cd ..
```

---

## 5. CONFIGURATION ANDROID

### Étape 5.1 : Modifier `AndroidManifest.xml`

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
        
        <!-- Configuration Firebase Messaging -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="default" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_sound"
            android:resource="@raw/default_sound" />
        
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

### Étape 5.2 : Modifier `build.gradle` (app)

**Fichier :** `android/app/build.gradle`

```gradle
android {
    defaultConfig {
        // ... configuration existante ...
        minSdkVersion 21  // Requis pour firebase_messaging
    }
}
```

---

## 6. CONFIGURATION iOS

### Étape 6.1 : Activer les Push Notifications dans Xcode

1. Ouvrir `ios/Runner.xcworkspace` dans Xcode
2. Sélectionner le projet **Runner**
3. Onglet **Signing & Capabilities**
4. Cliquer sur **+ Capability**
5. Ajouter **Push Notifications**
6. Ajouter **Background Modes** → cocher **Remote notifications**

### Étape 6.2 : Modifier `Info.plist`

**Fichier :** `ios/Runner/Info.plist`

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

---

## 7. IMPLÉMENTATION DU CODE

### Étape 7.1 : Créer le service de notifications

**Nouveau fichier :** `lib/services/push_notification_service.dart`

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/providers/repository_providers.dart';
import '../presentation/providers/auth_state_provider.dart';

part 'push_notification_service.g.dart';

@Riverpod(keepAlive: true)
class PushNotificationService extends _$PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  @override
  FutureOr<void> build() async {
    await _initializeNotifications();
    await _requestPermissions();
    await _setupMessageHandlers();
  }

  Future<void> _initializeNotifications() async {
    // Configuration Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Configuration iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _requestPermissions() async {
    // Permissions Android 13+
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    // Permissions pour les notifications locales
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _setupMessageHandlers() async {
    // Message quand l'app est en premier plan
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Message quand l'app est en arrière-plan (tap sur notification)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    
    // Vérifier si l'app a été ouverte via une notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
    
    // Token de background (optionnel, pour Cloud Functions)
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessageStatic);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    
    await _showLocalNotification(
      title: notification.title!,
      body: notification.body!,
      payload: message.data.toString(),
    );
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default',
      'Notifications',
      channelDescription: 'Canal par défaut',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Logique à implémenter : navigation vers l'écran approprié
    // Ex: Navigator.push(context, MaterialPageRoute(...))
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Logique à implémenter : navigation vers l'écran approprié
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    _handleNotificationTap(message);
  }

  // Fonction static requise pour onBackgroundMessage
  static Future<void> _handleBackgroundMessageStatic(RemoteMessage message) async {
    // Cette fonction doit être static et top-level
    print('Background message: ${message.notification?.title}');
  }

  /// Récupère et sauvegarde le token FCM
  Future<String?> getAndSaveToken() async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return null;
    
    final token = await _messaging.getToken();
    if (token != null) {
      await ref.read(userRepositoryProvider).updateFcmToken(userId, token);
    }
    return token;
  }

  /// Refresh du token (à appeler au login)
  Future<void> refreshToken() async {
    await _messaging.deleteToken();
    await getAndSaveToken();
  }
}
```

### Étape 7.2 : Mettre à jour le modèle User

**Fichier :** `lib/domain/models/user.dart`

```dart
@freezed
class User with _$User {
  const factory User({
    // ... champs existants ...
    @JsonKey(name: 'fcm_token') String? fcmToken,  // ← AJOUTER
    // ... reste des champs ...
  }) = _User;
  
  // ... reste du code ...
}
```

Puis régénérer :
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Étape 7.3 : Mettre à jour le repository User

**Fichier :** `lib/data/repositories/firebase_user_repository.dart`

```dart
@override
Future<void> updateFcmToken(String userId, String token) async {
  await _firestore.collection('users').doc(userId).update({
    'fcm_token': token,
  });
}
```

### Étape 7.4 : Initialiser au démarrage de l'app

**Fichier :** `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  
  // Initialiser le service de notifications push
  final container = ProviderContainer();
  await container.read(pushNotificationServiceProvider.notifier).build();
  
  runApp(UncontrolledProviderScope(container: container, child: const MainApp()));
}
```

### Étape 7.5 : Récupérer le token au login

**Fichier :** `lib/presentation/screens/login_screen.dart`

```dart
Future<void> _login() async {
  // ... code de login existant ...
  
  // Après succès du login, récupérer le token FCM
  if (mounted) {
    await ref.read(pushNotificationServiceProvider.notifier).getAndSaveToken();
  }
}
```

---

## 8. INTÉGRATION AVEC LE SYSTÈME EXISTANT

### Étape 8.1 : Modifier `NotificationNotifier`

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

### Étape 8.2 : Exemples d'utilisation

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

## 9. TESTS ET VALIDATION

### Checklist de test

#### Test 1 : App en premier plan
- [ ] Lancer l'application
- [ ] Depuis Firebase Console → Cloud Messaging → **New notification**
- [ ] Envoyer une notification à l'appareil de test
- [ ] ✅ La notification apparaît dans la barre d'état
- [ ] ✅ Le son est joué
- [ ] ✅ Le badge est mis à jour

#### Test 2 : App en arrière-plan
- [ ] Lancer l'application
- [ ] Appuyer sur le bouton Home
- [ ] Envoyer une notification depuis Firebase Console
- [ ] ✅ La notification apparaît dans la barre d'état
- [ ] ✅ Taper sur la notification ouvre l'app

#### Test 3 : App fermée
- [ ] Fermer complètement l'application (swipe away)
- [ ] Envoyer une notification depuis Firebase Console
- [ ] ✅ La notification apparaît dans la barre d'état
- [ ] ✅ Taper sur la notification ouvre l'app

#### Test 4 : Intégration Firestore
- [ ] Créer une réservation (en tant qu'admin)
- [ ] ✅ L'élève reçoit une notification push
- [ ] ✅ La notification apparaît dans le centre de notifications in-app

### Outils de débogage

```bash
# Voir les logs Firebase Messaging
adb logcat | grep FirebaseMsg  # Android

# iOS
Console.app sur Mac → Filtre : Firebase
```

---

## 10. CHECKLIST DE DÉPLOIEMENT

### Avant déploiement

- [ ] `flutter analyze` — aucun warning
- [ ] `flutter test` — tous les tests passent
- [ ] Cloud Function déployée : `firebase deploy --only functions`
- [ ] Tokens FCM sauvegardés dans Firestore pour tous les utilisateurs
- [ ] Permissions demandées correctement (iOS + Android)

### Firebase Console

- [ ] Cloud Messaging activé
- [ ] Clés APNs uploadées (iOS)
- [ ] Cloud Function `sendPushNotification` déployée et active

### Tests finaux

- [ ] Test sur appareil physique Android
- [ ] Test sur appareil physique iOS
- [ ] Test avec app ouverte
- [ ] Test avec app fermée
- [ ] Test de navigation après tap sur notification

### Documentation

- [ ] Mettre à jour `README.md` avec les nouvelles fonctionnalités
- [ ] Documenter les nouveaux champs Firestore (`fcm_token`)

---

## 📞 SUPPORT & RESSOURCES

### Documentation officielle
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)

###常见问题
| Problème | Solution |
|----------|----------|
| Notification ne s'affiche pas | Vérifier les permissions dans les settings du téléphone |
| Token FCM null | Vérifier que Google Services est configuré |
| Cloud Function ne se déclenche pas | Vérifier les logs dans Firebase Console → Functions |

---

## 📝 NOTES IMPORTANTES

### Économie de tokens
Pour économiser les tokens lors de la génération avec l'IA :
1. **Copier ce fichier** dans le prompt
2. **Demander étape par étape** (ex: "Commence par l'étape 4.1")
3. **Valider chaque étape** avant de passer à la suivante

### Respect des conventions du projet
- Utiliser **uniquement des diffs** (jamais de fichiers complets)
- Respecter l'architecture **Clean Architecture** (data/domain/presentation)
- Utiliser `FieldValue.serverTimestamp()` pour Firestore
- Ajouter `if (!mounted)` après les `await` avec BuildContext
- Retourner des `AsyncValue` dans les Providers

---

**Dernière mise à jour :** 2026-02-26  
**Version du document :** 1.0  
**Statut :** Prêt pour implémentation
