function Invoke-AtlassianCloudAssetsMethod{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory = $false, Position=2)]
        [psobject]$Data,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('Delete','Post','Put')]
        [string]$Method = 'Post',

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Pat,

        [Parameter()]
        [switch]$Experimental
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    if ($Experimental) {
        $headers += @{
            'X-ExperimentalApi' = 'opt-in'
        }
    }

    $assetsRoot = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    $uri = $assetsRoot + $Endpoint

    Write-Verbose "[$Method] $uri"
    $response = Invoke-WebRequest -Method $Method -Body ($Data | ConvertTo-Json -Depth 10) -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

    if ($response.StatusCode -eq 429) {
        Start-Sleep -Seconds 1
        $response = Invoke-WebRequest -Method $Method -Body ($Data | ConvertTo-Json -Depth 10) -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
    }

    if ($response.Content) {
        return $response.Content | ConvertFrom-Json
    }
}