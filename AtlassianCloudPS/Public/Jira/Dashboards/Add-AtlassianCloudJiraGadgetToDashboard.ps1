function Add-AtlassianCloudJiraGadgetToDashboard{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$DashboardId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [int]$ColumnPosition,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [int]$RowPosition,

        [Parameter(Mandatory, Position=4)]
        [ValidateSet('blue','red','yellow','green','cyan','purple','gray','white')]
        [string]$Colour,

        [Parameter(Mandatory = $false, Position=5)]
        [string]$Uri,

        [Parameter(Mandatory = $false, Position=6)]
        [string]$ModuleKey,

        [Parameter(Mandatory = $false, Position=7)]
        [bool]$IgnoreUriAndModuleKeyValidation = $false,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=9)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        title = $Title
        coclour = $Clolour
        position = @{
            column = $ColumnPosition
            row = $RowPosition
        }
        ignoreUriAndModuleKeyValidation = $IgnoreUriAndModuleKeyValidation
    }

    if ($ModuleKey -and $Uri) {
        Write-Error "Cannot provide both ModuleKey and Uri"
    } else {
        if (!$ModuleKey -and !$Uri) {
            Write-Error "Must provide either ModuleKey or Uri"
        } else {
            if ($ModuleKey) {
                $data += @{
                    moduleKey = $ModuleKey
                }
            } else {
                $data += @{
                    uri = $Uri
                }
            }

            return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "dashboard/$DashboardId/gadget" -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
        }
    }

}