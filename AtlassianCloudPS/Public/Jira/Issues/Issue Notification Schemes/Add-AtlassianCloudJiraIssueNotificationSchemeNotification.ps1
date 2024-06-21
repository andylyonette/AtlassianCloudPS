function Set-AtlassianCloudJiraIssueNotificationScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$NotificationSchemeEvents,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        notificationSchemeEvents = @(
            $(foreach ($notificationSchemeEvent in $NotificationSchemeEvents) {
                $notificationSchemeEvent
            })
        )
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint "notificationscheme/$($Id)" -Experimental -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}