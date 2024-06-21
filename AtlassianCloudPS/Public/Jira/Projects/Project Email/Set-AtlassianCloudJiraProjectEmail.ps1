function Set-AtlassianCloudJiraProjectEmail{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$ProjectId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        emailAddress = $EmailAddress
    }

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$ProjectId/email" -Pat $Pat -Verbose:($Verbose.IsPresent)
}