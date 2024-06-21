function Get-AtlassianCloudJiraIssueTypeScreenScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('projects')]
        [string]$Expand,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Query,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = 'issuetypescreenscheme'

    if ($Id) {
        $endpoint += "?id=$($Id)"
    }

    if ($Expand) {
        if ($endpoint -like '*`?*') {
            $endpoint += "&expand=$($Expand)"
        } else {
            $endpoint += "?expand=$($Expand)"
        }
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
