function New-AtlassianCloudJiraStatus{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Description,

        [Parameter(Mandatory, Position=2)]
        [ValidateSet('TODO','IN_PROGRESS','DONE')]
        [string]$Category,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('GLOBAL','PROJECT')]
        [string]$Scope = 'GLOBAL',

        [Parameter(Mandatory = $false, Position=4)]
        [string]$ProjectId,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        statuses = @(
            @{
                name = $Name
                statusCategory = $Category
            }
        )
        scope = @{
            type = $Scope
        }
    }

    if ($Scope -eq 'GLOBAL' -and $ProjectId) {
        $data.scope += @{
            project = @{
                id = $ProjectId
            }
        }
    }

    if ($Description) {
        $data.statuses[0] += @{
            description = $Description
        }
    }

    $endpoint = "statuses"

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}