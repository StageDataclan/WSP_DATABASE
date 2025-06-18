/*
02_InsertDonnees.sql
Insertion de données dans les tables : PROFIL, SALARIE, TAB_CV
*/

-- Vider d'abord TAB_CV (car dépend de SALARIE)
DELETE FROM TAB_CV;
-- Puis vider SALARIE
DELETE FROM SALARIE;

-- Insertion des profils
-- Insertion des profils (inchangé)
INSERT INTO PROFIL (ID_PROFIL, LIBELLE_PROFIL) VALUES (1, 'MS .NET');
INSERT INTO PROFIL (ID_PROFIL, LIBELLE_PROFIL) VALUES (2, 'MS SharePoint');
INSERT INTO PROFIL (ID_PROFIL, LIBELLE_PROFIL) VALUES (3, 'MS Business Intelligence');
INSERT INTO PROFIL (ID_PROFIL, LIBELLE_PROFIL) VALUES (4, 'Web PHP');
INSERT INTO PROFIL (ID_PROFIL, LIBELLE_PROFIL) VALUES (5, 'Développement Mobile');

-- Insertion de salariés avec vrais prénoms et noms
INSERT INTO SALARIE (MATRICULE, ID_PROFIL, NOM, PRENOM, DATE_NAISSANCE, DATE_DIPLOME, DATE_ENTREE) VALUES
    ('NET001', 1, 'Dupont', 'Alice', '1985-03-12', '2007-06-30', '2010-01-01'),
    ('NET002', 1, 'Martin', 'Lucas', '1982-07-22', '2005-09-15', '2011-02-15'),
                                                                                                       ('NET003', 1, 'Bernard', 'Sophie', '1987-11-05', '2009-07-01', '2012-03-10'),
                                                                                                       ('NET004', 1, 'Petit', 'Julien', '1984-01-19', '2006-12-20', '2013-04-20'),
                                                                                                       ('NET005', 1, 'Robert', 'Emma', '1986-05-30', '2008-05-15', '2014-05-25'),
                                                                                                       ('NET006', 1, 'Richard', 'Paul', '1983-09-14', '2007-01-10', '2015-06-30'),

                                                                                                       ('SP001', 2, 'Durand', 'Chloé', '1981-02-10', '2003-06-30', '2011-01-01'),
                                                                                                       ('SP002', 2, 'Lefebvre', 'Hugo', '1980-08-25', '2002-09-15', '2012-02-15'),
                                                                                                       ('SP003', 2, 'Moreau', 'Camille', '1982-12-17', '2004-07-01', '2013-03-10'),
                                                                                                       ('SP004', 2, 'Girard', 'Louis', '1983-04-09', '2005-12-20', '2014-04-20'),
                                                                                                       ('SP005', 2, 'Garcia', 'Léa', '1984-06-21', '2006-05-15', '2015-05-25'),
                                                                                                       ('SP006', 2, 'Martinez', 'Tom', '1985-10-13', '2007-01-10', '2016-06-30'),
                                                                                                       ('SP007', 2, 'Rodriguez', 'Sarah', '1986-03-02', '2008-03-20', '2017-07-15'),
                                                                                                       ('SP008', 2, 'Hernandez', 'Nathan', '1987-09-18', '2009-11-05', '2018-08-10'),

                                                                                                       ('BI001', 3, 'Lopez', 'Manon', '1982-01-11', '2004-06-30', '2012-01-01'),
                                                                                                       ('BI002', 3, 'Gonzalez', 'Enzo', '1983-05-23', '2005-09-15', '2013-02-15'),
                                                                                                       ('BI003', 3, 'Perez', 'Jade', '1984-10-16', '2006-07-01', '2014-03-10'),
                                                                                                       ('BI004', 3, 'Sanchez', 'Noah', '1985-02-28', '2007-12-20', '2015-04-20'),
                                                                                                       ('BI005', 3, 'Roux', 'Lina', '1986-06-09', '2008-05-15', '2016-05-25'),
                                                                                                       ('BI006', 3, 'David', 'Ethan', '1987-11-22', '2009-01-10', '2017-06-30'),
                                                                                                       ('BI007', 3, 'Bertrand', 'Anna', '1988-03-15', '2010-03-20', '2018-07-15'),
                                                                                                       ('BI008', 3, 'Morel', 'Lucas', '1989-07-27', '2011-11-05', '2019-08-10'),
                                                                                                       ('BI009', 3, 'Fournier', 'Eva', '1990-12-08', '2012-06-30', '2020-09-05'),

                                                                                                       ('PHP001', 4, 'Girault', 'Clara', '1983-01-14', '2005-06-30', '2013-01-01'),
                                                                                                       ('PHP002', 4, 'Lemoine', 'Axel', '1984-05-26', '2006-09-15', '2014-02-15'),
                                                                                                       ('PHP003', 4, 'Faure', 'Léna', '1985-10-19', '2007-07-01', '2015-03-10'),

                                                                                                       ('MOB001', 5, 'Chevalier', 'Malo', '1984-02-22', '2006-06-30', '2014-01-01'),
                                                                                                       ('MOB002', 5, 'Blanc', 'Inès', '1985-06-04', '2007-09-15', '2015-02-15'),
                                                                                                       ('MOB003', 5, 'Guerin', 'Noé', '1986-11-27', '2008-07-01', '2016-03-10'),
                                                                                                       ('MOB004', 5, 'Boyer', 'Lison', '1987-03-09', '2009-12-20', '2017-04-20');

DECLARE @i INT;

-- Insertion des CV :
-- MS .NET : NET001 à NET004
SET @i = 1;
WHILE @i <= 4
BEGIN
    INSERT INTO TAB_CV (MATRICULE, DESC_CV, MOTS_CLEFS, CV)
    VALUES ('NET' + RIGHT('000' + CAST(@i AS VARCHAR(3)), 3), 'CV for NET ' + CAST(@i AS VARCHAR(10)), 'Keyword_NET', 0x0);
    SET @i = @i + 1;
END;
-- MS BI : BI001 à BI005
SET @i = 1;
WHILE @i <= 5
BEGIN
    INSERT INTO TAB_CV (MATRICULE, DESC_CV, MOTS_CLEFS, CV)
    VALUES ('BI' + RIGHT('000' + CAST(@i AS VARCHAR(3)), 3), 'CV for BI ' + CAST(@i AS VARCHAR(10)), 'Keyword_BI', 0x0);
    SET @i = @i + 1;
END;
-- Web PHP : PHP001 à PHP002
SET @i = 1;
WHILE @i <= 2
BEGIN
    INSERT INTO TAB_CV (MATRICULE, DESC_CV, MOTS_CLEFS, CV)
    VALUES ('PHP' + RIGHT('000' + CAST(@i AS VARCHAR(3)), 3), 'CV for PHP ' + CAST(@i AS VARCHAR(10)), 'Keyword_PHP', 0x0);
    SET @i = @i + 1;
END;
