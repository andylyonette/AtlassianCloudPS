function Set-AtlassianCloudJiraVersion{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=3)]
        [DateTime]$StartDate,

        [Parameter(Mandatory = $false, Position=4)]
        [DateTime]$ReleaseDate,

        [Parameter(Mandatory = $false, Position=5)]
        [bool]$Archived,

        [Parameter(Mandatory = $false, Position=6)]
        [string]$MoveUnfixedIssuesTo,

        [Parameter(Mandatory = $false, Position=7)]
        [ValidateSet('operations','issuesstatus')]
        [string]$Expand,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=9)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        id = $Id
    }

    if ($Name) {
        $data += @{
            name = $Name
        }
    }

    if ($ProjectId) {
        $data += @{
            projectId = $ProjectId
        }
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

    if ($MoveUnfixedIssuesTo) {
        $data += @{
            moveUnfixedIssuesTo = $MoveUnfixedIssuesTo
        }
    }

    if ($Expand) {
        $expandList = @()
        $Expand | ForEach-Object {$expandList += $_}
        $data += @{
            expand = $expandList
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "version" -Pat $Pat -Verbose:($Verbose.IsPresent)
}
