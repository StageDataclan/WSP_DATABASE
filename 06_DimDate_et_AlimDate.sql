/*
06_DimDate_et_AlimDate.sql
Création de la table DIM_DATE et de la procédure PS_ALIM_DATE pour alimenter DIM_DATE
*/

-- Supprime la table DIM_DATE si elle existe, puis la créé
IF OBJECT_ID('DIM_DATE', 'U') IS NOT NULL
    DROP TABLE DIM_DATE;
CREATE TABLE DIM_DATE (
    ID_DATE INT PRIMARY KEY,         -- au format YYYYMMDD (ex : 20170619)
    LIB_DATE VARCHAR(20),             -- format dd/mm/yyyy
    ANNEE INT,
    NUM_SEMESTRE INT,
    NUM_TRIMESTRE INT,
    MOIS INT,
    LIB_MOIS VARCHAR(20),
    NUM_SEMAINE INT,
    NUM_JOUR_ANNEE INT,
    NUM_JOUR_MOIS INT,
    NUM_JOUR_SEMAINE INT,
    LIB_JOUR VARCHAR(20)
);

--------------------------------------------------------------------------------
-- Supprimer PS_ALIM_DATE si elle existe (premier appel sp_executesql)
--------------------------------------------------------------------------------
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'IF OBJECT_ID(''PS_ALIM_DATE'', ''P'') IS NOT NULL DROP PROCEDURE PS_ALIM_DATE;';
EXEC sp_executesql @sql;

--------------------------------------------------------------------------------
-- Créer la procédure PS_ALIM_DATE (second appel sp_executesql – crée le batch avec CREATE PROCEDURE en tête)
--------------------------------------------------------------------------------
SET @sql = N'
CREATE PROCEDURE PS_ALIM_DATE 
    @DATE_DEB DATE,
    @DATE_FIN DATE
AS
BEGIN
    DECLARE @CurrentDate DATE = @DATE_DEB;
    WHILE @CurrentDate <= @DATE_FIN
    BEGIN
        INSERT INTO DIM_DATE 
        (
            ID_DATE,
            LIB_DATE,
            ANNEE,
            NUM_SEMESTRE,
            NUM_TRIMESTRE,
            MOIS,
            LIB_MOIS,
            NUM_SEMAINE,
            NUM_JOUR_ANNEE,
            NUM_JOUR_MOIS,
            NUM_JOUR_SEMAINE,
            LIB_JOUR
        )
        VALUES (
            CAST(CONVERT(VARCHAR(8), @CurrentDate, 112) AS INT),
            CONVERT(VARCHAR(10), @CurrentDate, 103),
            YEAR(@CurrentDate),
            CASE WHEN MONTH(@CurrentDate) <= 6 THEN 1 ELSE 2 END,
            ((MONTH(@CurrentDate)-1)/3)+1,
            MONTH(@CurrentDate),
            DATENAME(MONTH, @CurrentDate),
            DATEPART(WEEK, @CurrentDate),
            DATEPART(DAYOFYEAR, @CurrentDate),
            DATEPART(DAY, @CurrentDate),
            DATEPART(WEEKDAY, @CurrentDate),
            DATENAME(WEEKDAY, @CurrentDate)
        );
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
END;';
EXEC sp_executesql @sql;

--------------------------------------------------------------------------------
-- Exécution de PS_ALIM_DATE pour alimenter DIM_DATE
--------------------------------------------------------------------------------
EXEC PS_ALIM_DATE @DATE_DEB = '2014-04-01', @DATE_FIN = '2030-12-31';