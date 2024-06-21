function Get-AtlassianCloudJiraSystemAvatar{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Type,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return (Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "avatar/$Type/system" -Pat $Pat -Verbose:($Verbose.IsPresent)).system
}