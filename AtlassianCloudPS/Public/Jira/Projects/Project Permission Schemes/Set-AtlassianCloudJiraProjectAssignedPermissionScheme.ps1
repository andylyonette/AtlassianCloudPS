function Set-AtlassianCloudJiraProjectAssignedPermissionScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,

        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('all','field','group','permissions','projectRole','user')]
        [string[]]$Expand,
        
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "project/$ProjectKey/permissionscheme"

    if ($Expand) {
        $endpoint += "?$($Expand -join '&expand=')"
    }

    $data = @{
        id = $Id
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}