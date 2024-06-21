function Get-AtlassianCloudJiraProjectRoleDetails{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,

        [Parameter(Mandatory=$false, Position=1)]
        [bool]$CurrentMember = $false,

        [Parameter(Mandatory=$false, Position=2)]
        [bool]$ExcludeConnectAddons = $false,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectKey/roledetails?currentMember=$CurrentMember&excludeConnectAddons=$ExcludeConnectAddons" -Pat $Pat -Verbose:($Verbose.IsPresent)
}