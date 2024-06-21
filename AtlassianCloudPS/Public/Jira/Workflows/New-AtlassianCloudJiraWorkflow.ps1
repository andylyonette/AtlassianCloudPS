function New-AtlassianCloudJiraWorkflow{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateSet('GLOBAL','PROJECT')]
        [string]$Scope,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$ProjectId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$Statuses,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$Workflows,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$ValidateOnly
    )

    $data = @{
        scope = @{
            type = $scope
        }
        statuses = $Statuses
        workflows = $Workflows
    }

    if ($ProjectId) {
        $data.scope += @{
            project = $ProjectId
        }
    }

    if ($ValidateOnly) {
        $endpoint = 'workflows/create/validation'

        $data = @{
            payload = $data
            validationOptions = @{
                levels = @(
                    'ERROR'
                    'WARNING'
                )
            }
        }
    } else {
        $endpoint = 'workflows/create'
    }
    return Invoke-AtlassianCloudJiraMethod -Data $data -Method Post -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
}