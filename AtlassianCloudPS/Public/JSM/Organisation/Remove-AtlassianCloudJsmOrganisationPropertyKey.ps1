function Remove-AtlassianCloudJsmOrganisationPropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/property/$PropertyKey" -Method Delete -Pat $Pat -Verbose:($Verbose.IsPresent) 
}
