function Set-AtlassianCloudJiraAnnouncementBannerConfiguration{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Message,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('public','private')]
        [string]$Visibility,
 
        [Parameter(Mandatory = $false, Position=2)]
        [bool]$Dismissible,

        [Parameter(Mandatory = $false, Position=3)]
        [bool]$Enabled,
  
        [Parameter(Mandatory, Position=17)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=18)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}

    if ($Message) {
        $data += @{
            message = $Message
        }
    }

    if ($Visibility) {
        $data += @{
            visibility = $Visibility
        }
    }

    if ($Dismissible) {
        $data += @{
            isDismissible = $Dismissible
        }
    }

    if ($Enabled) {
        $data += @{
            isEnabled = $Enabled
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Data $data -Method Put -AtlassianOrgName $AtlassianOrgName -Endpoint 'announcementBanner' -Pat $Pat -Verbose:($Verbose.IsPresent)
}