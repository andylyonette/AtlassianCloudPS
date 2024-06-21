function Get-AtlassianCloudJiraAvatar{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateSet('project','issuetype')]
        [string]$Type,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$EntityId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($EntityId) {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "universal_avatar/type/$Type/owner/$EntityId" -ResponseProperty system -Pat $Pat -Verbose:($Verbose.IsPresent)
    } else {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "avatar/$Type/system" -ResponseProperty system -Pat $Pat -Verbose:($Verbose.IsPresent)
    }
}