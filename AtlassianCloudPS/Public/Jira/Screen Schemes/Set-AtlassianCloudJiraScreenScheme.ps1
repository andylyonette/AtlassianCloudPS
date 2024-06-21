function Set-AtlassianCloudJiraScreenScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
 
        [Parameter(Mandatory = $false, Position=3)]
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
        screens = @{}
    }

    if ($Name) {
        $data += @{
            name = $Name
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($DefaultScreenId) {
        $data.screens += @{
            default = $DefaultScreenId
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

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "screenscheme/$($Id)" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}