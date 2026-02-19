# Mini-Projet BDD : Conception d'un Système de Gestion d'Événements

**Membres du binôme :** GIRAULT Paul et LAFARGE Edouard 
**Date :** 27/02/26  
**Sujet :** Plateforme de billetterie et gestion d'événements (Type Eventbrite/Weezevent)

---

## 1. Description du Domaine et du Métier

L'objectif de ce projet est de concevoir le système d'information d'une entreprise privée spécialisée dans la **gestion d'événements culturels et professionnels et la billetterie en ligne**.

### Fonctionnement de l'entreprise
Cette entreprise agit comme une plateforme intermédiaire (similaire à Eventbrite ou Weezevent) facilitant la relation entre des organisateurs d'événements et des participants.

Son activité s'articule autour de plusieurs axes :
* **La gestion des organisateurs :** Enregistrement des professionnels, gestion de partenariats entre eux, et supervision des nouveaux organisateurs par des mentors expérimentés.
* **La planification d'événements :** Création de fiches événements (concerts, festivals, conférences), gestion des dates, des descriptions et catégorisation.
* **La gestion des lieux :** Administration d'une base de données de lieux physiques avec des contraintes strictes de capacité (jauge de sécurité).
* **La billetterie :** Vente de billets en ligne, gestion des types de tarifs (VIP, Standard, etc.) et émission de titres d'accès uniques (QR Codes).
* **Le suivi des transactions :** Gestion des paiements effectués par les participants pour l'achat de billets.

---

## 2. Prompt Engineering

Pour réaliser l'analyse des besoins, nous avons utilisé le framework RICARDO afin d'obtenir de l'IA générative les règles de gestion précises et le dictionnaire de données nécessaire à la méthode MERISE.

| Lettre | Signification | Détail du prompt utilisé |
| :--- | :--- | :--- |
| **R** | **Rôle** | Tu es un analyste fonctionnel expert en conception de bases de données et spécialiste de la méthode MERISE. Tu as une grande expérience dans le secteur de l'événementiel. |
| **I** | **Instructions** | Ton objectif est de réaliser la phase d'analyse des besoins pour un étudiant en ingénierie. Tu dois fournir : <br>1. Une liste structurée de règles de gestion.<br>2. Un dictionnaire de données complet. |
| **C** | **Contexte** | L'entreprise est une plateforme de billetterie en ligne (type Eventbrite). Elle gère des organisateurs, des événements, des lieux (avec capacité limitée), des participants, des billets et des paiements. |
| **A** | **Additionnel** (Contraintes) | - Les règles doivent inclure des notions de supervision entre organisateurs (récursivité).<br>- Il doit y avoir des partenariats entre organisateurs.<br>- Le dictionnaire doit contenir entre 25 et 35 données.<br>- Préciser le type (VARCHAR, INT, DATE...) et la taille pour chaque donnée. |
| **R** | **Références** | Inspire-toi du fonctionnement standard des plateformes de e-commerce et de gestion de spectacles pour la logique métier. |
| **D** | **Désiré** (Format) | - Règles de gestion sous forme de liste à puces.<br>- Dictionnaire de données sous forme de tableau (Signification, Type, Taille). |
| **O** | **Objectifs** | Fournir la matière première nécessaire pour construire un MCD normalisé incluant des relations n-aires et réflexives. |

---

## 3. Résultat de l'Analyse des Besoins

Voici les éléments générés par l'IA suite au prompt, qui serviront de base à la construction du MCD.

### 3.1 Règles de Gestion

**Organisateurs :**
* Un organisateur possède un compte unique sur la plateforme.
* Un organisateur peut créer et gérer plusieurs événements.
* Chaque événement est créé et géré par un seul organisateur principal.
* **Partenariats :** Un organisateur peut être en partenariat avec plusieurs autres organisateurs (relation n-aire ou binaire).
* **Supervision :** Un organisateur expérimenté peut superviser plusieurs organisateurs débutants (relation réflexive). Un organisateur débutant ne peut avoir qu'un seul superviseur au maximum.

**Événements et Lieux :**
* Un événement se déroule dans un seul lieu.
* Un lieu peut accueillir plusieurs événements à des dates différentes.
* Chaque lieu possède une capacité maximale stricte (jauge).
* Le nombre total de billets vendus pour un événement ne peut jamais dépasser la capacité du lieu.
* Un événement peut être classé dans une ou plusieurs catégories (ex: Concert, Plein air).

**Participants et Billetterie :**
* Un participant est identifié par ses informations personnelles et peut acheter un ou plusieurs billets.
* Un billet appartient obligatoirement à un seul participant (nominatif).
* Un billet donne accès à un seul événement spécifique.
* Un billet possède un type (VIP, Standard...) et un prix unitaire.

**Paiements :**
* Un paiement est généré lors de l'achat de billets.
* Un paiement peut regrouper l'achat de plusieurs billets simultanément.
* Un billet est lié à un seul paiement.

### 3.2 Dictionnaire de Données

Le dictionnaire contient 32 données brutes identifiées pour le système.

| Signification de la donnée | Type | Taille |
| :--- | :--- | :--- |
| **Identité de l'Organisateur** | | |
| Nom de l'entreprise ou structure | VARCHAR | 100 |
| Nom du contact organisateur | VARCHAR | 50 |
| Prénom du contact organisateur | VARCHAR | 50 |
| Email de l'organisateur | VARCHAR | 100 |
| Numéro de téléphone | VARCHAR | 15 |
| Date de création du compte | DATE | - |
| **Informations sur le Lieu** | | |
| Nom du lieu (ex: Zénith) | VARCHAR | 100 |
| Adresse postale du lieu | VARCHAR | 150 |
| Code postal | VARCHAR | 10 |
| Ville | VARCHAR | 50 |
| Capacité maximale (jauge) | INT | 6 |
| Accessible PMR | BOOLEAN | 1 |
| **Détails de l'Événement** | | |
| Titre de l'événement | VARCHAR | 150 |
| Description détaillée | VARCHAR | 2000 |
| Date et heure de début | DATETIME | - |
| Date et heure de fin | DATETIME | - |
| Publié en ligne (Oui/Non) | BOOLEAN | 1 |
| **Catégories** | | |
| Nom de la catégorie | VARCHAR | 50 |
| Description de la catégorie | VARCHAR | 255 |
| **Informations Participant** | | |
| Nom du participant | VARCHAR | 50 |
| Prénom du participant | VARCHAR | 50 |
| Email du participant | VARCHAR | 100 |
| Date de naissance | DATE | - |
| Abonné Newsletter | BOOLEAN | 1 |
| **Billets** | | |
| Code unique (QR/Barre) | VARCHAR | 50 |
| Type de billet (VIP, Standard) | VARCHAR | 50 |
| Prix unitaire | DECIMAL | 6,2 |
| Date d'émission | DATE | - |
| Scanné à l'entrée | BOOLEAN | 1 |
| **Paiements** | | |
| Numéro de transaction | VARCHAR | 50 |
| Montant total payé | DECIMAL | 8,2 |
| Moyen de paiement | VARCHAR | 30 |

---

<img width="1343" height="737" alt="image" src="https://github.com/user-attachments/assets/5411f2c8-6657-42d5-8048-a45f3c70c401" />
