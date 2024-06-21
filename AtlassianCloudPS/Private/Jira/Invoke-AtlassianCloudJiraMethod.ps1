function Invoke-AtlassianCloudJiraMethod{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory = $false, Position=2)]
        [int]$Version = 3,

        [Parameter(Mandatory = $false, Position=3)]
        [psobject]$Data,

        [Parameter(Mandatory = $false, Position=4)]
        [ValidateSet('Delete','Post','Put')]
        [string]$Method = 'Post',

        [Parameter(Mandatory, Position=5)]
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

    $jiraRoot = "https://$AtlassianOrgName.atlassian.net/rest/api/$($Version)/"

    $uri = $jiraRoot + $Endpoint
    $body = ($Data | ConvertTo-Json -Depth 20)
    Write-Verbose "[$Method] $uri"
    Write-Verbose "Body: $body"
    return Invoke-RestMethod -Method $Method -Body $body -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}