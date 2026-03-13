-- Fichier : 3_insertion.sql
-- Projet : Plateforme de billetterie et gestion d'événements
-- Auteurs : GIRAULT Paul et LAFARGE Edouard

-- 1. INSERTION DES ORGANISATEURS
-- Insertion des superviseurs (mentors)
INSERT INTO ORGANISATEUR (nom_entreprise, nom_contact, prenom_contact, email, telephone, date_creation_compte, id_superviseur) VALUES 
('Live Nation France', 'Dupont', 'Jean', 'jean.dupont@livenation.fr', '0123456789', '2020-05-12', NULL),
('Alias Production', 'Martin', 'Sophie', 'smartin@alias.fr', '0198765432', '2019-11-23', NULL);

-- Insertion des organisateurs supervisés
INSERT INTO ORGANISATEUR (nom_entreprise, nom_contact, prenom_contact, email, telephone, date_creation_compte, id_superviseur) VALUES 
('Indie Fest Corp', 'Durand', 'Lucas', 'contact@indiefest.com', '0612345678', '2023-01-15', 1),
('Scène Locale', 'Petit', 'Emma', 'emma@scenelocale.fr', '0698765432', '2023-08-04', 2);

-- 2. INSERTION DES LIEUX
INSERT INTO LIEU (nom_lieu, adresse, code_postal, ville, capacite_max, accessible_PMR) VALUES 
('Zénith de Paris', '211 Avenue Jean Jaurès', '75019', 'Paris', 6804, TRUE),
('Le Bataclan', '50 Boulevard Voltaire', '75011', 'Paris', 1500, TRUE),
('Stade Vélodrome', '3 Boulevard Michelet', '13008', 'Marseille', 67394, TRUE);

-- 3. INSERTION DES CATEGORIES
INSERT INTO CATEGORIE (nom_categorie, description_categorie) VALUES 
('Concert', 'Concerts de musique live tous genres confondus.'),
('Festival', 'Événements s\'étalant sur plusieurs jours avec plusieurs artistes.'),
('Humour / Stand-up', 'Spectacles d\'humour et one-man shows.');

-- 4. INSERTION DES PARTICIPANTS
INSERT INTO PARTICIPANT (nom, prenom, email, date_naissance, newsletter) VALUES 
('Lafayette', 'Marquis', 'mlafayette@email.com', '1990-04-12', TRUE),
('Baudelaire', 'Charles', 'cbaudelaire@email.com', '1985-09-23', FALSE),
('Curie', 'Marie', 'mcurie@email.com', '1995-11-05', TRUE);

-- 5. INSERTION DES PAIEMENTS
INSERT INTO PAIEMENT (numero_transaction, montant_total, moyen_paiement) VALUES 
('TXN-987654321A', 150.00, 'Carte Bancaire'),
('TXN-123456789B', 45.00, 'PayPal'),
('TXN-555555555C', 90.00, 'Carte Bancaire');

-- 6. INSERTION DES EVENEMENTS
INSERT INTO EVENEMENT (titre, description, date_heure_debut, date_heure_fin, publie, id_organisateur, id_lieu) VALUES 
('Festival Rock en Seine 2026', 'Le plus grand festival rock de l\'été.', '2026-08-25 14:00:00', '2026-08-28 23:59:00', TRUE, 1, 1),
('Concert Orelsan Tour', 'Tournée exceptionnelle.', '2026-10-15 20:00:00', '2026-10-15 23:30:00', TRUE, 2, 2);

-- 7. INSERTION CLASSIFICATION (Table de jointure)
INSERT INTO Classifier (id_evenement, id_categorie) VALUES 
(1, 1), -- Rock en Seine est un Concert
(1, 2), -- Rock en Seine est un Festival
(2, 1); -- Orelsan est un Concert

-- 8. INSERTION DES BILLETS
INSERT INTO Billet (code_billet, prix_unitaire, date_emission, scanne, type_billet, id_evenement, id_participant, id_paiement) VALUES 
('QR-ROCK-001', 150.00, '2026-03-01', FALSE, 'VIP', 1, 1, 1),
('QR-OREL-001', 45.00, '2026-03-02', FALSE, 'Standard', 2, 2, 2),
('QR-OREL-002', 45.00, '2026-03-02', FALSE, 'Standard', 2, 3, 3),
('QR-OREL-003', 45.00, '2026-03-02', FALSE, 'Standard', 2, 1, 3);