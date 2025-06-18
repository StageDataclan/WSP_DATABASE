/*
03_Fonctions.sql
Création des fonctions FN_GET_EXPERIENCE, FN_GET_ANCIENNETE et FN_GET_ANNIVERSAIRE
*/

---------------------------
-- 1. Fonction FN_GET_EXPERIENCE
---------------------------
DECLARE @sql NVARCHAR(MAX);
-- Supprime FN_GET_EXPERIENCE si elle existe
SET @sql = N'IF OBJECT_ID(''FN_GET_EXPERIENCE'', ''FN'') IS NOT NULL DROP FUNCTION FN_GET_EXPERIENCE;';
EXEC sp_executesql @sql;

-- Crée FN_GET_EXPERIENCE
SET @sql = N'CREATE FUNCTION FN_GET_EXPERIENCE (@Matricule VARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @Years INT;
    SELECT @Years = DATEDIFF(YEAR, DATE_ENTREE, GETDATE())
      FROM SALARIE
     WHERE MATRICULE = @Matricule;
    RETURN @Years;
END;';
EXEC sp_executesql @sql;

---------------------------
-- 2. Fonction FN_GET_ANCIENNETE
---------------------------
-- Supprime FN_GET_ANCIENNETE si elle existe
SET @sql = N'IF OBJECT_ID(''FN_GET_ANCIENNETE'', ''FN'') IS NOT NULL DROP FUNCTION FN_GET_ANCIENNETE;';
EXEC sp_executesql @sql;

-- Crée FN_GET_ANCIENNETE
SET @sql = N'CREATE FUNCTION FN_GET_ANCIENNETE (@Matricule VARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @Months INT;
    SELECT @Months = DATEDIFF(MONTH, DATE_ENTREE, GETDATE())
      FROM SALARIE
     WHERE MATRICULE = @Matricule;
    RETURN @Months;
END;';
EXEC sp_executesql @sql;

---------------------------
-- 3. Fonction FN_GET_ANNIVERSAIRE
---------------------------
-- Supprime FN_GET_ANNIVERSAIRE si elle existe
SET @sql = N'IF OBJECT_ID(''FN_GET_ANNIVERSAIRE'', ''FN'') IS NOT NULL DROP FUNCTION FN_GET_ANNIVERSAIRE;';
EXEC sp_executesql @sql;

-- Crée FN_GET_ANNIVERSAIRE
SET @sql = N'CREATE FUNCTION FN_GET_ANNIVERSAIRE (@Matricule VARCHAR(20))
RETURNS DATE
AS
BEGIN
    DECLARE @Birth DATE, @Anniv DATE;
    SELECT @Birth = DATE_NAISSANCE FROM SALARIE WHERE MATRICULE = @Matricule;
    IF (@Birth IS NULL)
        RETURN NULL;
    DECLARE @ThisYearBirthday DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(@Birth), DAY(@Birth));
    IF (@ThisYearBirthday >= GETDATE())
        SET @Anniv = @ThisYearBirthday;
    ELSE
        SET @Anniv = DATEFROMPARTS(YEAR(GETDATE()) + 1, MONTH(@Birth), DAY(@Birth));
    RETURN @Anniv;
END;';
EXEC sp_executesql @sql;