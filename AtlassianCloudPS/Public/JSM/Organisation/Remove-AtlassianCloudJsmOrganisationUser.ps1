function Remove-AtlassianCloudJsmOrganisationUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string[]]$AccountIds,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Usernames,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
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

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/user" -Data $data -Method Delete -Pat $Pat -Verbose:($Verbose.IsPresent) 
}