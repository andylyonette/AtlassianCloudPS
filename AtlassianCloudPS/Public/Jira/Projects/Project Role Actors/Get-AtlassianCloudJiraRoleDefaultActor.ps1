function Get-AtlassianCloudJiraRoleDefaultActor{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [int]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "role/$Id/actors" -Pat $Pat -Verbose:($Verbose.IsPresent)

}