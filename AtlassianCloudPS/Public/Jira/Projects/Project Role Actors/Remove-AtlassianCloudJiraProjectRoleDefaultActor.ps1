function Remove-AtlassianCloudJiraProjectRoleDefaultActor{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$UserAccountId,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$GroupId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if (!$UserAccountId -and !$GroupId) {
        Write-Error 'Must provide one of UserAccountId and GroupId'
    } else {
        if ($UserAccountId -and $GroupId) {
            Write-Error 'Cannot provide UserAccountId and GroupId at the same time'
        } else {
            $endpoint = "role/$Id/actors?"
            if ($UserAccountId) {
                $endpoint += "user=$UserAccountId"
            } else {
                $endpoint += "groupId=$GroupId"
            }
        }
    }
    return Invoke-AtlassianCloudJiraMethod -Method Delete -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}