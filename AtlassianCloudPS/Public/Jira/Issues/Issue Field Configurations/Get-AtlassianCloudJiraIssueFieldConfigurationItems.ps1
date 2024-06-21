function Get-AtlassianCloudJiraIssueFieldConfigurationItems{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = "fieldconfiguration/$Id/fields?maxResults=200"

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    if ($Experimental) {
        $headers += @{
            'X-ExperimentalApi' = 'opt-in'
        }
    }

    $jiraRoot = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    $uri = $jiraRoot + $Endpoint
    $ResponseProperty = 'values'

    Write-Verbose "[GET] $uri"
    $response = Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

    if ($response) {
        $entities = @()
        foreach ($entity in $response.$ResponseProperty) {
            $entities += $entity
        }
        
        if ($All) {
            while ($response.total -gt $entities.count) {
                $uri2 = $uri + "&startAt=$($entities.count)"
                Write-Verbose "[GET] $uri2"
                $response = Invoke-RestMethod -Method Get -Uri $uri2 -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
                foreach ($entity in $response.$ResponseProperty) {
                    $entities += $entity
                }   
                Write-Host "$($entities.count)/$($response.total)"     
            }
        }

        return $entities
    }
}