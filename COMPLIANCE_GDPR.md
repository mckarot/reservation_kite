# COMPLIANCE GDPR — RESERVATION KITE

## 1. DONNÉES COLLECTÉES & FINALITÉ
- **Identité** : Nom, Prénom, Email, Photo (Auth & Profil).
- **Données Physiques** : Poids (kg) — Finalité : Sélection du matériel de kite adapté (sécurité).
- **Données Professionnelles (Staff)** : Bio, Photos, Diplômes — Finalité : Présentation commerciale aux élèves.
- **Suivi Pédagogique** : Progression IKO, notes des moniteurs — Finalité : Continuité pédagogique.
- **Transactions** : Historique des paiements manuels — Finalité : Comptabilité et gestion du wallet.

## 2. DURÉE DE RÉTENTION
- **Comptes utilisateurs** : Jusqu'à 3 ans d'inactivité ou demande de suppression.
- **Données de progression** : 5 ans (pour permettre aux élèves de reprendre après une pause longue).
- **Données de transaction** : 10 ans (obligation légale comptable).
- **Staff** : Suppression immédiate de la bio et des photos en cas de départ, anonymisation des liens dans les anciennes sessions.

## 3. DROITS DES UTILISATEURS
- **Droit d'accès** : L'utilisateur peut consulter ses données via son profil et son carnet de progression.
- **Droit à l'oubli** : 
    - Bouton de suppression de compte dans l'application.
    - Suppression irréversible des données d'identité.
    - Conservation anonymisée des sessions pour les statistiques de l'école.
- **Droit de rectification** : Modification libre du profil (poids, photo, nom).

## 4. SÉCURITÉ DES DONNÉES
- **Firebase Auth** : Gestion sécurisée des identifiants.
- **App Check** : Protection contre l'accès non autorisé aux API Firebase.
- **Règles de sécurité Firestore** : Accès restreint (l'élève ne voit que ses données, le staff voit les élèves de sa session, l'admin voit tout).

## 5. CONTACT
- Responsable du traitement : Administrateur de l'école (Contact via l'application).
