function Convert-AtlassianCloudAssetsApiObjectToPsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Object,
 
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

    $psAttributes = New-Object -TypeName psobject
    foreach ($attribute in $Object.attributes) {
        if ($attribute.objectAttributeValues.searchValue -gt 1) {
            $psAttributes | Add-Member -MemberType NoteProperty -Name ($ObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).name -Value $attribute.objectAttributeValues.searchValue
        } else {
            if (($ObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).type = 0) {
                $psAttributes | Add-Member -MemberType NoteProperty -Name ($ObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).name -Value  $attribute.objectAttributeValues.searchValue
            } else {
                $psAttributes | Add-Member -MemberType NoteProperty -Name ($ObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).name -Value (New-Object System.Collections.Generic.List[string])
                $psAttributes."$(($ObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).name)".Add($attribute.objectAttributeValues.searchValue)
            }
        }
    }

    foreach ($attribute in $ObjectType.attributes | Where-Object {($psAttributes | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'}).Name -notcontains $_.name}) {
        if ($attribute.type -eq 0) {
            $psAttributes | Add-Member -MemberType NoteProperty -Name $attribute.name -Value $null
        } else {
            $psAttributes | Add-Member -MemberType NoteProperty -Name $attribute.name -Value (New-Object System.Collections.Generic.List[string])
        }
    }
    
    $Object.attributes = $psAttributes

    return $Object
}