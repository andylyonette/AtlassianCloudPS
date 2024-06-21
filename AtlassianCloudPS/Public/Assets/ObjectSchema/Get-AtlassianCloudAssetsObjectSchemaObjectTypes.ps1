function Get-AtlassianCloudAssetsObjectSchemaObjectTypes{
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
        [string]$Pat,

        [Parameter()]
        [switch]$Flat
    )

    if ($Flat) {
        $endpoint = "objectschema/$Id/objecttypes/flat"
    } else {
        $endpoint = "objectschema/$Id/objecttypes"
    }

    Get-AtlassianCloudAssetsEntity -Endpoint $endpoint -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 
}