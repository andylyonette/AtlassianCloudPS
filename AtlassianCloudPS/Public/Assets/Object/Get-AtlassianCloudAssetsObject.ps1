function Get-AtlassianCloudAssetsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
        
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AQL,
 
        [Parameter(Mandatory = $false, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$ObjectTypes,
 
        [Parameter(Mandatory = $false, Position=3)]
        [switch]$IncludeAttributes,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    if ($Schema -and $AQL) {
        $qlQuery = "objectSchemaId in ($($Schema.id)) AND ($AQL)"
    } else {
        $qlQuery = "objectSchemaId in ($($Schema.id))"
    }

    Write-Verbose "Getting objects with $qlQuery"

    $body = @{
        qlQuery = $qlQuery
    } | ConvertTo-Json

    Write-Verbose $body
    $assetsObjectsRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($assetsEndpoint + "object/aql?maxResults=1000&includeAttributes=$($IncludeAttributes.ToString().ToLower())") -ContentType application/json -Headers $headers
    Write-Verbose "$($assetsObjectsRequest | ConvertTo-Json -Depth 20)"

    $assetsObjects = @()
    foreach ($assetsObject in $assetsObjectsRequest.values) {
        $assetsObjects += $assetsObject
    }

    while ($false -eq $assetsObjectsRequest.isLast) {
        Write-Verbose "Getting objects [$($assetsObjectsRequest.pageNumber)/$($assetsObjectsRequest.pageSize)]"

        $assetsObjectsRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($assetsEndpoint + "object/aql?maxResults=1000&includeAttributes=$($IncludeAttributes.ToString().ToLower())&startAt=$(1 + $assetsObjectsRequest.startAt + $assetsObjectsRequest.maxResults)") -ContentType application/json -Headers $headers
        foreach ($assetsObject in $assetsObjectsRequest.values) {
            $assetsObjects += $assetsObject
        }
    } 

    if ($ObjectTypes) {
        $assetsObjectTypes = $ObjectTypes
    } else {
        $assetsObjectTypes = Get-AtlassianCloudAssetsObjectType -Schema $Schema -Attributes -WorkspaceId $WorkspaceId -Pat $Pat
    }

    $assetsPsObjects = @()
    foreach ($assetsObject in $assetsObjects) {
        if ($assetsObject.attributes.Count -gt 0) {
            $assetsObjectType = $assetsObjectTypes | Where-Object {$_.id -eq $assetsObject.objectType.id}
            $assetsPsObject = Convert-AtlassianCloudAssetsApiObjectToPsObject -Schema $Schema -Object $assetsObject -ObjectType $assetsObjectType -WorkspaceId $WorkspaceId -Pat $Pat
            $assetsPsObjects += $assetsPsObject
        } else {
            $assetsPsObjects += $assetsObject
        }
    }

    return $assetsPsObjects
}