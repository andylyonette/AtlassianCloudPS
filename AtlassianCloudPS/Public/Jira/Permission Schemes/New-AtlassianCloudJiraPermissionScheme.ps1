function New-AtlassianCloudJiraPermissionScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=2)]
        [psobject[]]$Permissions,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Scope,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$AdditionalProperties,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
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

    $endpoint = "permissionscheme"

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}