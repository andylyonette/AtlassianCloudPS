function Set-AtlassianCloudJiraDashboard{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject]$SharePermissions,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [psobject]$EditPermissions,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        editPermissions = $EditPermissions
        sharePermissions = $SharePermissions
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "dashboard/$Id" -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent)
}