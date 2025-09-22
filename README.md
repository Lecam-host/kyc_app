#  KYC Flutter App

Application mobile Flutter permettant de gérer un processus **KYC (Know Your Customer)** avec :
-  Authentification (login / register)
-  Collecte d’informations personnelles (nom, date de naissance, nationalité…)
-  Capture de documents (recto / verso de la pièce d’identité)
-  Selfie pour validation faciale
-  Gestion **mode hors-ligne** (sauvegarde locale si pas de connexion)
-  Sécurisation et envoi vers l’API

---

###  Architecture

L’application repose sur Clean Architecture + BLoC (Cubit) afin de garantir :

un code modulaire (chaque couche a une responsabilité claire),

un code testable (la logique métier peut être testée indépendamment),

un code scalable (facile à faire évoluer).

- Découpage en couches

Presentation (UI + State Management)

Pages (écrans) et Widgets (composants réutilisables).

Cubit/BLoC pour gérer les états (ex: AuthCubit, KycCubit).

Cette couche observe l’état et réagit aux événements de l’utilisateur.

Domain (Business Logic)

Entities : objets métiers purs (ex: UserEntity, KycEntity).

UseCases : encapsulent une action métier (ex: LoginUseCase, SendKycUseCase).

Repositories (interfaces) : définissent les contrats d’accès aux données, sans dépendre d’une implémentation.

Data (Implémentation des données)

Models : mappent les JSON/API ou données locales (ex: UserModel, KycModel).

Repositories Impl. : implémentent les contrats du domaine.

DataSources :

RemoteDataSource : appels API (via Dio).

LocalDataSource : stockage local (SecureStorage).

- Flux de données

L’utilisateur interagit avec l’UI (ex: bouton “Soumettre KYC”).

L’UI appelle un Cubit, qui déclenche un UseCase.

Le UseCase demande les données au Repository.

Le Repository choisit la source (API ou local).

La réponse remonte → UseCase → Cubit → UI.

L’UI se met à jour automatiquement avec le nouvel état.

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

git clone 
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

### Internationalisation (i18n) — détection automatique

L’app supporte l'anglais et le français. Elle détecte automatiquement la langue du téléphone au démarrage. Si la langue n’est pas supportée, elle bascule sur une langue de secours (Anglais).


## Librairies utilisées

http (^1.5.0) — Appels réseau simples

dio (^5.9.0) — Client HTTP avancé (interceptors, timeout)

flutter_bloc (^9.1.1) — Gestion d’état BLoC/Cubit

flutter_secure_storage (^9.2.4) — Stockage sécurisé

go_router (^16.2.1) — Navigation déclarative

get_it — Injection de dépendances

data_connection_checker_tv (^0.3.5-nullsafety) — Vérification connexion

pretty_dio_logger (^1.4.0) — Logs HTTP lisibles

flutter_dotenv (^6.0.0) — Variables d’environnement

equatable (^2.0.7) — Comparaisons d’états/objets

country_code_picker (^3.4.0) — Sélecteur de pays

camera (^0.11.2) — Capture documents / selfie

permission_handler (^12.0.1) — Permissions natives

fluttertoast (^8.2.14) — Notifications Toast

form_field_validator (^1.1) — Validation de formulaires

 Ces librairies assurent la robustesse, la sécurité, la gestion hors-ligne, et une expérience utilisateur fluide.
