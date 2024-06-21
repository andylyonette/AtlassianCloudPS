function Get-AtlassianCloudJiraPermissionSchemeGrant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemeId,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$PermissionId,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('permissions','user','group','projectRole','field','all')]
        [string[]]$Expand,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($PermissionId) {
        $endpoint = "permissionscheme/$($SchemeId)/permission/$($PermissionId)"
    } else {
        $endpoint = "permissionscheme/$($SchemeId)/permission/"
    }

    if ($Expand) {
        $endpoint += "?expand=$($Expand -join '&expand=')"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -Verbose:($Verbose.IsPresent)
}