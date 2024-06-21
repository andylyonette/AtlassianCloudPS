function Get-AtlassianCloudJiraProjectType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$ProjectTypeKey,

        [Parameter(Mandatory = $false, Position=1)]
        [bool]$OnlyLicensed = $false,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

       [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($ProjectTypeKey) {
        $endpoint = "project/type/$ProjectTypeKey"
    } else {
        $endpoint = 'project/type'
    }

    if ($OnlyLicensed) {
        $endpoint += '/accessible'
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}