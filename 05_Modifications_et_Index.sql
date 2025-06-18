/*
05_Modifications_et_Index.sql
Modifications de colonnes et création d’index
*/

/* Modification de la taille des colonnes NOM et PRENOM de 100 à 150 caractères */
ALTER TABLE SALARIE ALTER COLUMN NOM VARCHAR(150);
ALTER TABLE SALARIE ALTER COLUMN PRENOM VARCHAR(150);

/* Renommage de la colonne DESC_CV en DESCRIPTION_CV et modification du type en TEXT */
EXEC sp_rename 'TAB_CV.DESC_CV', 'DESCRIPTION_CV', 'COLUMN';
ALTER TABLE TAB_CV ALTER COLUMN DESCRIPTION_CV TEXT;

/* Création d'un index unique sur SALARIE.MATRICULE (si inexistant) */
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SALARIE_MATRICULE' AND object_id = OBJECT_ID('SALARIE'))
BEGIN
    CREATE UNIQUE INDEX IX_SALARIE_MATRICULE ON SALARIE(MATRICULE);
END;

/* Ajout de la colonne DATE_CV à TAB_CV et création de l'index unique sur (MATRICULE, DATE_CV) */
IF COL_LENGTH('TAB_CV', 'DATE_CV') IS NULL
BEGIN
    ALTER TABLE TAB_CV 
      ADD DATE_CV DATE CONSTRAINT DF_TAB_CV_DATE_CV DEFAULT (GETDATE());
END;
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'IX_TAB_CV_MATRICULE_DATE_CV' 
      AND object_id = OBJECT_ID('TAB_CV')
)
BEGIN
    CREATE UNIQUE INDEX IX_TAB_CV_MATRICULE_DATE_CV ON TAB_CV(MATRICULE, DATE_CV);
END;