function Get-AtlassianCloudJiraWorkflowSchemeBulk{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$WorkflowSchemeIds,

        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$ProjectIds,

        [Parameter(Mandatory = $false, Position=2)]
        [bool]$Draft = $false,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $data = @{}

    if ($ProjectId) {
        $data += @{
            projectIds = $ProjectIds
        }
    } elseif ($Id) {
        $data += @{
            workflowSchemeIds = $WorkflowSchemeIds
        }    
    }

    return Invoke-AtlassianCloudJiraMethod -Data $data -Method Post -AtlassianOrgName $AtlassianOrgName -Endpoint 'workflowscheme/read' -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
}