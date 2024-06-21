function Remove-AtlassianCloudJsmRequestFeedback{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/feedback" -Method Delete -Pat $Pat -Verbose:($Verbose.IsPresent)
}