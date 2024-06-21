function Find-AtlassianCloudJiraDashboard{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$Name,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$AccountId,

        [Parameter(Mandatory=$false, Position=2)]
        [string]$GroupId,

        [Parameter(Mandatory=$false, Position=3)]
        [string]$ProjectId,

        [Parameter(Mandatory=$false, Position=4)]
        [ValidateSet('active','archived','deleted')]
        [string]$Status = 'active',

        [Parameter(Mandatory=$false, Position=5)]
        [string]$OrderBy,

        [Parameter(Mandatory=$false, Position=6)]
        [ValidateSet('description','owner','viewUrl','favourite','favouritedCount','sharePermissions','editPermissions','isWritable')]
        [string[]]$Expand,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint  = 'dashboard/search?'

    if ($Name) {
        if ($endpoint -like '*?') {
            $endpoint += "name=$Name"
        } else {
            $endpoint += "&name=$Name"
        }
    }

    if ($AccountId) {
        if ($endpoint -like '*?') {
            $endpoint += "accountId=$AccountId"
        } else {
            $endpoint += "&accountId=$AccountId"
        }
    }

    if ($GroupId) {
        if ($endpoint -like '*?') {
            $endpoint += "groupId=$GroupId"
        } else {
            $endpoint += "&groupId=$GroupId"
        }
    }

    if ($ProjectId) {
        if ($endpoint -like '*?') {
            $endpoint += "projectId=$ProjectId"
        } else {
            $endpoint += "&projectId=$ProjectId"
        }
    }

    if ($Status) {
        if ($endpoint -like '*?') {
            $endpoint += "status=$Status"
        } else {
            $endpoint += "&status=$Status"
        }
    }

    if ($Expand) {
        foreach ($e in $expand) {
            if ($endpoint -like '*?') {
                $endpoint += "expand=$e"
            } else {
                $endpoint += "&expand=$e"
            }
        }
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}