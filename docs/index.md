# Intro

MsCoManager est un module powershell conçu pour faciliter la connexion et l'administration des services Microsoft.

Cloud : AzureAD, ComplianceCenter, ExchangeOnline, ExchangeOnlineProtection, MSOnline, SharepointOnline, SkypeforBusinessOnline

OnPremise : PsSession, Rdp

Venez nous soutenir sur les Réseaux et Youtube :)

- [Hitea.fr](https://hitea.fr/)
- [Youtube](https://www.youtube.com/channel/UCt30dovkjqINMeh0p5DUoVQ?sub_confirmation=1)
- [Facebook](https://www.facebook.com/hitea.fr)
- [Twitter](https://twitter.com/HiteaFR)
- [Linkedin](https://www.linkedin.com/company/hitea-fr)
- [GitHub](https://github.com/HiteaFR)

## Documentation

Toute la documentation: [HiteaFR.github.io/PsPassManager](https://HiteaFR.github.io/PsPassManager)

## Documentation

Toute la documentation: [HiteaFR.github.io/MsCoManager](https://HiteaFR.github.io/MsCoManager)

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
    Git clone https://github.com/HiteaFR/MsCoManager.git

    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_lE_MODULE] -Force -Verbose
```

### Téléchargement

Télécharger la dernière version : [github.com/HiteaFR/MsCoManager/releases/latest](https://github.com/HiteaFR/MsCoManager/releases/latest)

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

Voir toute la doc : : [HiteaFR.github.io/MsCoManager](https://HiteaFR.github.io/MsCoManager)
