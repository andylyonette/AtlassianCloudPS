function New-AtlassianCloudJiraVersion{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [int]$ProjectId,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=3)]
        [DateTime]$StartDate,

        [Parameter(Mandatory = $false, Position=4)]
        [DateTime]$ReleaseDate,

        [Parameter(Mandatory = $false, Position=5)]
        [bool]$Archived,

        [Parameter(Mandatory = $false, Position=6)]
        [ValidateSet('operations','issuesstatus')]
        [string]$Expand,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        projectId = $ProjectId
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($StartDate) {
        $data += @{
            startDate = "$($StartDate | Get-Date -Format 'yyyy-MM-dd')"
        }
    }
    
    if ($ReleaseDate) {
        $data += @{
            releaseDate = "$($ReleaseDate | Get-Date -Format 'yyyy-MM-dd')"
        }
    }
    
    if ($Archived) {
        $data += @{
            archived = $Archived
        }
    }

    if ($Expand) {
        $expandList = @()
        $Expand | ForEach-Object {$expandList += $_}
        $data += @{
            expand = $expandList
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "version" -Pat $Pat -Verbose:($Verbose.IsPresent)
}