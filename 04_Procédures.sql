/*
04_Procédures.sql
Création des procédures stockées et de la vue
*/

---------------------------------------------------------------------
-- PS_NB_PROFILS
---------------------------------------------------------------------
-- Supprime la procédure PS_NB_PROFILS si elle existe
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'IF OBJECT_ID(''PS_NB_PROFILS'', ''P'') IS NOT NULL DROP PROCEDURE PS_NB_PROFILS;';
EXEC sp_executesql @sql;

-- Crée la procédure PS_NB_PROFILS
SET @sql = N'CREATE PROCEDURE PS_NB_PROFILS
AS
BEGIN
    SELECT P.LIBELLE_PROFIL, COUNT(S.MATRICULE) AS NB_SALARIES
    FROM PROFIL P
    LEFT JOIN SALARIE S ON P.ID_PROFIL = S.ID_PROFIL
    GROUP BY P.LIBELLE_PROFIL
    ORDER BY P.LIBELLE_PROFIL ASC;
END;';
EXEC sp_executesql @sql;

---------------------------------------------------------------------
-- PS_LIST_SALARIES
---------------------------------------------------------------------
SET @sql = N'IF OBJECT_ID(''PS_LIST_SALARIES'', ''P'') IS NOT NULL DROP PROCEDURE PS_LIST_SALARIES;';
EXEC sp_executesql @sql;

SET @sql = N'CREATE PROCEDURE PS_LIST_SALARIES
AS
BEGIN
    SELECT S.NOM, S.PRENOM, P.LIBELLE_PROFIL
    FROM SALARIE S
    INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL;
END;';
EXEC sp_executesql @sql;

---------------------------------------------------------------------
-- PS_LIST_DETAILLEE_SALARIES (version initiale)
---------------------------------------------------------------------
SET @sql = N'IF OBJECT_ID(''PS_LIST_DETAILLEE_SALARIES'', ''P'') IS NOT NULL DROP PROCEDURE PS_LIST_DETAILLEE_SALARIES;';
EXEC sp_executesql @sql;

SET @sql = N'CREATE PROCEDURE PS_LIST_DETAILLEE_SALARIES
AS
BEGIN
    SELECT S.MATRICULE, S.NOM, S.PRENOM, P.LIBELLE_PROFIL,
           dbo.FN_GET_EXPERIENCE(S.MATRICULE) AS NB_ANNEE_EXP,
           dbo.FN_GET_ANNIVERSAIRE(S.MATRICULE) AS DATE_PROCHAIN_ANNIV
    FROM SALARIE S
    INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL;
END;';
EXEC sp_executesql @sql;

---------------------------------------------------------------------
-- Création de la vue VIEW_LIST_SALARIES
---------------------------------------------------------------------
SET @sql = N'IF OBJECT_ID(''VIEW_LIST_SALARIES'', ''V'') IS NOT NULL DROP VIEW VIEW_LIST_SALARIES;';
EXEC sp_executesql @sql;

SET @sql = N'CREATE VIEW VIEW_LIST_SALARIES AS
SELECT S.MATRICULE, S.NOM, S.PRENOM, P.LIBELLE_PROFIL,
       dbo.FN_GET_EXPERIENCE(S.MATRICULE) AS NB_ANNEE_EXP,
       dbo.FN_GET_ANNIVERSAIRE(S.MATRICULE) AS DATE_PROCHAIN_ANNIV
FROM SALARIE S
INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL;';
EXEC sp_executesql @sql;

---------------------------------------------------------------------
-- Renommage de PS_LIST_DETAILLEE_SALARIES en PS_LIST_DETAILLEE_SALARIES_OLD
---------------------------------------------------------------------
SET @sql = N'IF OBJECT_ID(''PS_LIST_DETAILLEE_SALARIES_OLD'', ''P'') IS NOT NULL DROP PROCEDURE PS_LIST_DETAILLEE_SALARIES_OLD;';
EXEC sp_executesql @sql;

EXEC sp_rename 'PS_LIST_DETAILLEE_SALARIES', 'PS_LIST_DETAILLEE_SALARIES_OLD';

---------------------------------------------------------------------
-- PS_LIST_DETAILLEE_SALARIES (version utilisant la vue)
---------------------------------------------------------------------
-- Crée à nouveau PS_LIST_DETAILLEE_SALARIES pour utiliser la vue
SET @sql = N'CREATE PROCEDURE PS_LIST_DETAILLEE_SALARIES
AS
BEGIN
    SELECT * FROM VIEW_LIST_SALARIES;
END;';
EXEC sp_executesql @sql;

---------------------------------------------------------------------
-- PS_STAT_SALARIE
---------------------------------------------------------------------
SET @sql = N'IF OBJECT_ID(''PS_STAT_SALARIE'', ''P'') IS NOT NULL DROP PROCEDURE PS_STAT_SALARIE;';
EXEC sp_executesql @sql;

