function Import-HtConfiguration() {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$ProfilePath
    )

    if (Test-Path $ProfilePath -ErrorAction SilentlyContinue) {
        $Configuration = (Get-Content $ProfilePath | Out-String | ConvertFrom-Json)
    }
    else {
        Read-Host "Profile error, exit... "
        exit
    }
    $Configuration | Add-Member Filename $ProfilePath
    return $Configuration
}

function Save-HtConfiguration() {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $Configuration
    )
    
    $excluded = @('Filename')
    $Configuration | Select-Object -Property * -ExcludeProperty $excluded | ConvertTo-Json | Set-Content -Encoding UTF8 -Path $Configuration.Filename
    Write-Verbose -Message "Config file saved !"
}

function Confirm-HtConfigurationItem {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $ConfigurationItem,
        [Parameter(Mandatory = $True)]
        $Item
    )

    if ([string]::IsNullOrEmpty($Item)) {
        return $null
    }
    elseif ([bool]($ConfigurationItem -match $Item)) {
        return $true
    }
    else {
        return $false
    }
    
}

function Connect-Services {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            Position = 0
        )]
        [ValidateSet("PsSession", "Rdp", "AzureAD", "ComplianceCenter", "ExchangeOnline", "ExchangeOnlineProtection", "MSOnline", "SharepointOnline", "SkypeforBusinessOnline")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Service,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [pscredential]$Credential
    )

    dynamicparam {

        if ($Service -match 'SharepointOnline') {

            # Create a Parameter Attribute Object
            $SPAttrib = New-Object -TypeName System.Management.Automation.ParameterAttribute
            $SPAttrib.Position = 1
            $SPAttrib.Mandatory = $true            
            $SPAttrib.HelpMessage = 'Enter a valid Sharepoint Online Domain. Example: "Contoso"'
            
            # Create an Alias Attribute Object for the parameter
            $SPAlias = New-Object -TypeName System.Management.Automation.AliasAttribute -ArgumentList @('Domain', 'DomainHost', 'Customer')

            # Create an AttributeCollection Object
            $SPCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
                       
            # Add the attributes and aliases to the Attribute Collection
            $SPCollection.Add($SPAttrib)
            $SPCollection.Add($SPAlias)
            
            # Add the SharepointDomain paramater to the "Runtime"
            $SPParam = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('SharepointDomain', [string], $SPCollection)
            
            # Expose the parameter
            $SPParamDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
            $SPParamDictionary.Add('SharepointDomain', $SPParam)
            return $SPParamDictionary
        }

    }
    begin {
        
        $EOPExclusive = 'Will not use Exchange Online Protection. EOP and EO are mutually exclusive.'
        
        if ($Service -match 'ExchangeOnline' -and $Service -match 'ExchangeOnlineProtection') {
            Write-Verbose -Message $EOPExclusive
            $Service.Remove('ExchangeOnlineProtection')
        }

        if ($Credential -eq $false) {

            Write-Warning -Message 'Need valid credentials to connect, please provide the correct credentials.'
            break
        }  

    }
    process {

        foreach ($s in $Service) {
            
            if ($PSCmdlet.ShouldProcess('Establishing a PowerShell session to {0} - Office 365.' -f ('{0}' -f $s), $MyInvocation.MyCommand.Name)) {
                
                switch ($s) {

                    'AzureAD' {
                        Write-Verbose -Message 'Connecting to AzureAD.' -Verbose
                        $Credential | Connect-AzureADOnline
                    }
                    'MSOnline' {
                        Write-Verbose -Message 'Connecting to MSolService.' -Verbose
                        $Credential | Connect-MsolServiceOnline
                    }
                    'ComplianceCenter' {
                        Write-Verbose -Message 'Connecting to Compliance Center.' -Verbose
                        $Credential | Connect-CCOnline
                    }
                    'ExchangeOnline' {
                        Write-Verbose -Message 'Connecting to Exchange Online.' -Verbose
                        $Credential | Connect-ExchangeOnline
                    }
                    'ExchangeOnlineProtection' {
                        Write-Verbose -Message 'Connecting to Exchange Online Protection.' -Verbose
                        $Credential | Connect-ExchangeOnlineProt
                    }
                    'SharepointOnline' {
                        Write-Verbose -Message 'Connecting to Sharepoint Online.' -Verbose
                        $Credential | Connect-SPOnline -SharepointDomain $PSBoundParameters['SharepointDomain']
                    }
                    'SkypeforBusinessOnline' {
                        Write-Verbose -Message 'Connecting to Skype for Business Online.' -Verbose
                        $Credential | Connect-SfBOnline
                    }
                    'PsSession' {
                        Write-Verbose -Message 'Disconnecting PSSsession.' -Verbose
                        $Credential | Connect-HtComputerPsSession
                    }
                    'Rdp' {
                        Write-Verbose -Message 'Disconnecting from Skype for Rdp.' -Verbose
                        $Credential | Connect-HtComputerRdpSession
                    }
                    Default {
                        Write-Warning -Message "Choose a service : $($Service)" -Verbose
                    }
                }
            }
        }
    }
    end {

        Remove-Variable -Name Credential -ErrorAction SilentlyContinue
    }
}

function Disconnect-Services {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param(
        [Parameter(
            ValueFromPipeline = $true            
        )]
        [ValidateSet("PsSession", "Rdp", "AzureAD", "ComplianceCenter", "ExchangeOnline", "ExchangeOnlineProtection", "MSOnline", "SharepointOnline", "SkypeforBusinessOnline")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Service
    )
    begin {

    }
    process {

        foreach ($s in $Service) {

            if ($PSCmdlet.ShouldProcess('End the PowerShell session for {0} - Office 365.' -f ('{0}' -f $s), $MyInvocation.MyCommand.Name)) {

                switch ($s) {

                    'AzureAD' {
                        Write-Verbose -Message 'Disconnecting from AzureAD.' -Verbose
                        Disconnect-AzureADOnline
                    }
                    'MSOnline' {
                        Write-Verbose -Message 'Disconnecting from MsolService.' -Verbose
                        Disconnect-MsolServiceOnline
                    }
                    'ComplianceCenter' {
                        Write-Verbose -Message 'Disconnecting from Compliance Center.' -Verbose
                        Disconnect-CCOnline
                    }
                    'ExchangeOnline' {
                        Write-Verbose -Message 'Disconnecting from Exchange Online.' -Verbose
                        Disconnect-ExchangeOnline
                    }
                    'ExchangeOnlineProtection' {
                        Write-Verbose -Message 'Disconnecting from Exchange Online Protection.' -Verbose
                        Disconnect-ExchangeOnlineProt
                    }
                    'SharepointOnline' {
                        Write-Verbose -Message 'Disconnecting from Sharepoint Online.' -Verbose
                        Disconnect-SPOnline
                    }
                    'SkypeforBusinessOnline' {
                        Write-Verbose -Message 'Disconnecting from Skype for Business Online.' -Verbose
                        Disconnect-SfBOnline
                    }
                    'PsSession' {
                        Write-Verbose -Message 'Disconnecting PSSsession.' -Verbose
                        Disconnect-HtComputerPsSession
                    }
                    'Rdp' {
                        Write-Verbose -Message 'Disconnecting from Skype for Rdp.' -Verbose
                        Disconnect-HtComputerRdpSession
                    }
                    Default {
                        Write-Warning -Message "Choose a service : $($Service)" -Verbose
                    }
                }
                
            }
        }
    }
    end {
        Remove-Variable -Name Credential -ErrorAction SilentlyContinue
    }
}