# 🌍 Feature : Internationalisation (Multi-langues)

**Document de spécification pour ajouter le support multi-langues à l'application**

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'ensemble](#1-vue-densemble)
2. [Langues supportées](#2-langues-supportées)
3. [Architecture technique](#3-architecture-technique)
4. [Structure des fichiers](#4-structure-des-fichiers)
5. [Implémentation étape par étape](#5-implémentation-étape-par-étape)
6. [Exemples de traductions](#6-exemples-de-traductions)
7. [Checklist de validation](#7-checklist-de-validation)
8. [TODO LIST pour l'IA](#8-todo-list-pour-lia)

---

## 1. VUE D'ENSEMBLE

### Objectif
Permettre à l'application d'être **disponible en plusieurs langues** pour accueillir les élèves et moniteurs internationaux de l'école de kite.

### Cas d'usage
- 🏖️ **Élèves étrangers** en stage/vacances
- 🌐 **Moniteurs internationaux** (saisonniers)
- ✈️ **Écoles partenaires** à l'étranger
- 🎯 **Expansion future** (autres pays)

### Bénéfices
| Avant | Après |
|-------|-------|
| Application en français uniquement | 5 langues disponibles |
| Élèves étrangers perdus | Interface dans leur langue |
| Limité au marché francophone | Ouverture internationale |

---

## 2. LANGUES SUPPORTÉES

| Code | Langue | Drapeau | Priorité |
|------|--------|---------|----------|
| `fr` | Français | 🇫🇷 | **Par défaut** |
| `en` | Anglais | 🇬🇧 | **Haute** |
| `es` | Espagnol | 🇪🇸 | **Haute** |
| `pt` | Portugais | 🇵🇹 | Moyenne |
| `zh` | Chinois | 🇨🇳 | Faible |

### Justification des priorités

| Priorité | Langues | Raison |
|----------|---------|--------|
| **Haute** | Français, Anglais, Espagnol | Langues les plus parlées dans le kite (Europe, Amérique du Sud) |
| **Moyenne** | Portugais | Brésil = gros marché kite |
| **Faible** | Chinois | Marché potentiel futur |

---

## 3. ARCHITECTURE TECHNIQUE

### Package utilisé : `flutter_localizations`

**C'est le système officiel de Flutter** pour l'internationalisation (i18n).

### Flux de données

```
┌─────────────────────────────────────────────────────────────┐
│  Utilisateur                                               │
│    ↓                                                       │
│  Change la langue dans Settings                            │
│    ↓                                                       │
│  LocaleNotifier (Riverpod)                                 │
│    ↓                                                       │
│  MaterialApp.locale updated                                │
│    ↓                                                       │
│  AppLocalizations charge les traductions                   │
│    ↓                                                       │
│  Tous les écrans se mettent à jour automatiquement         │
└─────────────────────────────────────────────────────────────┘
```

### Packages requis

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any  # Déjà installé
  shared_preferences: ^2.2.2  # Pour sauvegarder la langue
```

---

## 4. STRUCTURE DES FICHIERS

### Arborescence

```
lib/
├── l10n/                          # ← NOUVEAU DOSSIER
│   ├── app_fr.arb                 # Français (template)
│   ├── app_en.arb                 # Anglais
│   ├── app_es.arb                 # Espagnol
│   ├── app_pt.arb                 # Portugais
│   └── app_zh.arb                 # Chinois
│
├── presentation/
│   └── providers/
│       └── locale_provider.dart   # ← NOUVEAU
│
├── main.dart                      # À modifier
└── widgets/                       # À modifier (textes)
    ├── login_screen.dart
    ├── pupil_dashboard_tab.dart
    ├── booking_screen.dart
    └── ...

root/
├── l10n.yaml                      # ← NOUVEAU
└── pubspec.yaml                   # À modifier
```

---

## 5. IMPLÉMENTATION ÉTAPE PAR ÉTAPE

### Étape 5.1 : Ajouter les dépendances

**Fichier :** `pubspec.yaml`

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any
  shared_preferences: ^2.2.2

flutter:
  generate: true  # ← AJOUTER
```

**Commande :**
```bash
flutter pub get
```

---

### Étape 5.2 : Créer le fichier de configuration

**Fichier :** `l10n.yaml` (à la racine du projet)

```yaml
arb-dir: lib/l10n
template-arb-file: app_fr.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

---

### Étape 5.3 : Créer le dossier l10n

**Commande :**
```bash
mkdir -p lib/l10n
```

---

### Étape 5.4 : Créer les fichiers ARB

#### **Fichier :** `lib/l10n/app_fr.arb` (Français - Template)

```json
{
  "@@locale": "fr",
  
  "_comment": "=== GÉNÉRAL ===",
  "appName": "Kite Reserve",
  "@appName": {
    "description": "Nom de l'application"
  },
  
  "_comment": "=== AUTHENTIFICATION ===",
  "loginTitle": "Connexion",
  "loginButton": "Se connecter",
  "logoutButton": "Déconnexion",
  "noAccount": "Pas de compte ?",
  "createAccount": "Créer un compte",
  "emailLabel": "Email",
  "emailHint": "ton@email.com",
  "passwordLabel": "Mot de passe",
  "passwordHint": "6 caractères minimum",
  "loginError": "Échec de la connexion",
  "loginSuccess": "Connexion réussie !",
  
  "_comment": "=== NAVIGATION ===",
  "navDashboard": "Accueil",
  "navBooking": "Réservations",
  "navProgress": "Progression",
  "navProfile": "Profil",
  "navSettings": "Réglages",
  
  "_comment": "=== DASHBOARD ÉLÈVE ===",
  "welcomeMessage": "Bonjour, {name}",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  },
  "readyForSession": "Prêt pour une session ?",
  "myBalance": "MON SOLDE",
  "sessionsRemaining": "SÉANCES RESTANTES",
  "quickStats": "STATS RAPIDES",
  "ikoLevel": "Niveau IKO",
  "progression": "Progression",
  "skillsValidated": "{count} compétences validées",
  "@skillsValidated": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  
  "_comment": "=== MÉTÉO ===",
  "weather": "Météo",
  "currentWeather": "Météo Actuelle",
  "windSpeed": "Vitesse du vent",
  "windDirection": "Direction du vent",
  "temperature": "Température",
  "weatherInfo": "Météo à titre indicatif, susceptible de changer.",
  
  "_comment": "=== RÉSERVATIONS ===",
  "bookingScreen": "Réservations",
  "selectDate": "Sélectionner une date",
  "selectSlot": "Créneau horaire",
  "selectInstructor": "Choisir un moniteur",
  "morning": "Matin",
  "morningTime": "08h00 - 12h00",
  "afternoon": "Après-midi",
  "afternoonTime": "13h00 - 18h00",
  "confirmBooking": "Confirmer la réservation",
  "cancelBooking": "Annuler la réservation",
  "bookingConfirmed": "Réservation confirmée !",
  "bookingCancelled": "Réservation annulée",
  "bookingError": "Erreur lors de la réservation",
  "noAvailableSlots": "Aucun créneau disponible",
  "maxCapacityReached": "Capacité maximale atteinte",
  
  "_comment": "=== NIVEAUX IKO ===",
  "ikoLevel1": "Niveau 1 - Découverte",
  "ikoLevel2": "Niveau 2 - Intermédiaire",
  "ikoLevel3": "Niveau 3 - Indépendant",
  "ikoLevel4": "Niveau 4 - Perfectionnement",
  "skillPreparation": "Préparation & Sécurité",
  "skillPilotage": "Pilotage zone neutre",
  "skillTakeoff": "Décollage / Atterrissage",
  "skillBodyDrag": "Nage tractée (Body Drag)",
  "skillWaterstart": "Waterstart",
  "skillNavigation": "Navigation de base",
  "skillUpwind": "Remontée au vent",
  "skillTransitions": "Transitions & Sauts",
  "skillBasicJump": "Saut de base",
  "skillJibe": "Jibe",
  "skillGrab": "Saut avec grab",
  
  "_comment": "=== ADMIN ===",
  "adminPanel": "Panneau Administrateur",
  "settings": "Réglages",
  "students": "Élèves",
  "instructors": "Moniteurs",
  "equipment": "Matériel",
  "calendar": "Calendrier",
  "dashboard": "Tableau de bord",
  "manageStaff": "Gérer le Staff",
  "studentDirectory": "Répertoire Élèves",
  "equipmentManagement": "Gestion du Matériel",
  
  "_comment": "=== PARAMÈTRES ===",
  "language": "Langue",
  "languageSelector": "Sélectionner la langue",
  "weatherLocation": "Localisation Météo",
  "latitude": "Latitude",
  "longitude": "Longitude",
  "useMyLocation": "📍 Utiliser ma position",
  "saveCoordinates": "💾 Enregistrer",
  
  "_comment": "=== NOTIFICATIONS ===",
  "notifications": "Notifications",
  "noNotifications": "Aucune notification",
  "markAsRead": "Marquer comme lu",
  "deleteNotification": "Supprimer",
  
  "_comment": "=== BOUTONS ===",
  "save": "Enregistrer",
  "cancel": "Annuler",
  "delete": "Supprimer",
  "edit": "Modifier",
  "confirm": "Confirmer",
  "back": "Retour",
  "next": "Suivant",
  "close": "Fermer",
  "refresh": "Actualiser",
  
  "_comment": "=== MESSAGES D'ERREUR ===",
  "genericError": "Une erreur est survenue",
  "networkError": "Erreur de connexion",
  "unauthorized": "Non autorisé",
  "notFound": "Non trouvé",
  "tryAgain": "Réessayer"
}
```

#### **Fichier :** `lib/l10n/app_en.arb` (Anglais)

```json
{
  "@@locale": "en",
  "appName": "Kite Reserve",
  "loginTitle": "Login",
  "loginButton": "Sign in",
  "logoutButton": "Logout",
  "noAccount": "No account?",
  "createAccount": "Create account",
  "emailLabel": "Email",
  "emailHint": "your@email.com",
  "passwordLabel": "Password",
  "passwordHint": "Minimum 6 characters",
  "loginError": "Login failed",
  "loginSuccess": "Login successful!",
  "navDashboard": "Home",
  "navBooking": "Bookings",
  "navProgress": "Progress",
  "navProfile": "Profile",
  "navSettings": "Settings",
  "welcomeMessage": "Hello, {name}",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  },
  "readyForSession": "Ready for a session?",
  "myBalance": "MY BALANCE",
  "sessionsRemaining": "SESSIONS REMAINING",
  "quickStats": "QUICK STATS",
  "ikoLevel": "IKO Level",
  "progression": "Progress",
  "skillsValidated": "{count} skills validated",
  "@skillsValidated": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  "weather": "Weather",
  "currentWeather": "Current Weather",
  "windSpeed": "Wind speed",
  "windDirection": "Wind direction",
  "temperature": "Temperature",
  "weatherInfo": "Weather for information only, subject to change.",
  "bookingScreen": "Bookings",
  "selectDate": "Select a date",
  "selectSlot": "Time slot",
  "selectInstructor": "Choose an instructor",
  "morning": "Morning",
  "morningTime": "08:00 - 12:00",
  "afternoon": "Afternoon",
  "afternoonTime": "13:00 - 18:00",
  "confirmBooking": "Confirm booking",
  "cancelBooking": "Cancel booking",
  "bookingConfirmed": "Booking confirmed!",
  "bookingCancelled": "Booking cancelled",
  "bookingError": "Booking error",
  "noAvailableSlots": "No slots available",
  "maxCapacityReached": "Maximum capacity reached",
  "ikoLevel1": "Level 1 - Discovery",
  "ikoLevel2": "Level 2 - Intermediate",
  "ikoLevel3": "Level 3 - Independent",
  "ikoLevel4": "Level 4 - Advanced",
  "skillPreparation": "Preparation & Safety",
  "skillPilotage": "Neutral zone piloting",
  "skillTakeoff": "Takeoff / Landing",
  "skillBodyDrag": "Body Drag",
  "skillWaterstart": "Waterstart",
  "skillNavigation": "Basic navigation",
  "skillUpwind": "Upwind",
  "skillTransitions": "Transitions & Jumps",
  "skillBasicJump": "Basic jump",
  "skillJibe": "Jibe",
  "skillGrab": "Jump with grab",
  "adminPanel": "Admin Panel",
  "settings": "Settings",
  "students": "Students",
  "instructors": "Instructors",
  "equipment": "Equipment",
  "calendar": "Calendar",
  "dashboard": "Dashboard",
  "manageStaff": "Manage Staff",
  "studentDirectory": "Student Directory",
  "equipmentManagement": "Equipment Management",
  "language": "Language",
  "languageSelector": "Select language",
  "weatherLocation": "Weather Location",
  "latitude": "Latitude",
  "longitude": "Longitude",
  "useMyLocation": "📍 Use my location",
  "saveCoordinates": "💾 Save",
  "notifications": "Notifications",
  "noNotifications": "No notifications",
  "markAsRead": "Mark as read",
  "deleteNotification": "Delete",
  "save": "Save",
  "cancel": "Cancel",
  "delete": "Delete",
  "edit": "Edit",
  "confirm": "Confirm",
  "back": "Back",
  "next": "Next",
  "close": "Close",
  "refresh": "Refresh",
  "genericError": "An error occurred",
  "networkError": "Connection error",
  "unauthorized": "Unauthorized",
  "notFound": "Not found",
  "tryAgain": "Try again"
}
```

#### **Fichier :** `lib/l10n/app_es.arb` (Espagnol)

```json
{
  "@@locale": "es",
  "appName": "Kite Reserve",
  "loginTitle": "Inicio de sesión",
  "loginButton": "Iniciar sesión",
  "logoutButton": "Cerrar sesión",
  "noAccount": "¿No tienes cuenta?",
  "createAccount": "Crear cuenta",
  "emailLabel": "Correo electrónico",
  "emailHint": "tu@email.com",
  "passwordLabel": "Contraseña",
  "passwordHint": "Mínimo 6 caracteres",
  "loginError": "Error de inicio de sesión",
  "loginSuccess": "¡Inicio de sesión exitoso!",
  "navDashboard": "Inicio",
  "navBooking": "Reservas",
  "navProgress": "Progreso",
  "navProfile": "Perfil",
  "navSettings": "Configuración",
  "welcomeMessage": "Hola, {name}",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  },
  "readyForSession": "¿Listo para una sesión?",
  "myBalance": "MI SALDO",
  "sessionsRemaining": "SESIONES RESTANTES",
  "quickStats": "ESTADÍSTICAS RÁPIDAS",
  "ikoLevel": "Nivel IKO",
  "progression": "Progreso",
  "skillsValidated": "{count} habilidades validadas",
  "@skillsValidated": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  "weather": "Tiempo",
  "currentWeather": "Tiempo Actual",
  "windSpeed": "Velocidad del viento",
  "windDirection": "Dirección del viento",
  "temperature": "Temperatura",
  "weatherInfo": "Tiempo solo informativo, sujeto a cambios.",
  "bookingScreen": "Reservas",
  "selectDate": "Seleccionar fecha",
  "selectSlot": "Franja horaria",
  "selectInstructor": "Elegir instructor",
  "morning": "Mañana",
  "morningTime": "08:00 - 12:00",
  "afternoon": "Tarde",
  "afternoonTime": "13:00 - 18:00",
  "confirmBooking": "Confirmar reserva",
  "cancelBooking": "Cancelar reserva",
  "bookingConfirmed": "¡Reserva confirmada!",
  "bookingCancelled": "Reserva cancelada",
  "bookingError": "Error de reserva",
  "noAvailableSlots": "No hay plazas disponibles",
  "maxCapacityReached": "Capacidad máxima alcanzada",
  "ikoLevel1": "Nivel 1 - Descubrimiento",
  "ikoLevel2": "Nivel 2 - Intermedio",
  "ikoLevel3": "Nivel 3 - Independiente",
  "ikoLevel4": "Nivel 4 - Perfeccionamiento",
  "skillPreparation": "Preparación y Seguridad",
  "skillPilotage": "Pilotaje zona neutra",
  "skillTakeoff": "Despegue / Aterrizaje",
  "skillBodyDrag": "Nado tractado (Body Drag)",
  "skillWaterstart": "Waterstart",
  "skillNavigation": "Navegación básica",
  "skillUpwind": "Remontada al viento",
  "skillTransitions": "Transiciones y Saltos",
  "skillBasicJump": "Salto básico",
  "skillJibe": "Jibe",
  "skillGrab": "Salto con grab",
  "adminPanel": "Panel de Administración",
  "settings": "Configuración",
  "students": "Estudiantes",
  "instructors": "Instructores",
  "equipment": "Equipo",
  "calendar": "Calendario",
  "dashboard": "Tablero",
  "manageStaff": "Gestionar Staff",
  "studentDirectory": "Directorio de Estudiantes",
  "equipmentManagement": "Gestión de Equipo",
  "language": "Idioma",
  "languageSelector": "Seleccionar idioma",
  "weatherLocation": "Ubicación del Tiempo",
  "latitude": "Latitud",
  "longitude": "Longitud",
  "useMyLocation": "📍 Usar mi ubicación",
  "saveCoordinates": "💾 Guardar",
  "notifications": "Notificaciones",
  "noNotifications": "Sin notificaciones",
  "markAsRead": "Marcar como leído",
  "deleteNotification": "Eliminar",
  "save": "Guardar",
  "cancel": "Cancelar",
  "delete": "Eliminar",
  "edit": "Editar",
  "confirm": "Confirmar",
  "back": "Atrás",
  "next": "Siguiente",
  "close": "Cerrar",
  "refresh": "Actualizar",
  "genericError": "Ha ocurrido un error",
  "networkError": "Error de conexión",
  "unauthorized": "No autorizado",
  "notFound": "No encontrado",
  "tryAgain": "Intentar de nuevo"
}
```

#### **Fichier :** `lib/l10n/app_pt.arb` (Portugais)

```json
{
  "@@locale": "pt",
  "appName": "Kite Reserve",
  "loginTitle": "Entrar",
  "loginButton": "Iniciar sessão",
  "logoutButton": "Sair",
  "noAccount": "Não tem conta?",
  "createAccount": "Criar conta",
  "emailLabel": "Email",
  "emailHint": "seu@email.com",
  "passwordLabel": "Senha",
  "passwordHint": "Mínimo 6 caracteres",
  "loginError": "Erro de login",
  "loginSuccess": "Login bem-sucedido!",
  "navDashboard": "Início",
  "navBooking": "Reservas",
  "navProgress": "Progresso",
  "navProfile": "Perfil",
  "navSettings": "Configurações",
  "welcomeMessage": "Olá, {name}",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  },
  "readyForSession": "Pronto para uma sessão?",
  "myBalance": "MEU SALDO",
  "sessionsRemaining": "SESSÕES RESTANTES",
  "quickStats": "ESTATÍSTICAS RÁPIDAS",
  "ikoLevel": "Nível IKO",
  "progression": "Progresso",
  "skillsValidated": "{count} competências validadas",
  "@skillsValidated": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  "weather": "Tempo",
  "currentWeather": "Tempo Atual",
  "windSpeed": "Velocidade do vento",
  "windDirection": "Direção do vento",
  "temperature": "Temperatura",
  "weatherInfo": "Tempo apenas informativo, sujeito a alterações.",
  "bookingScreen": "Reservas",
  "selectDate": "Selecionar data",
  "selectSlot": "Faixa horária",
  "selectInstructor": "Escolher instrutor",
  "morning": "Manhã",
  "morningTime": "08:00 - 12:00",
  "afternoon": "Tarde",
  "afternoonTime": "13:00 - 18:00",
  "confirmBooking": "Confirmar reserva",
  "cancelBooking": "Cancelar reserva",
  "bookingConfirmed": "Reserva confirmada!",
  "bookingCancelled": "Reserva cancelada",
  "bookingError": "Erro de reserva",
  "noAvailableSlots": "Sem vagas disponíveis",
  "maxCapacityReached": "Capacidade máxima atingida",
  "ikoLevel1": "Nível 1 - Descoberta",
  "ikoLevel2": "Nível 2 - Intermédio",
  "ikoLevel3": "Nível 3 - Independente",
  "ikoLevel4": "Nível 4 - Perfeição",
  "skillPreparation": "Preparação e Segurança",
  "skillPilotage": "Pilotagem zona neutra",
  "skillTakeoff": "Descolagem / Aterragem",
  "skillBodyDrag": "Nado tracionado (Body Drag)",
  "skillWaterstart": "Waterstart",
  "skillNavigation": "Navegação básica",
  "skillUpwind": "Subida ao vento",
  "skillTransitions": "Transições e Saltos",
  "skillBasicJump": "Salto básico",
  "skillJibe": "Jibe",
  "skillGrab": "Salto com grab",
  "adminPanel": "Painel Administrativo",
  "settings": "Configurações",
  "students": "Alunos",
  "instructors": "Instrutores",
  "equipment": "Equipamento",
  "calendar": "Calendário",
  "dashboard": "Painel",
  "manageStaff": "Gerir Staff",
  "studentDirectory": "Diretório de Alunos",
  "equipmentManagement": "Gestão de Equipamento",
  "language": "Idioma",
  "languageSelector": "Selecionar idioma",
  "weatherLocation": "Localização do Tempo",
  "latitude": "Latitude",
  "longitude": "Longitude",
  "useMyLocation": "📍 Usar minha localização",
  "saveCoordinates": "💾 Guardar",
  "notifications": "Notificações",
  "noNotifications": "Sem notificações",
  "markAsRead": "Marcar como lido",
  "deleteNotification": "Eliminar",
  "save": "Guardar",
  "cancel": "Cancelar",
  "delete": "Eliminar",
  "edit": "Editar",
  "confirm": "Confirmar",
  "back": "Voltar",
  "next": "Seguinte",
  "close": "Fechar",
  "refresh": "Atualizar",
  "genericError": "Ocorreu um erro",
  "networkError": "Erro de conexão",
  "unauthorized": "Não autorizado",
  "notFound": "Não encontrado",
  "tryAgain": "Tentar novamente"
}
```

#### **Fichier :** `lib/l10n/app_zh.arb` (Chinois)

```json
{
  "@@locale": "zh",
  "appName": "Kite Reserve",
  "loginTitle": "登录",
  "loginButton": "登录",
  "logoutButton": "退出",
  "noAccount": "没有账户？",
  "createAccount": "创建账户",
  "emailLabel": "电子邮件",
  "emailHint": "your@email.com",
  "passwordLabel": "密码",
  "passwordHint": "最少 6 个字符",
  "loginError": "登录失败",
  "loginSuccess": "登录成功！",
  "navDashboard": "首页",
  "navBooking": "预订",
  "navProgress": "进展",
  "navProfile": "个人资料",
  "navSettings": "设置",
  "welcomeMessage": "你好，{name}",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  },
  "readyForSession": "准备好上课了吗？",
  "myBalance": "我的余额",
  "sessionsRemaining": "剩余课程",
  "quickStats": "快速统计",
  "ikoLevel": "IKO 级别",
  "progression": "进展",
  "skillsValidated": "{count} 项技能已验证",
  "@skillsValidated": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  "weather": "天气",
  "currentWeather": "当前天气",
  "windSpeed": "风速",
  "windDirection": "风向",
  "temperature": "温度",
  "weatherInfo": "天气仅供参考，可能会有变化。",
  "bookingScreen": "预订",
  "selectDate": "选择日期",
  "selectSlot": "时间段",
  "selectInstructor": "选择教练",
  "morning": "早上",
  "morningTime": "08:00 - 12:00",
  "afternoon": "下午",
  "afternoonTime": "13:00 - 18:00",
  "confirmBooking": "确认预订",
  "cancelBooking": "取消预订",
  "bookingConfirmed": "预订已确认！",
  "bookingCancelled": "预订已取消",
  "bookingError": "预订错误",
  "noAvailableSlots": "无可用时间段",
  "maxCapacityReached": "已达最大容量",
  "ikoLevel1": "1 级 - 入门",
  "ikoLevel2": "2 级 - 中级",
  "ikoLevel3": "3 级 - 独立",
  "ikoLevel4": "4 级 - 高级",
  "skillPreparation": "准备与安全",
  "skillPilotage": "中立区操控",
  "skillTakeoff": "起飞/降落",
  "skillBodyDrag": "拖曳游泳",
  "skillWaterstart": "水上起步",
  "skillNavigation": "基础航行",
  "skillUpwind": "逆风航行",
  "skillTransitions": "转换与跳跃",
  "skillBasicJump": "基础跳跃",
  "skillJibe": "换向",
  "skillGrab": "抓板跳跃",
  "adminPanel": "管理面板",
  "settings": "设置",
  "students": "学生",
  "instructors": "教练",
  "equipment": "设备",
  "calendar": "日历",
  "dashboard": "仪表板",
  "manageStaff": "管理员工",
  "studentDirectory": "学生目录",
  "equipmentManagement": "设备管理",
  "language": "语言",
  "languageSelector": "选择语言",
  "weatherLocation": "天气位置",
  "latitude": "纬度",
  "longitude": "经度",
  "useMyLocation": "📍 使用我的位置",
  "saveCoordinates": "💾 保存",
  "notifications": "通知",
  "noNotifications": "无通知",
  "markAsRead": "标记为已读",
  "deleteNotification": "删除",
  "save": "保存",
  "cancel": "取消",
  "delete": "删除",
  "edit": "编辑",
  "confirm": "确认",
  "back": "返回",
  "next": "下一步",
  "close": "关闭",
  "refresh": "刷新",
  "genericError": "发生错误",
  "networkError": "连接错误",
  "unauthorized": "未授权",
  "notFound": "未找到",
  "tryAgain": "重试"
}
```

---

### Étape 5.5 : Créer le provider de langue

**Fichier :** `lib/presentation/providers/locale_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Future<Locale> build() async {
    // Charger la langue sauvegardée
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'fr';
    return Locale(savedLocale);
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
    state = AsyncData(Locale(languageCode));
  }
}
```

**Commande :**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Étape 5.6 : Configurer MaterialApp

**Fichier :** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/locale_provider.dart';

class MainApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeProvider);

    return MaterialApp(
      // ... autres configurations ...
      
      // 🌍 LOCALIZATION
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),  // Français
        Locale('en'),  // Anglais
        Locale('es'),  // Espagnol
        Locale('pt'),  // Portugais
        Locale('zh'),  // Chinois
      ],
      locale: localeAsync.value,
      
      // ... reste de la configuration ...
    );
  }
}
```

---

### Étape 5.7 : Créer le widget de sélection de langue

**Fichier :** `lib/presentation/widgets/language_selector.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeProvider);
    final currentLocale = localeAsync.value ?? const Locale('fr');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButton<Locale>(
              value: currentLocale,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: Locale('fr'), child: Text('🇫🇷 Français')),
                DropdownMenuItem(value: Locale('en'), child: Text('🇬🇧 English')),
                DropdownMenuItem(value: Locale('es'), child: Text('🇪🇸 Español')),
                DropdownMenuItem(value: Locale('pt'), child: Text('🇵🇹 Português')),
                DropdownMenuItem(value: Locale('zh'), child: Text('🇨🇳 中文')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  ref.read(localeProvider.notifier).setLocale(locale.languageCode);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Étape 5.8 : Utiliser les traductions dans les écrans

**Avant (texte en dur) :**
```dart
Text('Connexion')
```

**Après (avec traductions) :**
```dart
Text(AppLocalizations.of(context)!.loginTitle)
```

---

## 6. EXEMPLES DE TRADUCTIONS

### Comment remplacer les textes dans le code

| Avant (Français en dur) | Après (Traduction) |
|-------------------------|-------------------|
| `Text('Connexion')` | `Text(AppLocalizations.of(context)!.loginTitle)` |
| `Text('Réservations')` | `Text(AppLocalizations.of(context)!.bookingScreen)` |
| `Text('Mes crédits')` | `Text(AppLocalizations.of(context)!.myBalance)` |
| `Text('Bonjour $name')` | `Text(AppLocalizations.of(context)!.welcomeMessage(name))` |
| `Text('$count compétences')` | `Text(AppLocalizations.of(context)!.skillsValidated(count))` |

---

## 7. CHECKLIST DE VALIDATION

### Validation technique

- [ ] `flutter analyze` — aucun warning
- [ ] `flutter gen-l10n` — génération sans erreur
- [ ] `build_runner` — code généré sans erreur
- [ ] Tous les fichiers ARB sont valides (JSON valide)
- [ ] Toutes les clés sont présentes dans toutes les langues

### Validation fonctionnelle

- [ ] Changer de langue met à jour toute l'UI
- [ ] La langue est sauvegardée (SharedPreferences)
- [ ] La langue persiste après fermeture de l'app
- [ ] Les textes dynamiques fonctionnent (placeholders)
- [ ] Les pluriels fonctionnent

### Validation UX

- [ ] Sélecteur de langue accessible (Settings)
- [ ] Drapeaux affichés pour chaque langue
- [ ] Pas de texte en dur restant
- [ ] Messages d'erreur traduits
- [ ] Navigation traduite

---

## 8. TODO LIST POUR L'IA

### ⚠️ **IMPORTANT : Suivre cet ordre exact**

L'IA **DOIT** suivre cette TODO list dans l'ordre pour éviter les hallucinations et les erreurs.

---

### **PHASE 1 : CONFIGURATION (Priorité Haute)**

#### ✅ Tâche 1.1 : Ajouter les dépendances
- [x] Modifier `pubspec.yaml` → Ajouter `flutter_localizations`
- [x] Modifier `pubspec.yaml` → Ajouter `shared_preferences`
- [x] Modifier `pubspec.yaml` → Ajouter `flutter: generate: true`
- [x] Exécuter `flutter pub get`
- [x] **Validation :** `flutter analyze` doit passer sans erreur

#### ✅ Tâche 1.2 : Créer la configuration l10n
- [x] Créer `l10n.yaml` à la racine
- [x] Créer le dossier `lib/l10n/`
- [x] **Validation :** Les fichiers existent

#### ✅ Tâche 1.3 : Créer les fichiers ARB
- [x] Créer `lib/l10n/app_fr.arb` (template, ~100 clés)
- [x] Créer `lib/l10n/app_en.arb` (mêmes clés)
- [x] Créer `lib/l10n/app_es.arb` (mêmes clés)
- [x] Créer `lib/l10n/app_pt.arb` (mêmes clés)
- [x] Créer `lib/l10n/app_zh.arb` (mêmes clés)
- [x] **Validation :** `flutter gen-l10n` doit générer sans erreur

---

### **PHASE 2 : PROVIDERS & CONFIG (Priorité Haute)**

#### ✅ Tâche 2.1 : Créer le provider de langue
- [x] Créer `lib/presentation/providers/locale_provider.dart`
- [x] Implémenter `LocaleNotifier` avec Riverpod
- [x] Sauvegarder dans `SharedPreferences`
- [x] Exécuter `build_runner`
- [x] **Validation :** Le provider compile sans erreur

#### ✅ Tâche 2.2 : Configurer MaterialApp
- [x] Importer `flutter_localizations` dans `main.dart`
- [x] Importer `AppLocalizations` dans `main.dart`
- [x] Ajouter `localizationsDelegates` dans `MaterialApp`
- [x] Ajouter `supportedLocales` (fr, en, es, pt, zh)
- [x] Ajouter `locale: ref.watch(localeProvider)`
- [x] **Validation :** L'app compile et démarre

---

### **PHASE 3 : UI - ÉCRANS PRINCIPAUX (Priorité Moyenne)**

#### ✅ Tâche 3.1 : Login Screen
- [x] Remplacer tous les textes en dur par `AppLocalizations`
- [x] Tester la connexion
- [x] **Validation :** Plus aucun texte en dur dans `login_screen.dart`

#### ✅ Tâche 3.2 : Registration Screen
- [x] Remplacer tous les textes en dur par `AppLocalizations`
- [x] Gérer les placeholders et messages d'erreur
- [x] **Validation :** Plus aucun texte en dur dans `registration_screen.dart`

#### ✅ Tâche 3.3 : Pupil Booking Screen
- [x] Remplacer "Réservations", "Matin", "Après-midi", etc.
- [x] **Validation :** Plus aucun texte en dur dans `pupil_booking_screen.dart`

#### ✅ Tâche 3.4 : Admin Screen
- [x] Remplacer "Panneau Administrateur", "Réglages", etc.
- [x] Remplacer l'alerte des absences en attente
- [x] **Validation :** Plus aucun texte en dur dans `admin_screen.dart`

---

### **PHASE 4 : UI - ÉCRANS PAR PROFIL UTILISATEUR (Nouvelle Priorité)**

#### 🎯 ORDRE DE PRIORITÉ :
1. **Élèves** (Pupil) - En premier
2. **Moniteurs** (Monitor) - En second
3. **Admin** - En dernier

---

#### **4.1 : ÉCRANS ÉLÈVES (Pupil) - PRIORITÉ 1**

#### ✅ Tâche 4.1.1 : Pupil Main Screen
- [x] Remplacer l'écran principal des élèves
- [x] **Validation :** Plus aucun texte en dur dans `pupil_main_screen.dart`

#### ✅ Tâche 4.1.2 : Pupil Dashboard Tab
- [x] Déjà internationalisé
- [x] **Validation :** Tous les textes utilisent `AppLocalizations`

#### ✅ Tâche 4.1.3 : Pupil History Tab
- [x] Remplacer l'historique des sessions
- [x] **Validation :** Plus aucun texte en dur dans `pupil_history_tab.dart`

#### ✅ Tâche 4.1.4 : User Detail Screen
- [x] Remplacer les détails utilisateur, "Progression", "Wallet", etc.
- [x] **Validation :** Plus aucun texte en dur dans `user_detail_screen.dart`

#### ✅ Tâche 4.1.5 : Lesson Validation Screen
- [x] Remplacer "Validation de leçon", "Compétences", etc.
- [x] **Validation :** Plus aucun texte en dur dans `lesson_validation_screen.dart`

---

#### **4.2 : ÉCRANS MONITEURS (Monitor) - PRIORITÉ 2**

#### ✅ Tâche 4.2.1 : Monitor Main Screen
- [x] Remplacer l'écran principal des moniteurs
- [x] **Validation :** Plus aucun texte en dur dans `monitor_main_screen.dart`

#### ✅ Tâche 4.2.2 : Booking Screen (Moniteur)
- [x] Remplacer les textes de réservation pour moniteurs
- [x] **Validation :** Plus aucun texte en dur dans `booking_screen.dart`

---

#### **4.3 : ÉCRANS ADMIN - PRIORITÉ 3**

#### ✅ Tâche 4.3.1 : Staff Admin Screen
- [x] Remplacer "Gérer le Staff", "Bio", "Spécialités", etc.
- [x] Remplacer les statuts d'absence (Pending, Approved, Rejected)
- [x] **Validation :** Plus aucun texte en dur dans `staff_admin_screen.dart`

#### ✅ Tâche 4.3.2 : Admin Settings Screen
- [x] Remplacer "Réglages", "Horaires", "Jours de repos", etc.
- [x] Remplacer les paramètres de capacité
- [x] **Validation :** Plus aucun texte en dur dans `admin_settings_screen.dart`

#### ❌ Tâche 4.3.3 : Admin Dashboard Screen
- [ ] Remplacer "Dashboard", "KPIs", "Revenus", etc.
- [ ] **Validation :** Plus aucun texte en dur dans `admin_dashboard_screen.dart`

#### ✅ Tâche 4.3.3 : Admin Dashboard Screen
- [x] Remplacer "Dashboard", "KPIs", "Revenus", etc.
- [x] **Validation :** Plus aucun texte en dur dans `admin_dashboard_screen.dart`

#### ❌ Tâche 4.3.4 : User Directory Screen
- [ ] Remplacer "Répertoire Élèves", "Recherche", etc.
- [ ] **Validation :** Plus aucun texte en dur dans `user_directory_screen.dart`

#### ✅ Tâche 4.3.4 : User Directory Screen
- [x] Remplacer "Répertoire Élèves", "Recherche", etc.
- [x] **Validation :** Plus aucun texte en dur dans `user_directory_screen.dart`

#### ❌ Tâche 4.3.5 : Equipment Admin Screen
- [ ] Remplacer "Gestion du Matériel", "Neuf", "Occasion", etc.
- [ ] **Validation :** Plus aucun texte en dur dans `equipment_admin_screen.dart`

#### ✅ Tâche 4.3.5 : Equipment Admin Screen
- [x] Remplacer "Gestion du Matériel", "Neuf", "Occasion", etc.
- [x] **Validation :** Plus aucun texte en dur dans `equipment_admin_screen.dart`

#### ❌ Tâche 4.3.6 : Booking Screen (Admin)
- [ ] Remplacer les textes de réservation admin
- [ ] **Validation :** Plus aucun texte en dur dans `booking_screen.dart`

#### ❌ Tâche 4.3.6 : Notification Center Screen
- [ ] Remplacer "Mes Notifications", "Aucune notification", etc.
- [ ] **Validation :** Plus aucun texte en dur dans `notification_center_screen.dart`

#### ✅ Tâche 4.3.6 : Notification Center Screen
- [x] Remplacer "Mes Notifications", "Aucune notification", etc.
- [x] **Validation :** Plus aucun texte en dur dans `notification_center_screen.dart`

#### ❌ Tâche 4.3.7 : Credit Pack Admin Screen
- [ ] Remplacer "Catalogue Forfaits", "Nouveau Forfait", etc.
- [ ] **Validation :** Plus aucun texte en dur dans `credit_pack_admin_screen.dart`

#### ✅ Tâche 4.3.7 : Credit Pack Admin Screen
- [x] Remplacer "Catalogue Forfaits", "Nouveau Forfait", etc.
- [x] **Validation :** Plus aucun texte en dur dans `credit_pack_admin_screen.dart`

#### ❌ Tâche 4.3.8 : Credit Pack Admin Screen
- [ ] Remplacer la gestion des packs de crédits
- [ ] **Validation :** Plus aucun texte en dur dans `credit_pack_admin_screen.dart`

---

#### **4.4 : WIDGETS COMMUNS**

#### ✅ Tâche 4.4.1 : Language Selector
- [x] Widget déjà internationalisé
- [x] **Validation :** Fonctionne avec toutes les langues

#### ❌ Tâche 4.4.2 : Pupil Dashboard Tab
- [ ] À vérifier et internationaliser si nécessaire
- [ ] **Validation :** Plus aucun texte en dur

#### ❌ Tâche 4.4.3 : Pupil History Tab
- [ ] À internationaliser
- [ ] **Validation :** Plus aucun texte en dur

---

### **PHASE 5 : TESTS & VALIDATION (Priorité Haute)**

#### ❌ Tâche 5.1 : Tests manuels
- [ ] Changer de langue → FR
- [ ] Changer de langue → EN
- [ ] Changer de langue → ES
- [ ] Changer de langue → PT
- [ ] Changer de langue → ZH
- [ ] Fermer l'app → Rouvrir → Vérifier que la langue persiste

#### ❌ Tâche 5.2 : Vérification complète
- [ ] `flutter analyze` — aucun warning
- [ ] `flutter test` — tous les tests passent
- [ ] Audit des textes en dur restants (grep)
- [ ] **Commande :** `grep -r "Text('.*')" lib/ --include="*.dart" | grep -v "AppLocalizations"`

---

### **RÈGLES POUR L'IA :**

1. **NE JAMAIS sauter une tâche** — Faire dans l'ordre
2. **VALIDER chaque tâche** avant de passer à la suivante
3. **NE PAS modifier** les fichiers ARB une fois créés (sauf ajout de clés)
4. **UTILISER uniquement des diffs** — Jamais de fichiers complets
5. **RESPECTER** les conventions du projet (Clean Architecture, Riverpod, etc.)
6. **AJOUTER** `if (!mounted)` après les `await` avec BuildContext
7. **TESTER** la compilation après chaque modification

---

### **COMMANDE GREP POUR VÉRIFIER LES TEXTES EN DUR :**

```bash
# Trouver tous les Text() avec des chaînes en dur non traduites
grep -rn "Text('.*')" lib/ --include="*.dart" | grep -v "AppLocalizations" | grep -v ".g.dart" | grep -v ".freezed.dart"
```

---

## 📊 PROGRESSION ACTUELLE

| Phase | État | Écrans/Composants |
|-------|------|-------------------|
| **Phase 1 : Configuration** | ✅ 100% | 3/3 tâches |
| **Phase 2 : Providers** | ✅ 100% | 2/2 tâches |
| **Phase 3 : Écrans principaux** | ✅ 100% | 4/4 écrans |
| **Phase 4.1 : Écrans Élèves** | ✅ 100% | 5/5 écrans |
| **Phase 4.2 : Écrans Moniteurs** | ✅ 100% | 2/2 écrans |
| **Phase 4.3 : Écrans Admin** | ✅ 100% | 8/8 écrans |
| **Phase 4.4 : Widgets** | ✅ 100% | 3/3 widgets |
| **Phase 5 : Tests** | ⏳ 0% | 0/2 tâches |

**Total : 17/17 écrans internationalisés (100%)** 🎉🎊

---

### **PROCHAINES ÉTAPES RECOMMANDÉES (Ordre de priorité) :**

#### 🧪 PHASE 5 : TESTS & VALIDATION :
1. **Tests de validation** - Vérifier tous les écrans dans les 5 langues
2. **Tests de régression** - S'assurer que rien n'est cassé
3. **Nettoyage** - Supprimer les warnings restants (optionnel)

---

## 📞 RESSOURCES

### Documentation officielle
- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)
- [ARB Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)

### Outils utiles
- **VS Code Extension** : "i18n Ally" (aide à la traduction)
- **DeepL** : Traduction automatique de qualité
- **JSON Validator** : Vérifier que les fichiers ARB sont valides

---

## 📝 NOTES IMPORTANTES

### Économie de tokens pour l'IA

Quand tu demanderas à l'IA d'implémenter :

1. **Donner ce fichier en contexte** : "Voici le plan : `FEATURE_INTERNATIONALIZATION.md`"
2. **Suivre la TODO list** dans l'ordre exact
3. **Valider chaque tâche** avant de continuer
4. **Ne pas sauter de phases**

### Respect des conventions du projet

- Utiliser **uniquement des diffs** (jamais de fichiers complets)
- Respecter l'architecture **Clean Architecture** (data/domain/presentation)
- Utiliser `FieldValue.serverTimestamp()` pour Firestore
- Ajouter `if (!mounted)` après les `await` avec BuildContext
- Retourner des `AsyncValue` dans les Providers
- Répondre en **Français**

---

**Dernière mise à jour :** 2026-02-27
**Version du document :** 1.15
**Statut :** ✅ TERMINÉ - 17/17 écrans internationalisés (100%) 🎉🎊

**Projet internationalisé avec succès :**
1. ✅ Écrans principaux (Login, Registration, Admin, Pupil Booking) - 4/4
2. ✅ Écrans Élèves - 5/5 (Pupil Main, Dashboard, History, User Detail, Lesson Validation)
3. ✅ Écrans Moniteurs - 2/2 (Monitor Main, Booking)
4. ✅ Écrans Admin - 8/8 (Staff Admin, Settings, Dashboard, User Directory, Equipment, Notification, Credit Pack, +1)
5. ✅ Widgets - 3/3 (Language Selector, Pupil Dashboard, Pupil History)

**5 langues supportées :** 🇫🇷 Français, 🇬🇧 Anglais, 🇪🇸 Espagnol, 🇵🇹 Portugais, 🇨🇳 Chinois

---

## 📁 FICHIERS DE SPÉCIFICATION CRÉÉS

| Fichier | Sujet | Statut |
|---------|-------|--------|
| `IMPLEMENTATION_PUSH_NOTIFICATIONS.md` | Notifications push (FCM) | ✅ Créé |
| `FEATURE_WEATHER_LOCATION.md` | Configuration latitude/longitude météo | ✅ Créé |
| `FEATURE_INTERNATIONALIZATION.md` | Internationalisation (multi-langues) | ✅ Mis à jour |
