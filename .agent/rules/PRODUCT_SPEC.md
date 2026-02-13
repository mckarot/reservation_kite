---
trigger: always_on
---

# PRODUCT_SPEC.md — SYSTÈME DE RÉSERVATION & ECOSYSTÈME KITE SURF

## 1. VISION DU PRODUIT
Application de gestion complète pour école de Kite Surf : réservations, abonnements, suivi pédagogique et **gestion administrative dynamique** (Staff & Horaires).

---

## 2. ACTEURS (ROLES)
- **Élève** : Réserve, choisit son moniteur (si disponible), consulte ses crédits.
- **Moniteur** : Gère son profil/présentation et ses disponibilités.
- **Administrateur** : Pilote l'école via un **Panneau de Contrôle** (Horaires, Staff, Finances).

---

## 3. FONCTIONNALITÉS DÉTAILLÉES

### A. Panneau de Contrôle Admin (Global Settings)
- **Gestion des Horaires** : 
    - Modification des heures d'ouverture/fermeture globales.
    - Activation/Désactivation des demi-journées (ex: Fermeture exceptionnelle le mardi matin).
- **Gestion du Staff** : 
    - Ajout/Suppression de moniteurs dans l'effectif.
    - Définition du nombre maximum d'élèves par moniteur (Défaut: 4).

### B. Fiches de Présentation Moniteurs
- **Côté Admin/Moniteur** : Saisie d'une bio, photo, spécialités (Strapless, Freestyle, Foil) et diplômes.
- **Côté Élève** : Interface de consultation des profils moniteurs.
- **Choix du Moniteur** : Lors de la réservation, l'élève peut sélectionner un moniteur spécifique parmi ceux disponibles sur le slot (Optionnel).

### C. Gestion RH & Disponibilités
- **Slots de Travail** : Matin (08h-12h) / Après-midi (13h-18h) — Ajustables via le Panneau de Contrôle.
- **Indisponibilités** : Grillage des slots par l'admin ou le staff (validation admin).

### D. Portefeuille (Wallet) & Abonnements
- Saisie libre des crédits par l'admin après paiement physique.
- Activation manuelle des abonnements.

### E. Système de Réservation & Carnet de Progression
- Calcul de capacité en temps réel (Nb moniteurs actifs sur le slot * Quota).
- Suivi pédagogique avec checklist IKO et notes après chaque cours.

---

## 4. CONTRAINTES TECHNIQUES & UX
- **CMS Dynamique** : Les fiches moniteurs et horaires sont stockées en base (Firestore) pour être modifiées sans mise à jour de l'app.
- **UI/UX** : Interface "Drag & Drop" ou "Switch" pour l'admin pour ouvrir/fermer les demi-journées rapidement.
- **Images** : Stockage des photos de profil sur Firebase Storage avec optimisation de taille.

---

## 5. RÈGLES MÉTIER (BUSINESS RULES)
- **Capacité Dynamique** : Si l'admin ajoute un 3ème moniteur sur un slot, la capacité de l'école passe automatiquement de 8 à 12 élèves.
- **Transparence** : Un moniteur mis en "Indisponible" disparaît automatiquement de la liste de choix pour les élèves sur ce slot.
- **Paiement** : Toujours physique, validé manuellement.