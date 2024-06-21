function Remove-AtlassianCloudJiraGadgetFromDashboard{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$DashboardId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [int]$GadgetId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Delete -AtlassianOrgName $AtlassianOrgName -Endpoint "dashboard/$Id/gadget/$Id" -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent)
}