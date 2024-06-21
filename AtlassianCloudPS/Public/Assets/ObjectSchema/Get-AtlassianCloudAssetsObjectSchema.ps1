function Get-AtlassianCloudAssetsObjectSchema{
    [CmdletBinding()]
    [Alias('Get-AtlassianCloudAssetsSchema')]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,
        
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($Id) {
        $endpoint = "objectschema/$Id"
        Get-AtlassianCloudAssetsEntity -Endpoint $endpoint -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 
    } else {
        $endpoint = 'objectschema/list?maxResults=1000'
        Get-AtlassianCloudAssetsEntity -Endpoint $endpoint -ResponseProperty values -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 
    }

}

