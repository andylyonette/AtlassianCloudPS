function Set-AtlassianCloudJiraProjectComponent{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('PROJECT_DEFAULT','COMPONENT_LEAD','PROJECT_LEAD','UNASSIGNED')]
        [string]$AssigneeType,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$LeadAccountId,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}

    if ($Name) {
        name = $Name
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($AssigneeType) {
        $data += @{
            assigneeType = $AssigneeType
        }
    }

    if ($LeadAccountId) {
        $data += @{
            leadAccountId = $LeadAccountId
        }
    }


    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "component" -Pat $Pat -Verbose:($Verbose.IsPresent)
}