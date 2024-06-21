function Set-AtlassianCloudJiraPermissionScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=3)]
        [psobject[]]$Permissions,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$Scope,

        [Parameter(Mandatory = $false, Position=5)]
        [string]$AdditionalProperties,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($Permissions) {
        $data += @{
            permissions = @(
                $(foreach ($permission in $Permissions) {
                    $permission
                })
            )
        }
    }

    if ($Scope) {
        $data += @{
            scope = $Scope
        }
    }

    if ($AdditionalProperties) {
        $data += @{
            additionalProperties = $AdditionalProperties
        }
    }

    $endpoint = "permissionscheme/$($Id)"

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}