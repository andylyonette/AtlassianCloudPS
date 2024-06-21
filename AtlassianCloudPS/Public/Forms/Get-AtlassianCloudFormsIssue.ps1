function Get-AtlassianCloudFormsIssue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$CloudId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudFormsEntity -CloudId $CloudId -Endpoint "issue/$IssueKey/form" -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent) 
}