function Get-AtlassianCloudJiraWorkflowStatusCategory{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "statuscategory/$Id" -Pat $Pat -Verbose:($Verbose.IsPresent)
}