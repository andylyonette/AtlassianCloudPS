function Set-AtlassianCloudAssetsObjectTypePosition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [int]$Position,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$ParentObjectTypeId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        position = $Position
    }

    if ($ParentObjectTypeId) {
        $data += @{
            toObjectTypeId = $ParentObjectTypeId
        }
    }

    Invoke-AtlassianCloudAssetsMethod -Method Put -Data $data -Endpoint "objecttype/$Id/position" -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}