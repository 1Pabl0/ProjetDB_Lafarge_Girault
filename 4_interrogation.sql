-- Fichier : 4_interrogation.sql
-- Projet : Plateforme de billetterie et gestion d'événements
-- Auteurs : GIRAULT Paul et LAFARGE Edouard
-- Scénario : Analyse des ventes et de l'activité par l'Administrateur Plateforme

-- ============================================================================
-- A. SÉLECTIONS, PROJECTIONS, TRI, DISTINCT, LIKE, IN, BETWEEN (Au moins 5)
-- ============================================================================

-- 1. (LIKE) Chercher tous les participants ayant une adresse email Gmail.
SELECT nom, prenom, email 
FROM PARTICIPANT 
WHERE email LIKE '%@gmail.com';

-- 2. (BETWEEN) Lister les événements prévus entre le 1er juin 2026 et le 31 décembre 2026, triés par date.
SELECT titre, date_heure_debut 
FROM EVENEMENT 
WHERE date_heure_debut BETWEEN '2026-06-01 00:00:00' AND '2026-12-31 23:59:59'
ORDER BY date_heure_debut ASC;

-- 3. (IN) Trouver les lieux situés dans les plus grandes villes ciblées par la plateforme.
SELECT nom_lieu, ville, capacite_max 
FROM LIEU 
WHERE ville IN ('Paris', 'Marseille', 'Lyon', 'Bordeaux');

-- 4. (DISTINCT) Connaître la liste unique des moyens de paiement utilisés sur la plateforme.
SELECT DISTINCT moyen_paiement 
FROM PAIEMENT;

-- 5. (Tri et conditions multiples) Lister les billets 'VIP' qui n'ont pas encore été scannés, du plus cher au moins cher.
SELECT code_billet, prix_unitaire, date_emission 
FROM Billet 
WHERE type_billet = 'VIP' AND scanne = FALSE
ORDER BY prix_unitaire DESC;

-- ============================================================================
-- B. FONCTIONS D'AGRÉGATION, GROUP BY ET HAVING (Au moins 5)
-- ============================================================================

-- 6. Calculer le chiffre d'affaires total généré par chaque moyen de paiement.
SELECT moyen_paiement, SUM(montant_total) AS chiffre_affaires
FROM PAIEMENT
GROUP BY moyen_paiement;

-- 7. Compter le nombre de billets vendus par événement, uniquement pour les événements ayant vendu plus de 50 billets.
SELECT id_evenement, COUNT(code_billet) AS nombre_billets_vendus
FROM Billet
GROUP BY id_evenement
HAVING COUNT(code_billet) > 50;

-- 8. Trouver la capacité moyenne des lieux par ville, pour les villes ayant une capacité moyenne supérieure à 1000 places.
SELECT ville, AVG(capacite_max) AS capacite_moyenne
FROM LIEU
GROUP BY ville
HAVING AVG(capacite_max) > 1000;

-- 9. Connaître le nombre d'événements créés par chaque organisateur (identifiant).
SELECT id_organisateur, COUNT(id_evenement) AS total_evenements
FROM EVENEMENT
GROUP BY id_organisateur;

-- 10. Trouver le prix du billet le plus cher et le moins cher vendus sur la plateforme.
SELECT MAX(prix_unitaire) AS billet_le_plus_cher, MIN(prix_unitaire) AS billet_le_moins_cher
FROM Billet;

-- ============================================================================
-- C. JOINTURES INTERNES, EXTERNES, SIMPLES, MULTIPLES (Au moins 5)
-- ============================================================================

-- 11. (Jointure interne simple) Afficher les titres des événements et les noms des lieux où ils se déroulent.
SELECT E.titre, L.nom_lieu, L.ville
FROM EVENEMENT E
INNER JOIN LIEU L ON E.id_lieu = L.id_lieu;

-- 12. (Jointure multiple) Obtenir la liste complète des billets avec le nom du participant et le titre de l'événement.
SELECT B.code_billet, P.nom, P.prenom, E.titre
FROM Billet B
INNER JOIN PARTICIPANT P ON B.id_participant = P.id_participant
INNER JOIN EVENEMENT E ON B.id_evenement = E.id_evenement;

-- 13. (Jointure externe - LEFT) Lister TOUS les organisateurs, et les événements qu'ils organisent (même ceux qui n'ont encore rien créé).
SELECT O.nom_entreprise, E.titre
FROM ORGANISATEUR O
LEFT JOIN EVENEMENT E ON O.id_organisateur = E.id_organisateur;

-- 14. (Auto-jointure / Jointure réflexive - LEFT) Afficher les organisateurs et le nom de leur superviseur (mentor) s'ils en ont un.
SELECT O1.nom_entreprise AS Organisateur_Debutant, O2.nom_entreprise AS Superviseur
FROM ORGANISATEUR O1
LEFT JOIN ORGANISATEUR O2 ON O1.id_superviseur = O2.id_organisateur;

-- 15. (Jointure multiple avec table associative) Lister les événements et leurs catégories associées.
SELECT E.titre, C.nom_categorie
FROM EVENEMENT E
INNER JOIN Classifier CL ON E.id_evenement = CL.id_evenement
INNER JOIN CATEGORIE C ON CL.id_categorie = C.id_categorie;

-- ============================================================================
-- D. REQUÊTES IMBRIQUÉES : (NOT) IN, (NOT) EXISTS, ANY, ALL (Au moins 5)
-- ============================================================================

-- 16. (IN) Lister les participants qui ont acheté au moins un billet pour l'événement "Festival Rock en Seine 2026".
SELECT nom, prenom 
FROM PARTICIPANT 
WHERE id_participant IN (
    SELECT id_participant 
    FROM Billet 
    WHERE id_evenement = (SELECT id_evenement FROM EVENEMENT WHERE titre = 'Festival Rock en Seine 2026')
);

-- 17. (NOT EXISTS) Trouver les lieux qui n'ont aucun événement programmé (lieux vides).
SELECT nom_lieu, ville 
FROM LIEU L
WHERE NOT EXISTS (
    SELECT 1 
    FROM EVENEMENT E 
    WHERE E.id_lieu = L.id_lieu
);

-- 18. (ALL) Trouver le ou les billets dont le prix unitaire est supérieur ou égal à tous les autres billets (le billet le plus cher, via imbrication).
SELECT code_billet, prix_unitaire 
FROM Billet 
WHERE prix_unitaire >= ALL (SELECT prix_unitaire FROM Billet);

-- 19. (ANY / SOME) Lister les organisateurs qui ont programmé au moins un événement dans la ville de 'Paris'.
SELECT nom_entreprise 
FROM ORGANISATEUR 
WHERE id_organisateur = ANY (
    SELECT E.id_organisateur 
    FROM EVENEMENT E 
    INNER JOIN LIEU L ON E.id_lieu = L.id_lieu 
    WHERE L.ville = 'Paris'
);

-- 20. (NOT IN) Trouver les participants qui n'ont jamais acheté de billet de type 'VIP'.
SELECT nom, prenom 
FROM PARTICIPANT 
WHERE id_participant NOT IN (
    SELECT id_participant 
    FROM Billet 
    WHERE type_billet = 'VIP'
);