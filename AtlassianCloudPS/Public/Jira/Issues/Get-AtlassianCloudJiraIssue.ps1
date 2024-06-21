function Get-AtlassianCloudJiraIssue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('renderedFields',',names','schema','transitions','editmeta','changelog','versionedRepresentations')]
        [string[]]$Expand,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "issue/$IssueKey"

    if ($Expand) {
        $endpoint += "?expand=$($Expand -join '&expand=')"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}