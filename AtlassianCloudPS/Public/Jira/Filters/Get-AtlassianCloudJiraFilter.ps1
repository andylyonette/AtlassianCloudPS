function Get-AtlassianCloudJiraFilter{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [int]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$Favourite,

        [Parameter()]
        [switch]$My

    )

    $endpoint = 'filter'

    if ($Favourite.IsPresent) {
        $endpoint += '/favourite'
    }

    if ($My.IsPresent) {
        $endpoint += '/my'
    }

    if ($Id) {
        $endpoint += "/$Id"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}
