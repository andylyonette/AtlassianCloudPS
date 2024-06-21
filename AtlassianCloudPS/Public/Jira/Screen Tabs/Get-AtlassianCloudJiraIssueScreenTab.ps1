function Get-AtlassianCloudJiraScreenTab{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$TabId,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$ScreenId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = 'screens/tabs'

    if ($TabId) {
        $endpoint += "?tabId=$($TabId -join '&tabId=')"
    }

    if ($ScreenId) {
        if ($endpoint -like '*`?*') {
            $endpoint += "&screenId=$($ScreenId -join'&screenId=')"
        } else {
            $endpoint += "?screenId=$($ScreenId -join'&screenId=')"
        }
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Experimental -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}