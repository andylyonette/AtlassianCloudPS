function Set-AtlassianCloudJiraIssueNotificationScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
 
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

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint "notificationscheme/$($Id)" -Experimental -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}