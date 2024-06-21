function Get-AtlassianCloudJiraIssueNotificationScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('all','field','group','notificationSchemeEvents','projectRole','user')]
        [string[]]$Expand,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = "notificationscheme/$($Id)"

    if ($Expand) {
        $endpoint += "?expand=$($Expand -join '&expand=')"
    }
    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}