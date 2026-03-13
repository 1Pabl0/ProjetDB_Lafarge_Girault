-- Fichier : 1_creation.sql
-- Projet : Plateforme de billetterie et gestion d'événements
-- Auteurs : GIRAULT Paul et LAFARGE Edouard

-- 1. Nettoyage préalable (pour éviter les erreurs lors de l'exécution multiple)
DROP TABLE IF EXISTS Classifier;
DROP TABLE IF EXISTS Billet;
DROP TABLE IF EXISTS PAIEMENT;
DROP TABLE IF EXISTS PARTICIPANT;
DROP TABLE IF EXISTS CATEGORIE;
DROP TABLE IF EXISTS EVENEMENT;
DROP TABLE IF EXISTS LIEU;
DROP TABLE IF EXISTS ORGANISATEUR;

-- 2. Création des tables indépendantes (sans clés étrangères)

CREATE TABLE ORGANISATEUR (
    id_organisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom_entreprise VARCHAR(100) NOT NULL,
    nom_contact VARCHAR(50),
    prenom_contact VARCHAR(50),
    email VARCHAR(100) NOT NULL,
    telephone VARCHAR(15),
    date_creation_compte DATE,
    id_superviseur INT,
    -- Contrainte réflexive pour la supervision (0,1)
    CONSTRAINT fk_organisateur_superviseur FOREIGN KEY (id_superviseur) 
        REFERENCES ORGANISATEUR(id_organisateur) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

CREATE TABLE LIEU (
    id_lieu INT AUTO_INCREMENT PRIMARY KEY,
    nom_lieu VARCHAR(100) NOT NULL,
    adresse VARCHAR(150),
    code_postal VARCHAR(10),
    ville VARCHAR(50),
    capacite_max INT NOT NULL,
    accessible_PMR BOOLEAN
);

CREATE TABLE CATEGORIE (
    id_categorie INT AUTO_INCREMENT PRIMARY KEY,
    nom_categorie VARCHAR(50) NOT NULL,
    description_categorie VARCHAR(255)
);

CREATE TABLE PARTICIPANT (
    id_participant INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    date_naissance DATE,
    newsletter BOOLEAN
);

CREATE TABLE PAIEMENT (
    id_paiement INT AUTO_INCREMENT PRIMARY KEY,
    numero_transaction VARCHAR(50) NOT NULL,
    montant_total DECIMAL(8,2) NOT NULL,
    moyen_paiement VARCHAR(30)
);

-- 3. Création des tables dépendantes (avec clés étrangères)

CREATE TABLE EVENEMENT (
    id_evenement INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(150) NOT NULL,
    description VARCHAR(2000),
    date_heure_debut DATETIME NOT NULL,
    date_heure_fin DATETIME NOT NULL,
    publie BOOLEAN,
    id_organisateur INT NOT NULL,
    id_lieu INT NOT NULL,
    -- Un événement est obligatoirement lié à un organisateur et un lieu (1,1)
    CONSTRAINT fk_evenement_organisateur FOREIGN KEY (id_organisateur) 
        REFERENCES ORGANISATEUR(id_organisateur) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_evenement_lieu FOREIGN KEY (id_lieu) 
        REFERENCES LIEU(id_lieu) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Classifier (
    id_evenement INT,
    id_categorie INT,
    PRIMARY KEY (id_evenement, id_categorie),
    CONSTRAINT fk_classifier_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_classifier_categorie FOREIGN KEY (id_categorie) 
        REFERENCES CATEGORIE(id_categorie) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Billet (
    code_billet VARCHAR(50) PRIMARY KEY,
    prix_unitaire DECIMAL(6,2) NOT NULL,
    date_emission DATE,
    scanne BOOLEAN DEFAULT FALSE,
    type_billet VARCHAR(50),
    id_evenement INT NOT NULL,
    id_participant INT NOT NULL,
    id_paiement INT NOT NULL,
    -- Un billet est obligatoirement lié à un événement, un participant et un paiement (1,1)
    CONSTRAINT fk_billet_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_billet_participant FOREIGN KEY (id_participant) 
        REFERENCES PARTICIPANT(id_participant) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_billet_paiement FOREIGN KEY (id_paiement) 
        REFERENCES PAIEMENT(id_paiement) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);