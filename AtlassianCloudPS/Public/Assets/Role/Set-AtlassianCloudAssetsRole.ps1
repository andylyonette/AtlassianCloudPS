function Set-AtlassianCloudAssetsRole{
    [CmdletBinding()]
    [Alias('Get-AtlassianCloudAssetsSchema')]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$RoleId,
        
        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$AccountIds,

        [Parameter(Mandatory = $false, Position=2)]
        [string[]]$GroupNames,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $uri = "https://$($AtlassianOrgName).atlassian.net/gateway/api/jsm/assets/workspace/$($WorkspaceId)/v1/config/role/$($RoleId)"

    $data = @{
        id = $RoleId
        categorisedActors = @{
            'atlassian-user-role-actor' = @(
                $(foreach ($accountId in $AccountIds) {
                    $accountId
                })
            )
            'atlassian-group-role-actor' = @(
                $(foreach ($groupName in $GroupNames) {
                    $groupName
                })
            )
        }
    }

    $body = $data | ConvertTo-Json -Depth 10

    Write-Verbose "[PUT] $uri"
    Write-Verbose "[BODY] $body"
    Invoke-RestMethod -Method Put -Body $body -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}

