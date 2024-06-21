function New-AtlassianCloudJiraVersionRelatedWork{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data @{} -AtlassianOrgName $AtlassianOrgName -Endpoint "version/$Id/relatedwork" -Pat $Pat -Verbose:($Verbose.IsPresent)
}