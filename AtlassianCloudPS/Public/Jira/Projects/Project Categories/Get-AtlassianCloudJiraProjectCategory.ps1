function Get-AtlassianCloudJiraProjectCategory{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [int]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    if ($Id) {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "projectCategory/$Id" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
    } else {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "projectCategory" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
    }
}