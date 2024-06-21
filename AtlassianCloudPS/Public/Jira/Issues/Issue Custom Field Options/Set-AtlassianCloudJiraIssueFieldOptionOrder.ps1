function Set-AtlassianCloudJiraIssueCustomFieldOptionOrder{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ContextId,
  
        [Parameter(Mandatory, Position=2)]
        [ValidateSet('First','Last')]
        [string]$Position,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string[]]$OptionIds,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        customFieldOptionIds = $OptionIds
        position = $Position
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "field/$FieldId/context/$ContextId/option/move" -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).id
}