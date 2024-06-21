function Remove-AtlassianCloudJiraStatus{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )


    $endpoint = "statuses?id=$($Id -join '&id=')"

    return Invoke-AtlassianCloudJiraMethod -Method Delete -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}