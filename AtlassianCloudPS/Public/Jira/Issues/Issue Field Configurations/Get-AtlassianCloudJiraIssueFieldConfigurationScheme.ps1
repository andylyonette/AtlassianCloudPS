function Get-AtlassianCloudJiraIssueFieldConfigurationScheme{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string[]]$Id,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$ProjectId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    if ($ProjectId) {
        $endpoint = "fieldconfigurationscheme/project?projectId=$($ProjectId -join '&projectId=')"
        return (Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values  -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)).fieldconfigurationscheme
    } else {
        $endpoint = "fieldconfigurationscheme"

        if ($Id) {
            $endpoint += "?id=$($Id -join '&id=')"
        }

        return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values  -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
    }
}