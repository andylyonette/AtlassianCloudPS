function New-AtlassianCloudJiraWorkflowScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Description,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$DefaultWorkflow,
 
        [Parameter(Mandatory = $false, Position=3)]
        [psobject]$IssueTypeMappings,
 
        [Parameter(Mandatory, Position=4)]
        [bool]$UpdateDraftIfNeeded = $false,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        issueTypeMappings = $IssueTypeMappings
        updateDraftIfNeeded = $UpdateDraftIfNeeded
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }
    if ($DefaultWorkflow) {
        $data += @{
            defaultWorkflow = $DefaultWorkflow
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Data $data -Method Post -AtlassianOrgName $AtlassianOrgName -Endpoint 'workflowscheme' -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
}