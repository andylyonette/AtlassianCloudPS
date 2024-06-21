function Merge-AtlassianCloudJiraVersion{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$MoveIssuesTo,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Put -AtlassianOrgName $AtlassianOrgName -Endpoint "version/$Id/mergeto/$MoveIssuesTo" -Pat $Pat -Verbose:($Verbose.IsPresent)
}