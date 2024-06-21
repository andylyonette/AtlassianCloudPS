function Convert-AtlassianCloudAssetsPsObjectToApiObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Attributes,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$ObjectType,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $apiObject = @{
        objectTypeId = $ObjectType.id
        attributes = @(
            $(
                foreach ($attribute in ($Attributes | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'})) {
                    @{
                        objectTypeAttributeId = ($ObjectType.attributes | Where-Object {$_.name -eq $attribute.Name}).id
                        objectAttributeValues = @(
                            $(
                                foreach ($value in $Attributes."$($attribute.Name)") {
                                    @{
                                        value = "$(if ($value) {Convert-DiacriticsToUrlEncoded -String $value})"
                                    }
                                }
                            )
                        )
                    }
                }
            )
        )
    }

    return $apiObject
}
