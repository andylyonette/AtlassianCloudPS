function Get-AtlassianCloudJsmOrganisationPropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/property/$PropertyKey" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}