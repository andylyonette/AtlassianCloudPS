function Get-AtlassianCloudJiraProjectNotificationScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=1)]
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

    $endpoint = "project/$ProjectKey/notificationscheme"

    if ($Expand) {
        $endpoint += "?$($Expand -join '&expand=')"
    }
    
    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}