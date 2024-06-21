function Set-AtlassianCloudJiraIssueTypeScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$DefaultIssueTypeId,
 
        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}

    if ($Name) {
        $data += @{
            name = $Name
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($DefaultIssueTypeId) {
        $data += @{
            defaultIssueTypeId = $DefaultIssueTypeId
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "issuetypescheme/$Id" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}