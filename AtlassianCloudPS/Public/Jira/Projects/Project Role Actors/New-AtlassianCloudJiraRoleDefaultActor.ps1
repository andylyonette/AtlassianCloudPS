function New-AtlassianCloudJiraRoleDefaultActor{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$UserAccountId,

        [Parameter(Mandatory = $false, Position=2)]
        [string[]]$GroupId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if (!$UserAccountId -and !$GroupId) {
        Write-Error 'Must provide one of UserAccountId and GroupId'
    } else {
        if ($UserAccountId -and $GroupId) {
            Write-Error 'Cannot provide UserAccountId and GroupId at the same time'
        } else {
            if ($UserAccountId) {
                $users = @()
                foreach ($user in $UserAccountId) {
                    $users += $UserAccountId
                }
                $data = @{
                    user = $users
                }
            } else {
                $groups = @()
                foreach ($group in $GroupId) {
                    $groups += $group
                }
                $data = @{
                    groupId = $groups
                }
            }
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "role/$Id/actors" -Pat $Pat -Verbose:($Verbose.IsPresent)
}