function Get-AtlassianCloudJiraProject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$ProjectKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('description','issueTypes','lead','projectKeys','issueTypeHierarchy')]
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

    if ($ProjectKey) {
        if ($Expand) {
            $endpoint = "project/$ProjectKey?$($Expand -join '&expand=')"
        } else {
            $endpoint = "project/$ProjectKey"
        }
    } else {
        if ($Expand) {
            $endpoint = "project/search?$($Expand -join '&expand=')"
        } else {
            $endpoint = 'project/search'
        }
    }
    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}