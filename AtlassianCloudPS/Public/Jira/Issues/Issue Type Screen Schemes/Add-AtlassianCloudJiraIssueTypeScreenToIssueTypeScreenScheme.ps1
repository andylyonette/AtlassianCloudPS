function Add-AtlassianCloudJiraIssueTypeScreenScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$IssueTypeScreenSchemeMappings,
  
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        issueTypeMappings = @(
            $(foreach ($issueTypeScreenSchemeMapping in $IssueTypeScreenSchemeMappings) {
                $issueTypeScreenSchemeMapping
            })
        )
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "issuetypescreenscheme/$($Id)/mapping" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}