function Get-AtlassianCloudJiraScreen{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Query,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = 'screens'

    if ($Id) {
        $endpoint += "?id=$($Id)"
    }

    if ($Query) {
        if ($endpoint -like '*`?*') {
            $endpoint += "&queryString=$($Query)"
        } else {
            $endpoint += "?queryString=$($Query)"
        }
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}