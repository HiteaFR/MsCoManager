function Mcm {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (       
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('connect', 'disconnect')]
        [Alias('A')]
        [string]
        $Action, 
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Services = $Null,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [pscredential]$SessionCred
    )

    $HtConfig = Import-HtConfiguration -ProfilePath "$($BaseFolder)/Config/Config_Default.json"

    If (!$Services) {
        $Services = $HtConfig.Default
    }

    $ConfigMatch = Confirm-HtConfigurationItem -ConfigurationItem $HtConfig.Services -Item $Services

    if (((!$SessionCred) -or ($ConfigMatch -eq $false))) {
        Write-Warning "Credential: $($SessionCred) - Service: $($ConfigMatch)"
    }

    Switch ($Action.ToLowerInvariant()) {
        "connect" {
            if (($SessionCred) -and ($ConfigMatch -eq $true)) {
                Connect-Services -Service $Services -Credential $SessionCred
            }
        }
        "disconnect" {
            if (($SessionCred) -and ($ConfigMatch -eq $true)) {
                Disconnect-Services -Service $Services
            }
        }
    }

    Save-HtConfiguration -Configuration $HtConfig

}