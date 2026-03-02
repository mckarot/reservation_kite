# Flutter Blueprint — Standards d'Architecture & Performance
## Version 2.1 — Production-Ready

---

## 1. VISION ARCHITECTURALE (CLEAN ARCHITECTURE)

L'application est découpée en trois couches strictes, chacune avec des responsabilités non négociables.

### Couches

**Data**
- Repositories (implémentations)
- DTOs + Mappers (jamais d'entités domain dans cette couche)
- Sources : API REST (Dio), base locale (Drift/Isar), cache (Hive)
- Gestion des erreurs réseau → `Failure` typé

**Domain**
- Entities immuables (Freezed)
- Interfaces des Repositories (`abstract class`)
- Use Cases : une classe = une responsabilité = une méthode `call()`
- Pure Dart — zéro dépendance Flutter ou package externe

**Presentation**
- Widgets (UI only, zéro logique métier)
- States (Freezed)
- Notifiers / Controllers (Riverpod)

### Convention de nommage des fichiers

```
lib/
├── core/
│   ├── errors/          # Failures, exceptions
│   ├── network/         # Dio client, interceptors
│   ├── theme/           # AppTheme, AppColors, AppSpacing
│   └── utils/           # Extensions, helpers
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   ├── dtos/
│       │   ├── mappers/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/   # interfaces
│       │   └── usecases/
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── providers/
└── main.dart
```

---

## 2. STATE MANAGEMENT (RIVERPOD ECOSYSTEM)

### Règles fondamentales

- `@riverpod` obligatoire — zéro provider déclaré manuellement
- `ref.watch(provider.select(...))` systématique pour éviter les rebuilds inutiles
- Exposition async via `AsyncValue` — jamais de `FutureBuilder` dans les widgets
- Modèles Freezed uniquement — zéro classe mutable dans les states

### Structure d'un Notifier type

```dart
// ✅ CORRECT
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await ref
        .read(loginUseCaseProvider)
        .call(LoginParams(email: email, password: password));

    state = result.fold(
      (failure) => AuthState.error(failure),
      (user)    => AuthState.authenticated(user),
    );
  }
}

// ✅ Select pour rebuild ciblé
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider.select((s) => s.isLoading));
});
```

### Scoping & Overrides

- Utiliser `ProviderScope` avec `overrides` pour l'injection en tests
- Documenter explicitement le scope de chaque provider (`keepAlive`, `autoDispose`)
- `family` pour les providers paramétrés — clé stable et immutable obligatoire

---

## 3. INGÉNIERIE DE PERFORMANCE

### Objectif : Jank-Free (pas "120 FPS")

L'objectif n'est pas un chiffre arbitraire mais l'**absence de jank** mesurée via Flutter DevTools. Le device doit rester dans sa fenêtre d'affichage native (60/90/120 Hz selon le matériel).

### Règles de build

```dart
// ✅ const partout où c'est possible
const SizedBox(height: AppSpacing.md)
const Divider()
const _HeaderWidget() // widget sans props dynamiques

// ✅ RepaintBoundary pour zones à haute fréquence
RepaintBoundary(
  child: AnimatedProgressBar(value: progress),
)

// ✅ Contraintes fixes pour Relayout Boundaries
SizedBox(
  width: 48,
  height: 48,
  child: UserAvatar(url: url),
)
```

### Isolates — règle correcte

> **Ne pas isoler par défaut. Mesurer d'abord avec DevTools, isoler ensuite.**

Un `Isolate` a un coût fixe (spawn ~1–2ms + sérialisation). La règle des "8ms" est fausse si la tâche est ponctuelle.

**Critères réels pour `compute()` :**
- Traitement répété à haute fréquence (ex: décodage JSON > 50KB dans un flux)
- Tâche CPU-bound dont le profiling confirme qu'elle bloque le UI thread
- Parsing d'image ou transformation de données volumineuses

```dart
// ✅ Seulement si profilé et confirmé bloquant
final items = await compute(_parseItems, rawJson);

List<Item> _parseItems(String json) { /* ... */ }
```

### Shader Warmup

```dart
// main.dart — critique pour éviter les janks au premier rendu
void main() async {
  await Future.wait([
    DeferredWidget.preload(/* ... */),
    // Shader warmup si animations complexes
  ]);
  runApp(ProviderScope(child: App()));
}
```

### Outils de mesure obligatoires

```bash
# Profiling réel (jamais de décisions sur debug build)
flutter run --profile

# Timeline dans DevTools
# → Frame rendering time > 16ms = jank à corriger
# → Raster thread > UI thread = problème GPU/shader
```

---

## 4. RÉSILIENCE & SÉCURITÉ

### Pattern Result

```dart
// core/errors/result.dart
typedef Result<S, F extends Failure> = Either<F, S>;

// Retour systématique dans les repositories et use cases
Future<Result<User, AuthFailure>> login(LoginParams params);

// Consommation dans le Notifier
final result = await loginUseCase(params);
result.fold(
  (failure) => _handleFailure(failure),
  (user)    => _handleSuccess(user),
);
```

### Failures typées

```dart
@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidCredentials() = _InvalidCredentials;
  const factory AuthFailure.networkError(String message) = _NetworkError;
  const factory AuthFailure.serverError(int code) = _ServerError;
  const factory AuthFailure.unauthorized() = _Unauthorized;
}
```

### Transactions

Obligatoires pour toute écriture dépendante d'une lecture :

```dart
// ✅ Transaction atomique
await db.transaction(() async {
  final current = await db.getBalance(userId);
  await db.updateBalance(userId, current + amount);
  await db.insertTransaction(Transaction(...));
});
```

### Sécurité des données

- Jamais de secrets en dur — `--dart-define` ou `flutter_dotenv`
- Tokens stockés dans `flutter_secure_storage` (Keychain iOS / Keystore Android)
- Obfuscation activée en release : `flutter build apk --obfuscate --split-debug-info`
- Certificat pinning si l'API est critique (dio + `http_certificate_pinning`)

### Zéro Hardcoding

```dart
// ✅ Thème centralisé
Text('Title', style: Theme.of(context).textTheme.headlineMedium)

// ✅ Espacement via constantes
SizedBox(height: AppSpacing.lg) // AppSpacing.lg = 24.0

// ✅ Localisation
Text(context.l10n.welcomeMessage)

// ❌ Jamais
Text('Bienvenue', style: TextStyle(fontSize: 18, color: Color(0xFF333333)))
```

---

## 5. NAVIGATION

### Typed Routes — go_router_builder (obligatoire)

Les magic strings de navigation sont le même anti-pattern que le hardcoding banni en section 4. `go_router_builder` génère des classes type-safe à partir d'annotations : les paths disparaissent du code appelant, les paramètres sont typés, et un refactoring de route est détecté à la compilation.

```yaml
# pubspec.yaml
dependencies:
  go_router: ^14.0.0
dev_dependencies:
  go_router_builder: ^2.0.0
  build_runner: ^2.4.0
```

```dart
// routes/app_routes.dart
part 'app_routes.g.dart'; // généré par build_runner

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();
  @override Widget build(_, __) => const SplashScreen();
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();
  @override Widget build(_, __) => const LoginScreen();
}

@TypedGoRoute<ArticleRoute>(path: '/article/:id')
class ArticleRoute extends GoRouteData {
  const ArticleRoute({required this.id});
  final String id; // paramètre typé — plus de state.pathParameters['id']
  @override Widget build(_, __) => ArticleScreen(id: id);
}
```

```dart
// ✅ Navigation type-safe — zéro magic string
const HomeRoute().go(context);
ArticleRoute(id: article.id).push(context);

// ❌ À bannir définitivement
context.go('/article/${article.id}');
context.push('/login');
```

### go_router — conventions

```dart
// app_router.dart
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: const SplashRoute().location,
    redirect: (context, state) => _guard(authState, state),
    routes: $appRoutes, // liste générée par go_router_builder
  );
}

String? _guard(AuthState auth, GoRouterState state) {
  final isAuth = auth.isAuthenticated;
  final isOnLogin = state.matchedLocation == const LoginRoute().location;
  if (!isAuth && !isOnLogin) return const LoginRoute().location;
  if (isAuth && isOnLogin) return const HomeRoute().location;
  return null;
}
```

> **CI** : `dart run build_runner build --delete-conflicting-outputs` est déjà dans le workflow (section 11) — go_router_builder ne génère aucun surcoût de pipeline.

### Deep Links

Configurer `AndroidManifest.xml` et `Info.plist` + déclarer les paths dans `go_router`. Tester systématiquement avec `adb shell am start -a android.intent.action.VIEW -d "myapp://..."`.

---

## 6. TESTS

### Stratégie pyramidale

```
         /\
        /E2E\          (Patrol / integration_test) — 5%
       /------\
      / Widget \       (flutter_test) — 25%
     /----------\
    /  Unit Tests \    (dart test) — 70%
   /--------------\
```

### Unit Tests — Use Cases & Repositories

```dart
// test/features/auth/domain/login_usecase_test.dart
void main() {
  late LoginUseCase sut;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = LoginUseCase(mockRepo);
  });

  test('should return User on valid credentials', () async {
    when(mockRepo.login(any)).thenAnswer((_) async => Right(tUser));
    final result = await sut(tLoginParams);
    expect(result, Right(tUser));
  });

  test('should return InvalidCredentials failure on 401', () async {
    when(mockRepo.login(any)).thenAnswer(
      (_) async => const Left(AuthFailure.invalidCredentials()),
    );
    final result = await sut(tLoginParams);
    expect(result, const Left(AuthFailure.invalidCredentials()));
  });
}
```

### Widget Tests

```dart
testWidgets('LoginButton shows loader when loading', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authNotifierProvider.overrideWith(FakeAuthNotifier.new)],
      child: const MaterialApp(home: LoginScreen()),
    ),
  );
  await tester.tap(find.byType(LoginButton));
  await tester.pump();
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Coverage minimum

- Use Cases : **100%**
- Repositories : **> 80%**
- Widgets critiques : **> 60%**

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 7. ENVIRONMENTS & FLAVORS

### Structure

```
lib/
├── main_dev.dart
├── main_staging.dart
└── main_prod.dart
```

### Configuration

```dart
// core/config/app_config.dart
class AppConfig {
  final String apiBaseUrl;
  final String appName;
  final bool enableLogs;
  final bool enableCrashlytics;

  const AppConfig._({
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogs,
    required this.enableCrashlytics,
  });

  static const dev = AppConfig._(
    apiBaseUrl: 'https://api-dev.myapp.com',
    appName: 'MyApp DEV',
    enableLogs: true,
    enableCrashlytics: false,
  );

  static const prod = AppConfig._(
    apiBaseUrl: 'https://api.myapp.com',
    appName: 'MyApp',
    enableLogs: false,
    enableCrashlytics: true,
  );
}
```

### Build commands

```bash
# Dev
flutter run -t lib/main_dev.dart --flavor dev

# Release prod
flutter build apk -t lib/main_prod.dart --flavor prod \
  --obfuscate --split-debug-info=./debug-info
```

---

## 8. MONITORING & OBSERVABILITÉ

### Crash Reporting

```dart
// Initialisation dans main.dart
await Firebase.initializeApp();
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
};
```

### Performance Tracing custom

```dart
// Pour mesurer une opération critique
final trace = FirebasePerformance.instance.newTrace('load_feed');
await trace.start();
try {
  final items = await loadFeedUseCase();
  trace.putAttribute('item_count', items.length.toString());
} finally {
  await trace.stop();
}
```

### Logging structuré

```dart
// Utiliser `logger` package — jamais print() en prod
final log = Logger(
  printer: PrettyPrinter(methodCount: 0),
  output: kReleaseMode ? null : ConsoleOutput(),
);

