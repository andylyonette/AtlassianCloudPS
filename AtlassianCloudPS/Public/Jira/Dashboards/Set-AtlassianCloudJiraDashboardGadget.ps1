function Set-AtlassianCloudJiraDashboardGadget{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$DashboardId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [int]$GadgetId,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Title,

        [Parameter(Mandatory = $false, Position=3)]
        [int]$ColumnPosition,

        [Parameter(Mandatory = $false, Position=4)]
        [int]$RowPosition,

        [Parameter(Mandatory = $false, Position=5)]
        [ValidateSet('blue','red','yellow','green','cyan','purple','gray','white')]
        [string]$Colour,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if (($ColumnPosition -and !$RowPosition) -or (!$ColumnPosition -and $RowPosition)) {
        Write-Error "ColumnPosition and RowPosition must be provided together"
    } else {

        $data = @{}

        if ($Title) {
            $data += @{
                title = $Title
            }
        }

        if ($ColumnPosition -and $RowPosition) {
            $data += @{
                position = @{
                    column = $ColumnPosition
                    row = $RowPosition
                }
            }
        }

        if ($Colour) {
            $data += @{
                color = $Colour
            }
        }

        return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "dashboard/$DashboardId/gadget/$GadgetId" -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
    }
}