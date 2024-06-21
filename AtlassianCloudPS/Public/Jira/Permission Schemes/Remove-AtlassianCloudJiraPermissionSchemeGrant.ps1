function Remove-AtlassianCloudJiraPermissionSchemeGrant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemeId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$PermissionId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )


    $endpoint = "permissionscheme/$($SchemeId)/permission/$PermissionId"

    return Invoke-AtlassianCloudJiraMethod -Method Delete -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}