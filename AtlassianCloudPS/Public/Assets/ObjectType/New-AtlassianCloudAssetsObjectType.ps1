function New-AtlassianCloudAssetsObjectType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemaId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$IconId,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$ParentObjectTypeId,

        [Parameter(Mandatory = $false, Position=5)]
        [bool]$Inherited = $false,

        [Parameter(Mandatory = $false, Position=6)]
        [bool]$AbstractObjectType = $false,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        objectSchemaId = $SchemaId
        iconId = $IconId
        inherited = $Inherited
        abstractObjectType = $AbstractObjectType
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($ParentObjectTypeId) {
        $data += @{
            parentObjectTypeId = $ParentObjectTypeId
        }
    }

    Invoke-AtlassianCloudAssetsMethod -Method Post -Data $data -Endpoint 'objecttype/create' -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}