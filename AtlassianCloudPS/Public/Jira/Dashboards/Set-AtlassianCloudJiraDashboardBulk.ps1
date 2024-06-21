function Set-AtlassianCloudJiraDashboardBulk{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int[]]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateSet('cahngeOwner','changePermission','addPermission','removePermission')]
        [string]$Action,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$NewOwner,

        [Parameter(Mandatory = $false, Position=3)]
        [bool]$NewOwnerAutoFixName,

        [Parameter(Mandatory = $false, Position=4)]
        [bool]$ExtendAdminPermissions,

        [Parameter(Mandatory = $false, Position=5)]
        [psboject]$EditPermissions,

        [Parameter(Mandatory = $false, Position=6)]
        [psboject]$SharePermissions,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $ids = @()
    foreach ($i in $Id) {
        $ids += $i
    }

    $data = @{
        entityIds = $ids
        action = $Action
    }

    switch ($Action) {
        'changeOwner' {
            $data += @{
                changeOwnerDetails = @{
                    autoFixName = $NewOwnerAutoFixName
                    newOwner = $NewOwner
                }
            }
        }

        'changePermission' {
            $data += @{
                extendAdminPermissions = $ExtendAdminPermissions
                permissionDetails = @{
                    editPermissions = $EditPermissions
                    sharePermissions = $SharePermissions
                }
            }
        }

        'addPermission' {
            $data += @{
                extendAdminPermissions = $ExtendAdminPermissions
                permissionDetails = @{
                    editPermissions = $EditPermissions
                    sharePermissions = $SharePermissions
                }
            }
        }

        'removePermission' {
            $data += @{
                extendAdminPermissions = $ExtendAdminPermissions
                permissionDetails = @{
                    editPermissions = $EditPermissions
                    sharePermissions = $SharePermissions
                }
            }
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "dashboard/$Id" -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent)
}