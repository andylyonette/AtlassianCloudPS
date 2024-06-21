function Get-AtlassianCloudAssetsIcon{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,
        
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

    if ($Id) {
        $uri = $assetsRoot + "icon/$Id"
    } else {
        $uri = $assetsRoot + 'icon/global'
        
    }

    Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}