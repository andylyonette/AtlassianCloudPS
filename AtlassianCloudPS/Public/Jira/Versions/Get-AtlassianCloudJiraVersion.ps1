function Get-AtlassianCloudJiraVersion{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$ProjectKey,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Id,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    if ($ProjectKey) {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectKey/version/$Id" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
    } else {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "version/$Id" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
    }
}