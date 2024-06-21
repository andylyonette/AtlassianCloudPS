function Get-AtlassianCloudAssetsWorkspaceId{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return (Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "assets/workspace" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)).workspaceId
}