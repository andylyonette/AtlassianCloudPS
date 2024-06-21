function Get-AtlassianCloudJiraWorkflowScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$ProjectId,

        [Parameter(Mandatory = $false, Position=2)]
        [bool]$Draft = $false,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = 'workflowscheme'

    if ($ProjectId) {
        $endpoint += "/project?projectId=$($ProjectId -join '&projectid=')&returnDraftIfExists=$($Draft.ToString().ToLower())"
    } elseif ($Id) {
        $endpoint += "/$($Id)?returnDraftIfExists=$($Draft.ToString().ToLower())"
    } else{
        $endpoint += "?returnDraftIfExists=$($Draft.ToString().ToLower())"
    }


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

    #return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}