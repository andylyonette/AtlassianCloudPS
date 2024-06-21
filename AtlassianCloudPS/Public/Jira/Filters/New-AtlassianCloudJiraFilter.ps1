function New-AtlassianCloudJiraFilter{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Description,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$JQL,

        [Parameter(Mandatory = $false, Position=3)]
        [psobject]$SharePermissions,

        [Parameter(Mandatory = $false, Position=4)]
        [psobject]$EditPermissions,

        [Parameter(Mandatory = $false, Position=5)]
        [bool]$Favourite = $false,

        [Parameter(Mandatory = $false, Position=6)]
        [ValidateSet('sharedUsers','subscriptions')]
        [string]$Expand,

        [Parameter(Mandatory = $false, Position=7)]
        [ValidateNotNullOrEmpty()]
        [bool]$OverrideSharePermissions = $false,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=9)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        favourite = $Favourite
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($JQL) {
        $data += @{
            jql = $JQL
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "filter" -Pat $Pat -Experimental:($OverrideSharePermissions) -Verbose:($Verbose.IsPresent)
}