SET @sql = N'CREATE PROCEDURE PS_STAT_SALARIE
AS
BEGIN
    -- 1. Salarié avec le maximum d''ancienneté (en mois)
    SELECT TOP 1 S.NOM, S.PRENOM
    FROM SALARIE S
    ORDER BY DATEDIFF(MONTH, S.DATE_ENTREE, GETDATE()) DESC;
    
    -- 2. Salariés embauchés durant le premier trimestre
    SELECT S.NOM, S.PRENOM, S.DATE_ENTREE
    FROM SALARIE S
    WHERE MONTH(S.DATE_ENTREE) IN (1,2,3);
    
    -- 3. Salariés embauchés dans des mois pairs
    SELECT S.NOM, S.PRENOM, S.DATE_ENTREE
    FROM SALARIE S
    WHERE MONTH(S.DATE_ENTREE) % 2 = 0;
    
    -- 4. Salariés ayant un CV enregistré
    SELECT S.NOM + '' '' + S.PRENOM AS NOM_PRENOM, P.LIBELLE_PROFIL AS PROFIL
    FROM SALARIE S
    INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL
    WHERE S.MATRICULE IN (SELECT MATRICULE FROM TAB_CV);
    
    -- 5. Salariés de profil ''MS .NET'' dont le CV contient le mot clé ''MVC''
    SELECT S.NOM + '' '' + S.PRENOM AS NOM_PRENOM
    FROM SALARIE S
    INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL
    INNER JOIN TAB_CV T ON S.MATRICULE = T.MATRICULE
    WHERE P.LIBELLE_PROFIL = ''MS .NET'' AND T.DESC_CV LIKE ''%MVC%'';
    
    -- 6. Salariés de profil ''Web PHP'' avec > 3 ans d''expérience et CV contenant ''Symfony 2'',
    -- ordonnés par mois d''expérience décroissant
    SELECT S.NOM + '' '' + S.PRENOM AS NOM_PRENOM,
           DATEDIFF(MONTH, S.DATE_ENTREE, GETDATE()) AS MOIS_EXPERIENCE
    FROM SALARIE S
    INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL
    INNER JOIN TAB_CV T ON S.MATRICULE = T.MATRICULE
    WHERE P.LIBELLE_PROFIL = ''Web PHP'' 
      AND DATEDIFF(YEAR, S.DATE_ENTREE, GETDATE()) > 3
      AND T.DESC_CV LIKE ''%Symfony 2%''
    ORDER BY DATEDIFF(MONTH, S.DATE_ENTREE, GETDATE()) DESC;
    
    -- 7. Moyenne des salariés par profil
    SELECT P.LIBELLE_PROFIL, COUNT(*)*1.0 / (SELECT COUNT(*) FROM SALARIE) AS MOYENNE_PAR_PROFIL
    FROM SALARIE S
    INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL
    GROUP BY P.LIBELLE_PROFIL;
    
    -- 8. Pourcentage des salariés par profil
    SELECT P.LIBELLE_PROFIL, (COUNT(*)*100.0 / (SELECT COUNT(*) FROM SALARIE)) AS POURCENTAGE
    FROM SALARIE S
    INNER JOIN PROFIL P ON S.ID_PROFIL = P.ID_PROFIL
    GROUP BY P.LIBELLE_PROFIL;
    
    -- 9. Moyenne d''âge de l''effectif
    SELECT AVG(DATEDIFF(YEAR, S.DATE_NAISSANCE, GETDATE())*1.0) AS MOYENNE_AGE
    FROM SALARIE S;
END;';
EXEC sp_executesql @sql;

---------------------------------------------------------------------
-- PS_UPDATE_SALARIE
---------------------------------------------------------------------
SET @sql = N'IF OBJECT_ID(''PS_UPDATE_SALARIE'', ''P'') IS NOT NULL DROP PROCEDURE PS_UPDATE_SALARIE;';
EXEC sp_executesql @sql;

SET @sql = N'CREATE PROCEDURE PS_UPDATE_SALARIE 
    @Matricule VARCHAR(20),
    @NOM VARCHAR(150),
    @PRENOM VARCHAR(150),
    @ID_PROFIL INT,
    @DATE_NAISSANCE DATE,
    @DATE_DIPLOME DATE,
    @DATE_ENTREE DATE
AS
BEGIN
    UPDATE SALARIE
    SET NOM = @NOM,
        PRENOM = @PRENOM,
        ID_PROFIL = @ID_PROFIL,
        DATE_NAISSANCE = @DATE_NAISSANCE,
        DATE_DIPLOME = @DATE_DIPLOME,
        DATE_ENTREE = @DATE_ENTREE
    WHERE MATRICULE = @Matricule;
END;';
EXEC sp_executesql @sql;

---------------------------------------------------------------------
-- PS_DELETE_SALARIE
---------------------------------------------------------------------
SET @sql = N'IF OBJECT_ID(''PS_DELETE_SALARIE'', ''P'') IS NOT NULL DROP PROCEDURE PS_DELETE_SALARIE;';
EXEC sp_executesql @sql;

SET @sql = N'CREATE PROCEDURE PS_DELETE_SALARIE 
    @Matricule VARCHAR(20)
AS
BEGIN
    DELETE FROM SALARIE WHERE MATRICULE = @Matricule;
END;';
EXEC sp_executesql @sql;