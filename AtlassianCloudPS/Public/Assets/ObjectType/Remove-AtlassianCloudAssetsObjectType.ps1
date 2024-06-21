function Remove-AtlassianCloudAssetsObjectType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )


    Invoke-AtlassianCloudAssetsMethod -Method Delete -Endpoint "objecttype/$Id" -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}