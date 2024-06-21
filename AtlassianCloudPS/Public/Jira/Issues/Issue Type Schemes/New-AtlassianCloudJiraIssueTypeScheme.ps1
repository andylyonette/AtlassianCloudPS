function New-AtlassianCloudJiraIssueTypeScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string[]]$IssueTypeIds,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$DefaultIssueTypeId,
 
        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        issueTypeIds = $IssueTypeIds
    }

    if ($DefaultIssueTypeId) {
        $data += @{
            defaultIssueTypeId = $DefaultIssueTypeId
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint 'issuetypescheme' -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).issueTypeSchemeId
}