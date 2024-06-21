function Get-AtlassianCloudJsmApproval{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$IssueKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$ApprovalId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/approval/$ApprovalId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}