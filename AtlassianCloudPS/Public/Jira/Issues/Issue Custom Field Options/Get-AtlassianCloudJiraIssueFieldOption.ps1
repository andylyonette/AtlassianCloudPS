function Get-AtlassianCloudJiraIssueFieldOption{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$FieldId,
 
        [Parameter(Mandatory, Position=1)]
        [string]$ContextId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $endpoint = "field/$($FieldId)/context/$($ContextId)/option"

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -ResponseProperty values -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}