function Add-AtlassianCloudJsmOrganisationUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string[]]$AccountIds,

        [Parameter(Mandatory = $false, Position=3)]
        [string[]]$Usernames,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}

    if ($accountIds) {
        $data += @{
            accountIds = @()
        }
        foreach ($accountId in $AccountIds) {
            $data.accountIds += $accountId
        }
    }

    if ($usernames) {
        $data += @{
            usernames = @()
        }
        foreach ($username in $Usernames) {
            $data.usernames += $username
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/user" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent) 
}