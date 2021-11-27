# Intro

MsCoManager est un module powershell conçu pour faciliter la connexion et l'administration des services Microsoft.

Cloud : AzureAD, ComplianceCenter, ExchangeOnline, ExchangeOnlineProtection, MSOnline, SharepointOnline, SkypeforBusinessOnline

OnPremise : PsSession, Rdp

## Documentation

Toute la documentation: [HiteaFR.github.io/HiteaShell](https://HiteaFR.github.io/HiteaShell)

## Prérequis

Windows 10+ / Windows Server 2016+

### Modules

- Compatible avec le module PsPassManager pour enregitrer les objets $credential

```powershell
    Install-Module -Name PsPassManager
```

- Modules obligatoires :

```powershell
    Install-Module -Name AzureAD
    Install-Module -Name MSOnline
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell
    Install-Module -Name MicrosoftTeams
```

## Installation

### PowerShell Gallery

```powershell
    Install-Module -Name MsCoManager
```

Page du Module: [powershellgallery.com/packages/MsCoManager](https://www.powershellgallery.com/packages/MsCoManager)

### Dépot Git

```powershell
    Git clone https://github.com/HiteaFR/HiteaShell.git

    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_lE_MODULE] -Force -Verbose
```

### Téléchargement

Télécharger la dernière version : [github.com/HiteaFR/HiteaShell/releases/latest](https://github.com/HiteaFR/HiteaShell/releases/latest)

```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_lE_MODULE] -Force -Verbose
```

## Utilisation

```powershell
    # Connexion à un ou des service(s)
    Mcm connect -services @('') -SessionCred $credential
```

```powershell
    # Déconnexion du ou des service(s)
    Mcm disconnect -services @('')
```

Voir toute la doc : : [HiteaFR.github.io/HiteaShell](https://HiteaFR.github.io/HiteaShell)
