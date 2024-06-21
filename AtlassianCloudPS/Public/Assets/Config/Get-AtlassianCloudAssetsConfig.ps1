function Get-AtlassianCloudAssetsConfig{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$SchemaId,
        
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsRoot = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    $uri = $assetsRoot + 'global/config'

    if ($Id) {
        $uri.Replace('global',"$SchemaId")
    }
    Write-Verbose "[GET] $uri"

    Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}