function Find-AtlassianCloudJiraIssue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Query,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jiraEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"
    $uri = $jiraEndpoint + 'search'

    $body = @{
        jql = $Query
        maxResults = 100
        startAt = 0
    }
    
    $jqlIssueRequest = Invoke-RestMethod -Method Post -Body ($body | ConvertTo-Json) -Uri $uri -ContentType application/json -Headers $headers

    $issues = @()
    foreach ($issue in $jqlIssueRequest.issues) {
        $issues += $issue
    }

    while (($jqlIssueRequest.startAt + $jqlIssueRequest.maxResults) -lt $jqlIssueRequest.total) {
        $body.startAt = $jqlIssueRequest.maxResults + $jqlIssueRequst.startAt
        Write-Verbose "Getting issues [$($body.startAt) - $([array]($body.maxResults + $body.startAt),$jqlIssueRequest.total | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum)/$($jqlIssueRequst.total)]"

        $jqlIssueRequest = Invoke-RestMethod -Method Post -Body ($body | ConvertTo-Json) -Uri $uri -ContentType application/json -Headers $headers
        foreach ($issue in $jqlIssueRequest.issues) {
            $issues += $issue
        }
    }

    return $issues
}