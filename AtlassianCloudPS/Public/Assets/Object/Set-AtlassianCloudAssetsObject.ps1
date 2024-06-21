function Set-AtlassianCloudAssetsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Object,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$ObjectType,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=3)]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    if (!$ObjectType) {
        $objectType = Get-AtlassianCloudAssetsObjectType -Id $Object.objectType.id -Schema $Schema -Attributes -WorkspaceId $WorkspaceId -Pat $Pat
    }

    $apiObject = Convert-AtlassianCloudAssetsPsObjectToApiObject -Attributes $Object.attributes -ObjectType $objectType -Schema $Schema -WorkspaceId $WorkspaceId -Pat $Pat

    $body = $apiObject | ConvertTo-Json -Depth 10
    $response = Invoke-WebRequest -Method Put -Body $body -Uri ($assetsEndpoint + "object/$($Object.id)") -ContentType application/json -Headers $headers

    if ($response.StatusCode -eq 429) {
        Start-Sleep -Seconds 2
        Write-Host "HTTP 429, waiting 2 seconds"
        $response = Invoke-WebRequest -Method Put -Body $body -Uri ($assetsEndpoint + "object/$($Object.id)") -ContentType application/json -Headers $headers
    }

    if ($response.Content) {
        $updatedObject = $response.Content | ConvertFrom-Json
    }

    return Convert-AtlassianCloudAssetsApiObjectToPsObject -Schema $Schema -Object $updatedObject -ObjectType $objectType -WorkspaceId $WorkspaceId -Pat $Pat
}