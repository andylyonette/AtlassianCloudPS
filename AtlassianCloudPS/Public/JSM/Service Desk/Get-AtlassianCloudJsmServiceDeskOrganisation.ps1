function Get-AtlassianCloudJsmServiceDeskOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$AccountId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/organization?accountId=$AccountId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}