function Get-AtlassianCloudJiraWorkflowBulk{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$Name,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "workflows"

    $data = @{}

    if ($Name) {
        $data += @{
            workflowNames = $Name
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Data $data -Method Post -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
}