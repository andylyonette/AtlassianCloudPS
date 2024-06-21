function New-AtlassianCloudAssetsObjectSchema{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemaKey,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
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

    Invoke-AtlassianCloudAssetsMethod -Method Post -Data $data -Endpoint 'objectschema/create' -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}