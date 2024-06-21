function New-AtlassianCloudJiraIssueType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('standard','subtask')]
        [string]$HierarchyLevel = 'standard',
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        hierarchyLevel = $(
            switch ($HierarchyLevel) {
                'standard' {0}
                'subtask' {-1}
            }
        )
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint 'issuetype' -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}