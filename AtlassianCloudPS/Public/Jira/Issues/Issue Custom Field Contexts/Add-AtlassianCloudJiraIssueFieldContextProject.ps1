function Add-AtlassianCloudJiraIssueFieldContextProject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ContextId,
  
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ProjectIds,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        projectIds = $ProjectIds
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "field/$FieldId/context/$ContextId/project" -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}