function Get-AtlassianCloudJsmRequest{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$IssueKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$SummaryFilter,
  
        [Parameter(Mandatory = $false, Position=2)]
        [string]$OrganisationId,
  
        [Parameter(Mandatory = $false, Position=3)]
        [string]$RequestTypeId,
  
        [Parameter(Mandatory = $false, Position=4)]
        [string]$ServiceDeskId,
  
        [Parameter(Mandatory = $false, Position=5)]
        [ValidateSet('OWNED_REQUESTS','PARTICIPATED_REQUESTS','ORGANIZATION','ALL_ORGANIZATIONS','APPROVER','ALL_REQUESTS')]
        [string[]]$RequestOwnership,
 
        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $queryParameters = @()
    
    if ($SummaryFilter) {
        $queryParameters += "searchTerm=$SummaryFilter"
    }    

    if ($RequestOwnership) {
        foreach ($requsetOwnershipValue in $RequestOwnership) {
            $queryParameters += "requestOwnership=$requsetOwnershipValue"
        }
    }
    
    if ($OrganisationId) {
        $queryParameters += "organizationId=$OrganisationId"
    }
    
    if ($RequestTypeId) {
        $queryParameters += "requestTypeId=$RequestTypeId"
    }
    
    if ($ServiceDeskId) {
        $queryParameters += "serviceDeskId=$ServiceDeskId"
    }

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint ('request' + $(if ($IssueKey) {"/$IssueKey"}) + '?' + ($queryParameters -join '&')) -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}