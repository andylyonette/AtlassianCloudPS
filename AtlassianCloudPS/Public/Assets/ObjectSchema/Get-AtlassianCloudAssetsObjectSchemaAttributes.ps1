function Get-AtlassianCloudAssetsObjectSchemaAttributes{
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

    Get-AtlassianCloudAssetsEntity -Endpoint "objectschema/$Id/attributes" -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 
}