function New-AtlassianCloudJiraProjectomponent{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=1)]
        [string]$ProjectKey,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('PROJECT_DEFAULT','COMPONENT_LEAD','PROJECT_LEAD','UNASSIGNED')]
        [string]$AssigneeType = 'PROJECT_DEFAULT',

        [Parameter(Mandatory = $false, Position=4)]
        [string]$LeadAccountId,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        projectKey = $ProjectKey
        assigneeType = $AssigneeType
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($LeadAccountId) {
        $data += @{
            leadAccountId = $LeadAccountId
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "component" -Pat $Pat -Verbose:($Verbose.IsPresent)
}