function Remove-AtlassianCloudJsmServiceDeskSlaMetric{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
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

    $uri = "https://$AtlassianOrgName.atlassian.net/rest/servicedesk/1/servicedesk/agent/$ProjectKey/sla/metrics/$Id"

    Write-Verbose "[$DELETE] $uri"
    return Invoke-RestMethod -Method Delete -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}