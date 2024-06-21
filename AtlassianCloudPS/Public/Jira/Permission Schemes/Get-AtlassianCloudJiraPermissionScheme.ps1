function Get-AtlassianCloudJiraPermissionScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('all','field','group','permissions','projectRole','user')]
        [string[]]$Expand,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($Id) {
        $endpoint = "permissionscheme/$($Id)"
    } else {
        $endpoint = "permissionscheme"
    }

    if ($Expand) {
        $endpoint += "?expand=$($Expand -join ',')"
    }
    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -Verbose:($Verbose.IsPresent)
}