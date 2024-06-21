function Get-AtlassianCloudJsmServiceDeskRequestTypeUi{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $uri = "https://$AtlassianOrgName.atlassian.net/rest/servicedesk/1/servicedesk/$ProjectId/request-types"

    Write-Verbose "[GET] $uri"
    return (Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)).ticketTypes
}