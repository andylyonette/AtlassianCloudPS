function Get-AtlassianCloudJiraWorkflowStatus{
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

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "status/$Id" -Pat $Pat -Verbose:($Verbose.IsPresent)
}