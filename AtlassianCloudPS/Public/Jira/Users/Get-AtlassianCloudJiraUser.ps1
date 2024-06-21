function Get-AtlassianCloudJiraUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$AccountId,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Query,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
        'X-ExperimentalApi' = 'opt-in'
    }

    $jiraRoot = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    if ($AccountId) {
        $uri = $jiraRoot + "user?accountId=$AccountId"

        Write-Verbose "[GET] $uri"
        return Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
    } elseif ($Query) {
        $uri = $jiraRoot + "user/search?query=$Query?maxResults=1000"

        Write-Verbose "[GET] $uri"
        return Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
    } else {
        $uri = $jiraRoot + "users/search?maxResults=1000"

        Write-Verbose "[GET] $uri"
        
        $users = @()
        $i = 0
        $response = Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
        foreach ($user in $response) {
            $users += $user
        }
        $i = $i + $response.Count
        do {
            $nextUri = "$($uri)&startAt=$($i)"
            Write-Verbose "[GET] $nextUri"
            $response = Invoke-RestMethod -Method Get -Uri $nextUri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
            foreach ($user in $response) {
                $users += $user
            }
            $i = $i + $response.Count
        } while ($response.Count -eq 1000)

        return $users
    }
}