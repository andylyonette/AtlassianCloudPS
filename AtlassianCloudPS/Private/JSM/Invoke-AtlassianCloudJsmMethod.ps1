function Invoke-AtlassianCloudJsmMethod{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
 
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

    $jsmRoot = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $uri = $jsmRoot + $Endpoint
    $body = ($Data | ConvertTo-Json -Depth 10)
    Write-Verbose "[$Method] $uri"
    Write-Verbose "Body: $body"
    return Invoke-RestMethod -Method $Method -Body $body -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}