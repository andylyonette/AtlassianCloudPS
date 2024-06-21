function New-AtlassianCloudJsmServiceDeskCustomer{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
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
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/customer" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}