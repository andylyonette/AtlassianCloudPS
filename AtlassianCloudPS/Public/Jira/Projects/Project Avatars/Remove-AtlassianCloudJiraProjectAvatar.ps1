function Remove-AtlassianCloudJiraProjectAvatar{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Delete -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectKey/avatar/$Id" -Pat $Pat -Verbose:($Verbose.IsPresent)
}