function Get-AtlassianCloudJiraScreenTabField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$TabId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [int]$ScreenId,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$ProjectKey,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "screens/$($ScreenId)/tabs/$($TabId)/fields"

    if ($ProjectKey) {
        $endpoint += "?projectKey=$($ProjectKey)"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -Verbose:($Verbose.IsPresent)
}