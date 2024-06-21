function Get-AtlassianCloudFormsEntity{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$CloudId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory, Position=2)]
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

    $formsRoot = "https://api.atlassian.com/jira/forms/cloud/$CloudId/"

    $uri = $formsRoot + $Endpoint

    Write-Verbose "[GET] $uri"
    return Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}
