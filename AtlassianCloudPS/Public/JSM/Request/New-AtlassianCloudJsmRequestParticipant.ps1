function New-AtlassianCloudJsmRequestParticipant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$AccountIds,

        [Parameter(Mandatory = $false, Position=2)]
        [string[]]$Usernames,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

      [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        accountIds = @()
        usernames = @()
    }

    foreach ($accountId in $AccountIds) {
        $data.accountIds += $accountId
    }

    foreach ($username in $Usernames) {
        $data.usernames += $username
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/participant" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}
