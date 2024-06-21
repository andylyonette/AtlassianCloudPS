function Set-AtlassianCloudAssetsObjectType{
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
        [string]$SchemaId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$IconId,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=5)]
        [string]$ParentObjectTypeId,

        [Parameter(Mandatory = $false, Position=6)]
        [bool]$Inherited = $false,

        [Parameter(Mandatory = $false, Position=7)]
        [bool]$AbstractObjectType = $false,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=9)]
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

    Invoke-AtlassianCloudAssetsMethod -Method Put -Data $data -Endpoint "objecttype/$Id" -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}
