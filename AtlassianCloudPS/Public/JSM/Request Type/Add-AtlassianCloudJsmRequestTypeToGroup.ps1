function Add-AtlassianCloudJsmRequestTypeToGroup{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string[]]$GroupIds,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
          groupIds = $GroupIds
    }

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $uri = "https://$AtlassianOrgName.atlassian.net/rest/servicedesk/1/servicedesk/$ServiceDeskId/request-types/$RequestTypeId/groups"

    $body = ($data | ConvertTo-Json -Depth 10)
    Write-Verbose "[$Method] $uri"
    Write-Verbose "Body: $body"
    return Invoke-RestMethod -Method Put -Body $body -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}