function Set-AtlassianCloudJiraProjectFeature{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$FfeatureKey,

        [Parameter(Mandatory, Position=2)]
        [ValidateSet('ENABLED','DISABLED','COMING_SOON')]
        [string]$State,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        state = $State
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectKey/features/$FeatureKey" -Pat $Pat -Verbose:($Verbose.IsPresent)
}