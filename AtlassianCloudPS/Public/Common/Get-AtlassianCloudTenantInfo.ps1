function Get-AtlassianCloudTenantInfo{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    return Invoke-RestMethod -Method Get -Uri "https://$AtlassianOrgName.atlassian.net/_edge/tenant_info" -ContentType application/json -Headers $headers
}