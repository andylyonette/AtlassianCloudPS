function Remove-AtlassianCloudJsmRequestParticipant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
  
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
        
        [Parameter(Mandatory, Position=2)]
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
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/participant" -Method Delete -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}