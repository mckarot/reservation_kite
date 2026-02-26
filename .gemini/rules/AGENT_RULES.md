# Gemini Agent Rules for Reservation Kite Project

## 1. PRODUCT VISION
Complete Flutter management application for Kite Surf schools: reservations, subscriptions, pedagogical tracking, dynamic staff and schedule management.

**Target users:**
- **Student**: Reserves, chooses instructor, consults credits and progress.
- **Instructor**: Manages profile (bio, photo, specialties) and availabilities.
- **Administrator**: Manages the school via a Control Panel (Schedules, Staff, Finances, Validations).

---

## 2. TECHNICAL ARCHITECTURE

### Stack
- **Flutter/Dart**
- **Firebase**: Firestore, Auth, App Check (mandatory)
- **Riverpod**: State management with generators (`@riverpod`)
- **Freezed**: Immutable models
- **Clean Architecture**: Strict separation `data` / `domain` / `presentation`

### Structure
```
lib/
├── data/           # Repositories Firestore, providers
├── domain/         # Models, repository interfaces
└── presentation/   # UI, screens, widgets, notifiers
```

### Code Conventions
- Generated files: `.g.dart` (riverpod_generator)
- `FieldValue.serverTimestamp()` mandatory for Firestore timestamps
- **`DateTime.now()` FORBIDDEN** for Firestore
- Any Firestore query must have a `.limit()`
- `if (!mounted)` mandatory after `await` using `BuildContext`
- Any Provider/Notifier method must return an `AsyncValue` or be wrapped in a guard for uniform error handling

---

## 3. AGENT INSTRUCTIONS (NON-NEGOTIABLE RULES)

### Before Any Modification
1. **Analyze existing code** before any non-trivial modification.
2. **Check `firestore_schema.md`** as the single source of truth for any data structure.
3. Work with an **interactive Todo List** for complex tasks.

### Development Constraints
- **Zero theory**, provide **only diffs** (never complete files).
- **No side effects** without explicit validation (write, delete, send, mutate).
- **No direct Firestore writes** for critical data -> must go through Cloud Function.
- **No automatic retry** on writes.

### Quality & Validation
- If `flutter analyze`, a test or a rule fails: **STOP**, explain the problem, do not loop on corrections.
- Any exception must be **justified, validated, explicitly mentioned**.
- Respond in **French**.

### Impact Review (Mandatory for Firestore/Auth/Cloud Functions)
For any modification, specify:
- **Cost impact** (Firestore queries, reads/writes).
- **Security impact** (Firestore rules, data access).
- **UX impact** (clear, generic, never technical error messages).

### Validation Protocol
1. **Static Verification**: `flutter analyze` — fix warnings (`prefer_const_constructors`, `use_build_context_synchronously`).
2. **Architecture Verification**: If model/Provider modified -> `dart run build_runner build --delete-conflicting-outputs`.
3. **Firebase Control**: Validate the presence of `.limit()` and the existence of fields in `firestore_schema.md`.
4. **Performance Audit**: No widget > 100 lines (extract sub-widgets if necessary).

---

## 4. USEFUL COMMANDS

```bash
# Build runner for code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Static analysis
flutter analyze

# Tests
flutter test

# Run with device
flutter run

# Clean build
flutter clean && flutter pub get
```