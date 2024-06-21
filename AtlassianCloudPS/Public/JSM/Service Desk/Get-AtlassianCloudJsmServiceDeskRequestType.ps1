function Get-AtlassianCloudJsmServiceDeskRequestType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$RequestTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}