log.d('User logged in: ${user.id}');
log.e('Login failed', error: failure, stackTrace: stack);
```

---

## 9. DEPENDENCY INJECTION (RIVERPOD PATTERNS)

### Déclarer les dépendances en couches

```dart
// data layer
@riverpod
Dio dioClient(DioClientRef ref) {
  return Dio(BaseOptions(baseUrl: ref.read(appConfigProvider).apiBaseUrl))
    ..interceptors.add(AuthInterceptor(ref));
}

@riverpod
AuthDataSource authDataSource(AuthDataSourceRef ref) =>
    AuthDataSourceImpl(ref.watch(dioClientProvider));

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepositoryImpl(ref.watch(authDataSourceProvider));

// domain layer
@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));
```

### Injection pour les tests

```dart
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(MockAuthRepository()),
    ],
    child: const App(),
  ),
);
```

---

## 10. PROTOCOLE POUR L'IA (instructions Claude/Copilot)

1. **Analyse préalable** : Expliquer l'impact architectural et performance avant tout code
2. **Format de sortie** : Diffs uniquement — jamais de fichier complet si seule une méthode change
3. **Linter** : Respect strict de `flutter_lints` + règles custom si présentes dans `analysis_options.yaml`
4. **Refactoring** : Proposer un découpage si la logique est dans la vue
5. **Tests** : Tout nouveau Use Case livré avec ses tests unitaires
6. **Pas de solution quick-and-dirty** : Si un raccourci technique est inévitable, le signaler avec `// TODO(tech-debt):` et une explication

