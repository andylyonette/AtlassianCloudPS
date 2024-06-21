function Set-AtlassianCloudJiraIssueCustomFieldAssetsConfig{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ContextId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemaId,
  
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$ObjectFilterQuery,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$IssueScopeFilterQuery,

        [Parameter(Mandatory = $false, Position=5)]
        [bool]$Multiple = $false,

        [Parameter(Mandatory = $false, Position=6)]
        [string[]]$AttributesDisplayedOnIssue = @('Name'),

        [Parameter(Mandatory = $false, Position=7)]
        [string[]]$AttributesIncludedInAutoCompleteSearch = @('Name'),

        [Parameter(Mandatory = $false, Position=8)]
        [bool]$SetDefaultValuesFromEmptySearch = $false,

        [Parameter(Mandatory, Position=9)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=10)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        objectSchemaId = $SchemaId
        workspaceId = $WorkspaceId
        objectFilterQuery = $ObjectFilterQuery
        multiple = $Multiple.ToString().ToLower()
        shouldSetDefaultValuesFromEmptySearch = $SetDefaultValuesFromEmptySearch.ToString().ToLower()
        attributesDisplayedOnIssue = $AttributesDisplayedOnIssue
        attributesIncludedInAutoCompleteSearch = $AttributesIncludedInAutoCompleteSearch
    }

    if ($IssueScopeFilterQuery) {
        $data += @{
            issueScopeFilterQuery = $IssueScopeFilterQuery
        }
    }

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $uri = "https://$AtlassianOrgName.atlassian.net/rest/servicedesk/cmdb/latest/fieldconfig/$($ContextId)/"
    $body = ($Data | ConvertTo-Json -Depth 10)
    Write-Verbose "[PUT] $uri"
    Write-Verbose "Body: $body"
    return Invoke-RestMethod -Method Put -Body $body -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}