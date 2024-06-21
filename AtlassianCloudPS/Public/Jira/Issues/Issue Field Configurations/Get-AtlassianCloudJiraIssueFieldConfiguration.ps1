function Get-AtlassianCloudJiraIssueFieldConfiguration{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Query,
 
        [Parameter(Mandatory = $false, Position=2)]
        [bool]$DefaultOnly = $false,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = "fieldconfiguration?isDefault=$($DefaultOnly.ToString().ToLower())&maxResults=200"
    if ($Id) {
        $endpoint += "&id=$($Id -join '&id=')"
    }

    if ($Query) {
        $endpoint += "&query=$($Query)"
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