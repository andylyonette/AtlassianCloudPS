function Get-AtlassianCloudJiraWorkflowTransitionProperty{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkflowName,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('live','draft')]
        [string]$WorkflowMode = 'live',

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Key,

        [Parameter(Mandatory = $false, Position=4)]
        [bool]$IncludeReservedKeys = $false,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "workflow/transitions/$($Id)/properties?workflowName=$($WorkflowName)&workflowMode=$($WorkflowMode)&includeReserverdKeys=$($IncludeReservedKeys)"

    if ($Key) {
        $endpoint += "&key=$($Key)"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}