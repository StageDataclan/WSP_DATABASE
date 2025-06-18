

# 🛠️ Workshop SQL – Automatisation & Compétences T-SQL

## 📋 Objectif du Projet

Ce workshop a pour but de vous faire monter en compétences sur **Microsoft SQL Server** et le langage **Transact-SQL (T-SQL)**, dans le cadre de futurs travaux d’automatisation de batchs SQL.
Vous allez manipuler les concepts de base de données relationnelle, écrire des scripts SQL complets, et exploiter les procédures stockées, vues, fonctions, indexes, etc.

> **Livrable attendu** : un script SQL complet pour chaque étape listée ci-dessous.

---

## 🧑‍💻 Prérequis

* Installation de **Microsoft SQL Server** sur votre poste de travail.
* Un environnement d'exécution (SSMS ou équivalent).

---

## 📂 Contenu du Travail Demandé

### 1. Création de la base de données

* `WSP_DATABASE`

### 2. Création des tables

* `PROFIL` (ID\_PROFIL, LIBELLE\_PROFIL)
* `SALARIE` (MATRICULE, ID\_PROFIL, NOM, PRENOM, DATE\_NAISSANCE, DATE\_DIPLOME, DATE\_ENTREE)
* `TAB_CV` (ID\_CV, MATRICULE, DESCRIPTION\_CV, MOTS\_CLES, CV)

### 3. Insertion des données

* Profils : MS .NET, MS SharePoint, MS BI, Web PHP, Dév. Mobile
* Salariés répartis par profil
* CV pour certains salariés (MS .NET, MS BI, Web PHP)

### 4. Création de procédures stockées

* `PS_NB_PROFILS` : nombre de salariés par profil
* `PS_LIST_SALARIES` : liste simple des salariés
* `PS_LIST_DETAILLEE_SALARIES` & `PS_LIST_DETAILLEE_SALARIES_OLD`
* `PS_STAT_SALARIE` : analyses statistiques avancées
* `PS_UPDATE_SALARIE` : mise à jour d’un salarié
* `PS_DELETE_SALARIE` : suppression d’un salarié
* `PS_ALIM_DATE` : alimentation d’une table de dimension temporelle

### 5. Création de fonctions scalaires

* `FN_GET_EXPERIENCE` : années d’expérience
* `FN_GET_ANCIENNETE` : mois d’ancienneté
* `FN_GET_ANNIVERSAIRE` : prochaine date d’anniversaire

### 6. Création d’une vue

* `VIEW_LIST_SALARIES` : vue consolidée des salariés

### 7. Opérations avancées

* Renommer des colonnes et procédures
* Modification de types de données
* Création d’indexes (simples & composés)
* Ajout de colonnes avec valeurs par défaut

### 8. Création d’une table de dimension date : `DIM_DATE`

* Avec génération automatique via procédure entre deux dates

---

## 📅 Exemple de Résultat Attendu

```sql
EXEC PS_ALIM_DATE '20140401', '20301231';
```

---

## 📌 Recommandations

* Veillez à bien **commenter vos scripts** pour chaque étape.
* Regroupez chaque tâche dans un **script indépendant** ou un **fichier bien structuré** si vous préférez un unique fichier.
* Respectez la **nomenclature des objets** et leur logique métier.

---

## ✅ À la fin du workshop, vous saurez :

* Créer et manipuler des bases, tables, vues, fonctions et procédures stockées
* Réaliser des opérations de jointures complexes
* Automatiser des traitements SQL sur MS SQL Server
* Analyser et structurer des données relationnelles en environnement professionnel

---

## 📁 Structure recommandée

```
📁 WSP_DATABASE/
├─ 01_Creation_BDD_Tables.sql
├─ 02_InsertDonnees.sql
├─ 03_Fonctions.sql
├─ 04_Procédures.sql
├─ 05_Modifications_et_Index.sql
├─ 06_DimDate_et_AlimDate.sql
├─ MasterScript.sql
└─ README.md
```
