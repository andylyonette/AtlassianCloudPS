function Get-AtlassianCloudAssetsEntity{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory = $false, Position=0)]
        [string]$ResponseProperty,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

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

    Write-Verbose "[GET] $uri"
    $response = Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
    
    $values = @()

    if ($ResponseProperty) {
        foreach ($value in $response.$ResponseProperty) {
            $values += $value
        }
    } else {
        foreach ($value in $response) {
            $values += $value
        }
    }


    while ($false -eq $response.isLast) {
        $uri2 = ($assetsRoot + $Endpoint + "?startAt=$(1 + $response.startAt + $response.maxResults)")
        Write-Verbose "[GET] $uri2"
        
        $response = Invoke-RestMethod -Method Post -Body $body -Uri $uri2 -ContentType application/json -Headers $headers
        if ($ResponseProperty) {
            foreach ($value in $response.$ResponseProperty) {
                $values += $value
            }
        } else {
            foreach ($value in $response) {
                $values += $value
            }
        }
    } 

    return $values
}