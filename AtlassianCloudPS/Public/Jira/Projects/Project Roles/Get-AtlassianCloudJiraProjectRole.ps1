function Get-AtlassianCloudJiraProjectRole{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$ProjectKey,

        [Parameter(Mandatory=$false, Position=1)]
        [int]$Id,

        [Parameter(Mandatory=$false, Position=2)]
        [bool]$ExcludeInactiveUsers = $false,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($ProjectKey) {
        if ($Id) {
            return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectKey/role/$Id?excludeInactiveUsers=$ExcludeInactiveUsers" -Pat $Pat -Verbose:($Verbose.IsPresent)
        } else {
            return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectKey/role" -Pat $Pat -Verbose:($Verbose.IsPresent)
        }
    } else {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "role/$Id" -Pat $Pat -Verbose:($Verbose.IsPresent)
    }
}