function New-AtlassianCloudJiraScreenTabField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$TabId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$ScreenId,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,

        [Parameter(Mandatory = $false, Position=4)]
        [ValidateSet('Earlier','Later','First','Last')]
        [string]$Position,

        [Parameter(Mandatory = $false, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$After,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}

    if ($Position) {
        $data += @{
            position = $Position
        }
    }

    if ($After) {
        $data += @{
            after = $After
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint "screens/$($ScreenId)/tabs/$($TabId)/fields/$($FieldId)/move" -Experimental -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}