function Get-AtlassianCloudFormsIssueForm{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$FormId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$CloudId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        
        [Parameter()]
        [switch]$SimplifiedAnswers
    )

    return Get-AtlassianCloudFormsEntity -CloudId $CloudId -Endpoint "issue/$IssueKey/form/$FormId$(if ($SimplifiedAnswers) {"/format/answers"})" -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent) 
}