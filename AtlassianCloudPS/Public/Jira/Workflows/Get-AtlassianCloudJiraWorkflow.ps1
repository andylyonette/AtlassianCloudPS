function Get-AtlassianCloudJiraWorkflow{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$Name,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Query,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('transitions','transitions.rules','transitions.properties','statuses','statuses.properties','default','schemes','projects','hasDraftWorkflow','operations')]
        [string[]]$Expand,

        [Parameter(Mandatory = $false, Position=3)]
        [bool]$OnlyActive,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = "workflow/search"

    if ($Name) {
        $endpoint += "?workflowName=$($Name -join '&workflowName=')"
    }

    if ($Query) {
        if ($endpoint -like '*?*') {
            $endpoint += "&queryString=$($Query)"
        } else {
            $endpoint += "?queryString=$($Query)"
        }
    }

    if ($OnlyActive) {
        if ($endpoint -like '*?*') {
            $endpoint += "&isActive=$($OnlyActive.ToString().ToLower())"
        } else {
            $endpoint += "?isActive=$($OnlyActive.ToString().ToLower())"
        }
    }

    if ($Expand) {
        if ($endpoint -like '*?*') {
            $endpoint += "&expand=$($Expand -join ',')"
        } else {
            $endpoint += "?expand=$($Expand -join ',')"
        }
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}