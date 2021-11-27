﻿function Connect-ExchangeOnlineProt {

    [CmdletBinding()]
    param(        
        
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $true,
            HelpMessage = 'Credentials in Azure AD to access Office 365.'
        )]
        [System.Management.Automation.Credential()]
        [PSCredential]$Credential
    )

    if ($null -ne (Get-ExchangeOnlineProtSession)) {

        if (Get-Command -Name 'Set-EOPUser' -ErrorAction SilentlyContinue) {

            Write-Verbose -Message 'Exchange Online Protection PowerShell session already existis.' -Verbose
            Write-Verbose -Message 'Disconnect from the current session to start a new one.'
            return
        }
        else
        {
            Write-Warning -Message 'Exchange Online Protection is not available on the target Office 365 tenant'
            return
        }
    }

    try {

        $null = New-PSSession -ConfigurationName Microsoft.Exchange `
                -Verbose:$false
    }
    catch {

        Write-Warning -Message ('Unable to create PSSession to Exchange Online Protection - {0}' -f $_.Exception.Message)
        return
    }

    try {

        $null = Import-Module `
                -Verbose:$false
    }
    catch {

        Write-Warning -Message ('Unable to load PSSession for Exchange Online Protection - {0}' -f $_.Exception.Message)
        return
    }
}