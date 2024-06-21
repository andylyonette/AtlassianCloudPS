function New-AtlassianCloudJiraIssueFieldContext{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
 
        [Parameter(Mandatory = $false, Position=3)]
        [string[]]$ProjectIds = @(),
 
        [Parameter(Mandatory = $false, Position=4)]
        [string[]]$IssueTypeIds = @(), 
 
        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        projectIds = $ProjectIds
        issueTypeIds = $IssueTypeIds
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint "field/$FieldId/context" -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).id
}