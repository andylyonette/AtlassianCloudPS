function Get-AtlassianCloudJiraGadget{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$DashboardId,

        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$GadgetId,

        [Parameter(Mandatory = $false, Position=2)]
        [string[]]$ModuleKey,

        [Parameter(Mandatory = $false, Position=3)]
        [string[]]$Uri,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($DashboardId) {
        $endpoint = "dashboard/$DashboardId/gadget?"

        foreach ($g in $GadgetId) {
            if ($endpoint -like '*?') {
                $endpoint += "gadgetId=$g"
            } else {
                $endpoint += "&gadgetId=$g"
            }
        }

        foreach ($k in $ModuleKey) {
            if ($endpoint -like '*?') {
                $endpoint += "moduleKey=$k"
            } else {
                $endpoint += "&moduleKey=$k"
            }
        }

        foreach ($u in $Uri) {
            if ($endpoint -like '*?') {
                $endpoint += "uri=$u"
            } else {
                $endpoint += "&uri=$u"
            }
        }
    } else {
        $endpoint = 'dashboard/gadgets'
    }

    return (Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)).gadgets
}