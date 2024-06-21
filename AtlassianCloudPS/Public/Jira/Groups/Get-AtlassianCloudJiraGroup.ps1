function Get-AtlassianCloudJiraGroup{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$Name,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('site-admin','admin','user')]
        [string]$AccessType,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('jira-servicedesk','jira-software','jira-core')]
        [string]$ApplicationKey,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = "group/bulk?"

    if ($Id) {
        $endpoint += "groupId=$($Id -join '&groupId=')"
    } 
    
    if ($Name) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }

        $endpoint += "groupName=$($Name -join '&groupName=')"
    }

    if ($AccessType) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }

        $endpoint += "accessType=$($AccessType)"
    }

    if ($ApplicationKey) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }

        $endpoint += "applicationKey=$($ApplicationKey)"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}