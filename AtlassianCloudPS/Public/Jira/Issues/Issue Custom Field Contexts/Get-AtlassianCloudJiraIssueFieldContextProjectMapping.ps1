function Get-AtlassianCloudJiraIssueFieldContextProjectMapping{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "field/$($Id)/context/projectmapping"

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}