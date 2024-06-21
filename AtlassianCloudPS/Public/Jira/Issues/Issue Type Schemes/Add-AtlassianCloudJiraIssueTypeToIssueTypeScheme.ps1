function Add-AtlassianCloudJiraIssueTypeToIssueTypeScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueTypeSchemeId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        issueTypeIds = @(
            $IssueTypeId
        )
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "issuetypescheme/$($IssueTypeSchemeId)/issuetype" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}