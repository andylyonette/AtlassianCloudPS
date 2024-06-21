function New-AtlassianCloudJiraScreenScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$DefaultScreenId,
 
        [Parameter(Mandatory = $false, Position=4)]
        [string]$CreateScreenId,
 
        [Parameter(Mandatory = $false, Position=5)]
        [string]$EditScreenId,
 
        [Parameter(Mandatory = $false, Position=6)]
        [string]$ViewScreenId,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        screens = @{
            default = $DefaultScreenId
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($CreateScreenId) {
        $data.screens += @{
            create = $CreateScreenId
        }
    }
    if ($EditScreenId) {
        $data.screens += @{
            edit = $EditScreenId
        }
    }
    if ($ViewScreenId) {
        $data.screens += @{
            view = $ViewScreenId
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint 'screenscheme' -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}