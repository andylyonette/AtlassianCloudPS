function Get-AtlassianCloudJiraStatus{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$ProjectId,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('usages','workflowUsages')]
        [string[]]$Expand,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($Id) {
        $endpoint = "statuses?id=$($Id -join '&id=')"
    } elseif ($ProjectId) {
        $endpoint = "statuses/search?projectId=$($ProjectId)"
    } else {
        $endpoint = "statuses/search?"
    }

    if ($Expand) {
        if ($endpoint -like "*?") {
            $endpoint += "expand=$($Expand -join '&expand=')"
        } else {
            $endpoint += "&expand=$($Expand -join '&expand=')"
        }
    }
    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -Verbose:($Verbose.IsPresent)
}