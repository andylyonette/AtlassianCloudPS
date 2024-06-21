function Get-AtlassianCloudJiraIssueTransition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
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

    return (Invoke-RestMethod -Method Get -Uri ($jiraEndpoint + "issue/$IssueKey/transitions") -ContentType application/json -Headers $headers).transitions
}