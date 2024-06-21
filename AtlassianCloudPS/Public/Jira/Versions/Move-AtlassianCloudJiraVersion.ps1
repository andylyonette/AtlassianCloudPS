function Move-AtlassianCloudJiraVersion{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$After,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('Earlier','Later','First','Last')]
        [string]$Position,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($After -and $Position) {
        Write-Error 'Provide only After or Position'
    } else {
        if (!$After -and !$Position) {
            Write-Error 'Provide either After or Position'
        } else {
            $data = @{}

            if ($After) {
                $data += @{
                    after = $After
                }
            }

            if ($Position) {
                $data += @{
                    position = $Position
                }
            }

            return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "version/$Id/move" -Pat $Pat -Verbose:($Verbose.IsPresent)
        }
    }
}