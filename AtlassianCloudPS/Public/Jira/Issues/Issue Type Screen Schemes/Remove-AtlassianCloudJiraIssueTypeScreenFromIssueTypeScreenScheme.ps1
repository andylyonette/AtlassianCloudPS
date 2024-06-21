function Set-AtlassianCloudJiraIssueTypeScreenScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string[]]$IssueTypeIds,
  
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        issueTypeIds = @(
            $(foreach ($issueTypeId in $IssueTypeIds) {
                $issueTypeId
            })
        )
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint "issuetypescreenscheme/$($Id)/mapping/remove" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}