function New-AtlassianCloudJiraIssueNotificationScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Description,
 
        [Parameter(Mandatory = $false, Position=2)]
        [psobject[]]$NotificationSchemeEvents,
 
        [Parameter(Mandatory = $false, Position=3)]
        [string]$AdditionalProperties,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
    }

    if ($NotificationSchemeEvents) {
        $data += @{
            notificationSchemeEvents = @(
                $(foreach ($notificationSchemeEvent in $NotificationSchemeEvents) {
                    $notificationSchemeEvent
                })
            )
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($AdditionalProperties) {
        $data += @{
            additionalProperties = $AdditionalProperties
        }
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint 'notificationscheme' -Experimental -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).id
}