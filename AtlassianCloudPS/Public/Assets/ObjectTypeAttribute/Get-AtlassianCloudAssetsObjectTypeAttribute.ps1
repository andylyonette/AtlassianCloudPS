function Get-AtlassianCloudAssetsObjectTypeAttribute{
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

    Get-AtlassianCloudAssetsEntity -Endpoint "objecttype/$Id/attributes" -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 

}