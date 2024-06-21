function New-AtlassianCloudAssetsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$ObjectTypeName,
 
        [Parameter(Mandatory = $false, Position=2)]
        [psobject]$ObjectType,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Attributes,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    if ($ObjectTypeName -and !$ObjectType) {
        $objectTypes = Get-AtlassianCloudAssetsObjectType -Schema $Schema -Attributes -WorkspaceId $WorkspaceId -Pat $Pat
        $objectType = $objectTypes | Where-Object {$_.name -eq $ObjectTypeName}
    }

    $apiObject = Convert-AtlassianCloudAssetsPsObjectToApiObject -Schema $Schema -Attributes $Attributes -ObjectType $objectType -WorkspaceId $WorkspaceId -Pat $Pat
    $body = $apiObject | ConvertTo-Json -Depth 10
    $uri = ($assetsEndpoint + "object/create")
    Write-Host $uri
    Write-Host $body
    $newObject = Invoke-RestMethod -Method Post -Body $body -Uri $uri -ContentType application/json -Headers $headers

    $psObject = Get-AtlassianCloudAssetsObject -Schema $Schema -AQL "objectId = $($newObject.id)" -ObjectTypes @($objectType) -IncludeAttributes -WorkspaceId $WorkspaceId -Pat $Pat

    return $psObject
}