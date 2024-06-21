function Get-AtlassianCloudAssetsRole{
    [CmdletBinding()]
    [Alias('Get-AtlassianCloudAssetsSchema')]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$ObjectTypeId,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$RoleId,
        
        [Parameter(Mandatory = $false, Position=2)]
        [string]$SchemaId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $uri = "https://$($AtlassianOrgName).atlassian.net/gateway/api/jsm/assets/workspace/$($WorkspaceId)/v1/config/role/"

    if ($ObjectTypeId) {
        $uri += "objecttype/$($ObjectTypeId)"
    } elseif ($SchemaId) {
        $uri += "objectschema/$($SchemaId)"
    } else {
        $uri += "$($RoleId)"
    }

    Write-Verbose "[GET] $uri"
    Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}

