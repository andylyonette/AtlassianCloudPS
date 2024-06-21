function Get-AtlassianCloudJiraIssueField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('custom','system')]
        [string[]]$Type,
 
        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('key','lastUsed','screensCount','contextsCount','isLocked','searcherKey')]
        [string[]]$Expand,
 
        [Parameter(Mandatory = $false, Position=3)]
        [string]$Query,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = 'field'

    if ($Id) {
        $endpoint += "/$($Id)"
    }

    if ($Type) {
        if ($endpoint -like '*`?*') {
            $endpoint += "&type=$($Type -join '&type=')"
        } else {
            $endpoint += "?type=$($Type -join '&type=')"
        }
    }

    if ($Expand) {
        if ($endpoint -like '*`?*') {
            $endpoint += "&expand=$($Expand -join ',')"
        } else {
            $endpoint += "?expand=$($Expand -join ',')"
        }
    }

    if ($Query) {
        if ($endpoint -like '*`?*') {
            $endpoint += "&query=$($Query)"
        } else {
            $endpoint += "?query=$($Query)"
        }
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}