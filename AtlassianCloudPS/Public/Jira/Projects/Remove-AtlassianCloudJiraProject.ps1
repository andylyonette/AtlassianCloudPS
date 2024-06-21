function Remove-AtlassianCloudJiraProject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [bool]$EnableUndo = $true,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Delete -AtlassianOrgName $AtlassianOrgName -Endpoint "project/$($ProjectKey)?enableUndo=$($EnableUndo.ToString().ToLower())" -Pat $Pat -Verbose:($Verbose.IsPresent)
}