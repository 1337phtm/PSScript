# PSScript

PSScript est une collection de petits scripts PowerShell pratiques permettant
d’automatiser des actions courantes sous Windows : Ouverture de page de connexion google, clonage de repo github etc.

Ce dépôt sert de boîte à outils simple, rapide et modulaire pour gagner du temps
dans les tâches quotidiennes.

---

## 📋 Prérequis
- Windows 10 / 11
- PowerShell **5.1** ou **7+**
- Les Autorisation pour exécuter des scripts :

```powershell
   Get-ExecutionPolicy
   Set-ExecutionPolicy RemoteSigned CurrentUser
```

## 📌 Fonctionnalités principales

- 📧 **Ouverture automatique de comptes Gmail** avec email pré-rempli (possible de les remplir dans un fichier)
- 🌍 **Installation de Git + clonage de repo Github** avec nom d'utilsateur (pour le repo à cloner), possibilité de tout cloner
- 📁 **Ouverture rapide de dossiers** dans l’explorateur
- 📝 **Ouverture de fichiers dans Notepad**
- 🖥️ **Lancement de CMD ou PowerShell dans un dossier spécifique**
- 🔧 Scripts simples, lisibles, modifiables et réutilisables

---

## 📂 Arborescence du projet

