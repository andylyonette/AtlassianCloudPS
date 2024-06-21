function New-AtlassianCloudJiraWorkflowBulk{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [psobject]$Data,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$ValidateOnly
    )


    if ($ValidateOnly) {
        $endpoint = 'workflows/create/validation'

        $data = @{
            payload = $data
            validationOptions = @{
                levels = @(
                    'ERROR'
                    'WARNING'
                )
            }
        }
    } else {
        $endpoint = 'workflows/create'
    }
    return Invoke-AtlassianCloudJiraMethod -Data $data -Method Post -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
}