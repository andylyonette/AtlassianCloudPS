function Get-AtlassianCloudJiraProjectComponent{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [int]$Id,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$ProjectKey,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    if ($Id) {
        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "component/$Id" -Pat $Pat -Verbose:($Verbose.IsPresent)
    } else {
        if ($ProjectKey) {
            return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectKey/component" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
        } else {
            Write-Error "Either a component ID or project key must be specified"
        }
    }

    
}
