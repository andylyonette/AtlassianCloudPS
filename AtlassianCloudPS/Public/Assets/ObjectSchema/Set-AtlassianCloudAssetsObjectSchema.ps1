function Set-AtlassianCloudAssetsObjectSchema{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemaKey,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        objectSchemaKey = $SchemaKey
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    Invoke-AtlassianCloudAssetsMethod -Method Put -Data $data -Endpoint "objectschema/$Id" -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}