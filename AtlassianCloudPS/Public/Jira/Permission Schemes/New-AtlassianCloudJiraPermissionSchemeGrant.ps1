function New-AtlassianCloudJiraPermissionSchemeGrant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemeId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Permission,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Type,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Value,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        permission = $Permission
        holder = @{
            type = $Type
        }
    }

    if ($Value) {
        $data.holder += @{
            value = $value
        }
    }

    $endpoint = "permissionscheme/$($SchemeId)/permission/$PermissionId"

    return Invoke-AtlassianCloudJiraMethod -Method Post -Date $data -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}