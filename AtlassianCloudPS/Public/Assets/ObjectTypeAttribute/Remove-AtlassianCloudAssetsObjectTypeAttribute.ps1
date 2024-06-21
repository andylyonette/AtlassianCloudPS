function Remove-AtlassianCloudAssetsObjectTypeAttribute{
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


    Invoke-AtlassianCloudAssetsMethod -Method Delete -Endpoint "objecttypeattribute/$Id" -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}