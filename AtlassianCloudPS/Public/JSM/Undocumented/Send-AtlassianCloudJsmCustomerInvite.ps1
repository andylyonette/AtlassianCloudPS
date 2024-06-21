function Send-AtlassianCloudJsmCustomerInvite{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

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

    $body = @{
        emails = @($EmailAddress)
    } | ConvertTo-Json

    return Invoke-RestMethod -Method Post -Body $body -Uri "https://$AtlassianOrgName.atlassian.net/rest/servicedesk/1/pages/people/customers/pagination/$ProjectKey/invite" -ContentType application/json -Headers $headers
}