function Get-AtlassianCloudAssetsObjectType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=0)]
        [psobject]$Schema,
        
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$Attributes
    )

    if ($Id) {
        $objectTypes = Get-AtlassianCloudAssetsEntity -Endpoint "objecttype/$Id" -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 
    }

    if ($Schema) {
        $objectTypes = Get-AtlassianCloudAssetsEntity -Endpoint "objectschema/$($Schema.id)/objecttypes" -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 
    }

    if ($objectTypes) {
        if ($Attributes) {
            $objectTypesWithAttributes = @()
            foreach ($objectType in $objectTypes) {
                $objectTypeWithAttributes = @{
                    id = $objectType.id
                    name = $objectType.name
                    type = $objectType.type
                    description = $objectType.description
                    icon = $objectType.icon
                    position = $objectType.position
                    created = $objectType.created
                    updated = $objectType.updated
                    objectCount = $objectType.objectCount
                    objectSchemaId = $objectType.objectSchemaId
                    inherited = $objectType.inherited
                    abstractObjectType = $objectType.abstractObjectType
                    parentObjectTypeInherited = $objectType.parentObjectTypeInherited
                    attributes = Get-AtlassianCloudAssetsObjectTypeAttribute -Id $objectType.id -WorkspaceId $workspaceId -Pat $pat -Verbose:($Verbose.IsPresent) 
                }
    
                $objectTypesWithAttributes += $objectTypeWithAttributes
            }
    
            return $objectTypesWithAttributes
        } else {
            return $objectTypes
        }
    }
}