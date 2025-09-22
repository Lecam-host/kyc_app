#  KYC Flutter App

Application mobile Flutter permettant de gérer un processus **KYC (Know Your Customer)** avec :
-  Authentification (login / register)
-  Collecte d’informations personnelles (nom, date de naissance, nationalité…)
-  Capture de documents (recto / verso de la pièce d’identité)
-  Selfie pour validation faciale
-  Gestion **mode hors-ligne** (sauvegarde locale si pas de connexion)
-  Sécurisation et envoi vers l’API

---

##  Architecture

L’application suit une architecture **Clean Architecture + BLoC (Cubit)** :

lib/
│── core/ # Config globale (routes, services, utils, dio client)
│── features/
│ ├── auth/ # Authentification
│ │ ├── data/ # Models, datasources
│ │ ├── domain/ # Entities, usecases
│ │ └── presentation # UI + Cubits
│ ├── kyc/ # Module KYC
│ │ ├── data/ # Models, datasources
│ │ ├── domain/ # Entities, usecases
│ │ └── presentation # UI + Cubits + Pages
│── shared/ # Widgets réutilisables



L’application suit une Clean Architecture adaptée à Flutter, avec une séparation stricte entre les couches.
L’objectif est de garantir un code maintenable, testable et scalable.

### Injection de dépendances avec `get_it`
- Utilisé comme **Service Locator** pour centraliser la création et la gestion des instances.  
- Cela permet de découpler la logique métier (UseCases, Repositories) des composants UI.  

# Organisation des couches
1. Domain

Contient uniquement les règles métiers de l’application.

Indépendant de toute implémentation technique.

Éléments :

Entities → objets métiers purs (ex: UserEntity, KycEntity)

UseCases → logique métier encapsulée (ex: LoginUseCase, SendKycUseCase)

Interfaces des repositories (contrats).

2. Data

Contient les implémentations concrètes liées aux données.

Éléments :

Models → représentent les données JSON / API (ex: UserModel, KycModel)

Repositories Impl. → implémentent les contrats du domaine

DataSources → communication avec l’extérieur :

RemoteDataSource (API via Dio)

LocalDataSource (Hive / SecureStorage)

3. Presentation

Contient tout ce qui est lié à l’interface utilisateur et à l’interaction utilisateur.

Éléments :

Cubit/BLoC → gestion d’état réactive

Pages → écrans (ex: LoginPage, KycScreen, DashboardScreen)

Widgets → composants UI réutilisables (ex: TextFieldWidget, DateFieldWidget)

# Flux de données

L’utilisateur interagit avec la Vue (ex: clique sur "Login").

La Vue appelle un Cubit qui déclenche un UseCase.

Le UseCase utilise le Repository (contrat).

Le Repository décide s’il faut appeler le RemoteDataSource (API via Dio) ou le LocalDataSource (Hive/SecureStorage).

La réponse est renvoyée au Cubit, qui met à jour l’UI via un State (AuthLoading, AuthAuthenticated, KycSavedLocal, etc.).



##  Installation & Exécution

### 1️ Prérequis
Avant de commencer, assurez-vous d’avoir installé tout l'environnement neccessaire pour executer un projet flutter

### 2️ Cloner le projet
```bash
git clone https://github.com/votre-repo/kyc_app.git
cd kyc_app

flutter pub get

Configurer les variables d’environnement

Créer un fichier .env à la racine du projet avec vos clés API et URL backend :  base_url=https://votre-api-kyc.com/api


##  Gestion du Mode Hors-Ligne

L’application prend en charge le mode hors-ligne afin de permettre à l’utilisateur de continuer son parcours même sans connexion Internet.  

###  Données sécurisées avec `flutter_secure_storage`
- Les informations sensibles comme le `token d’authentification` ou l’`email de l’utilisateur` sont stockées dans SecureStorage.  
- `flutter_secure_storage` chiffre automatiquement les données (AES pour Android, Keychain pour iOS).  
- À chaque démarrage, l’application vérifie si un utilisateur est déjà connecté en lisant les informations dans `SecureStorage`.  




## 📦 Librairies utilisées

Voici les principales dépendances utilisées dans ce projet :

- **[http](https://pub.dev/packages/http)** (^1.5.0) → Appels réseau simples
- **[dio](https://pub.dev/packages/dio)** (^5.9.0) → Client HTTP avancé avec interceptors et gestion des erreurs
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** (^9.1.1) → Gestion d’état avec BLoC / Cubit
- **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)** (^9.2.4) → Stockage sécurisé des tokens et infos sensibles
- **[go_router](https://pub.dev/packages/go_router)** (^16.2.1) → Navigation déclarative et gestion des routes
- **[get_it](https://pub.dev/packages/get_it)** → Injection de dépendances (Service Locator)
- **[data_connection_checker_tv](https://pub.dev/packages/data_connection_checker_tv)** (^0.3.5-nullsafety) → Vérification de la connexion internet
- **[pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger)** (^1.4.0) → Logger lisible pour les requêtes/réponses HTTP
- **[flutter_dotenv](https://pub.dev/packages/flutter_dotenv)** (^6.0.0) → Gestion des variables d’environnement (.env)
- **[equatable](https://pub.dev/packages/equatable)** (^2.0.7) → Simplifie les comparaisons dans les entités et états BLoC
- **[country_code_picker](https://pub.dev/packages/country_code_picker)** (^3.4.0) → Sélecteur de pays/nationalité avec drapeaux
- **[camera](https://pub.dev/packages/camera)** (^0.11.2) → Capture de photos et vidéos (KYC documents / selfie)
- **[permission_handler](https://pub.dev/packages/permission_handler)** (^12.0.1) → Gestion des permissions (caméra, stockage, etc.)
- **[fluttertoast](https://pub.dev/packages/fluttertoast)** (^8.2.14) → Notifications simples (toast)
- **[form_field_validator](https://pub.dev/packages/form_field_validator)** (^1.1) → Validations de formulaires

---

⚡ Ces librairies assurent la **robustesse**, la **sécurité**, la **gestion hors-ligne**, et une **expérience utilisateur fluide**.
