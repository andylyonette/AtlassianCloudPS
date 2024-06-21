function Find-AtlassianCloudJiraFilter{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilterName,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$AccountId,

        [Parameter(Mandatory=$false, Position=2)]
        [string]$GroupId,

        [Parameter(Mandatory=$false, Position=3)]
        [string]$ProjectId,

        [Parameter(Mandatory=$false, Position=4)]
        [string[]]$Id,

        [Parameter(Mandatory=$false, Position=5)]
        [ValidateSet('description','favourite','favouritedCount','jql','owner','serachUrl','sharePermissions','editPermissions','isWritable','subscriptions','viewUrl')]
        [string[]]$Expand,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = 'filter/search?'

    if ($FilterName) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        } 
        $endpoint += "filterName=$FilterName"
    }

    if ($AccountId) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        } 
        $endpoint += "accountId=$AccountId"
    }

    if ($GroupId) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        } 
        $endpoint += "groupId=$GroupId"
    }

    if ($ProjectId) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        } 
        $endpoint += "projectId=$ProjectId"
    }

    if ($Id) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        } 
        $endpoint += "id=$($Id -join 'id=')"
    }

    if ($Expand) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        } 
        $endpoint += "expand=$($Expand -join 'expand=')"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}
