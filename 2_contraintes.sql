-- Fichier : 2_contraintes.sql
-- Projet : Plateforme de billetterie et gestion d'événements
-- Auteurs : GIRAULT Paul et LAFARGE Edouard

-- =======================================================
-- 1. CONTRAINTES DE VALIDATION (CHECK)
-- =======================================================

-- Format basique des emails (Organisateur et Participant)
ALTER TABLE ORGANISATEUR
ADD CONSTRAINT chk_email_organisateur CHECK (email LIKE '%@%.%');

ALTER TABLE PARTICIPANT
ADD CONSTRAINT chk_email_participant CHECK (email LIKE '%@%.%');

-- Cohérence des dates pour un événement : la fin doit être après le début
ALTER TABLE EVENEMENT
ADD CONSTRAINT chk_dates_evenement CHECK (date_heure_fin > date_heure_debut);

-- La capacité d'un lieu doit obligatoirement être strictement positive
ALTER TABLE LIEU
ADD CONSTRAINT chk_capacite_lieu CHECK (capacite_max > 0);

-- Les prix et montants ne peuvent pas être négatifs
ALTER TABLE Billet
ADD CONSTRAINT chk_prix_billet CHECK (prix_unitaire >= 0);

ALTER TABLE PAIEMENT
ADD CONSTRAINT chk_montant_paiement CHECK (montant_total >= 0);

-- Restriction sur le type de billet (énumération selon votre règle métier)
ALTER TABLE Billet
ADD CONSTRAINT chk_type_billet CHECK (type_billet IN ('VIP', 'Standard', 'Etudiant', 'Early Bird'));


-- =======================================================
-- 2. CONTRAINTES COMPLEXES (TRIGGERS)
-- =======================================================
-- Traduction de la règle métier stricte : 
-- "Le nombre total de billets vendus pour un événement ne peut jamais dépasser la capacité du lieu."

DELIMITER //

CREATE TRIGGER verifier_capacite_avant_achat
BEFORE INSERT ON Billet
FOR EACH ROW
BEGIN
    DECLARE capacite_max_lieu INT;
    DECLARE nb_billets_vendus INT;

    -- Récupérer la capacité max du lieu où se déroule l'événement lié au nouveau billet
    SELECT L.capacite_max INTO capacite_max_lieu
    FROM EVENEMENT E
    JOIN LIEU L ON E.id_lieu = L.id_lieu
    WHERE E.id_evenement = NEW.id_evenement;

    -- Compter combien de billets ont déjà été émis pour cet événement
    SELECT COUNT(*) INTO nb_billets_vendus
    FROM Billet
    WHERE id_evenement = NEW.id_evenement;

    -- Si l'ajout de ce billet dépasse la capacité, on bloque l'insertion
    IF nb_billets_vendus >= capacite_max_lieu THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur métier : La capacité maximale du lieu est atteinte. Impossible de vendre un billet supplémentaire pour cet événement.';
    END IF;
END;
//

DELIMITER ;