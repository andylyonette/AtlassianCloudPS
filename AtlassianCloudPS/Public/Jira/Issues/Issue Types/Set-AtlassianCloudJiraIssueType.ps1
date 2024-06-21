function Set-AtlassianCloudJiraIssueType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
 
        [Parameter(Mandatory = $false, Position=3)]
        [int]$AvatarId,
 
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

    if ($AvatarId) {
        $data += @{
            avatarId = $AvatarId
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "issuetype/$Id" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}