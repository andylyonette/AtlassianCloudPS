function Get-AtlassianCloudJiraIssueFieldConfigurationIssueTypeItems{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$Id,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = "fieldconfigurationscheme/mapping"
    if ($Id) {
        $endpoint += "?fieldConfigurationSchemeId=$($Id -join '&fieldConfigurationSchemeId=')"
    }


    $headers = @{
        Authorization = "Basic $($Pat)"
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
                if ($url -like "*?*") {
                    $uri2 = $uri + "&startAt=$($entities.count)"
                } else {
                    $uri2 = $uri + "?startAt=$($entities.count)"
                }
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