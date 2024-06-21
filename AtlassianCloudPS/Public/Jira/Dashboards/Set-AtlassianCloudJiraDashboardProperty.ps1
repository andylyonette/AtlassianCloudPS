function Set-AtlassianCloudJiraDashboardProperty{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$DasbhoardId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ItemId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyKey,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Data,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $Data -AtlassianOrgName $AtlassianOrgName -Endpoint "dashboard/$DashboardId/items/$ItemId/properties/$PropertyKey" -Pat $Pat -Verbose:($Verbose.IsPresent)
}