---

## 11. COMMANDES DE VALIDATION

```bash
# Analyse statique — zéro warning toléré
flutter analyze

# Génération de code
dart run build_runner build --delete-conflicting-outputs

# Formatage
dart format .

# Tests + coverage
flutter test --coverage

# Build de profiling (jamais de décision perf sur debug)
flutter run --profile

# Build release avec obfuscation
flutter build apk --obfuscate --split-debug-info=./debug-info

# Audit des dépendances
flutter pub deps --no-dev
flutter pub outdated
```

---

## 12. CHECKLIST PRE-MERGE

- [ ] `flutter analyze` — 0 erreur, 0 warning
- [ ] Tous les tests passent (`flutter test`)
- [ ] Coverage Use Cases ≥ 100%
- [ ] Aucune logique métier dans les widgets
- [ ] Aucun `print()` / `debugPrint()` non conditionnel
- [ ] Aucun secret hardcodé (`grep -r "api_key\|password\|secret" lib/`)
- [ ] Nouveaux écrans accessibles (semantics labels)
- [ ] `dart format .` appliqué
- [ ] Changelog mis à jour

---

*Flutter Blueprint v2.1 — Production-Ready*
*Maintenu par l'équipe Lead Dev — mise à jour à chaque montée de version majeure Flutter/Riverpod*
