function Set-AtlassianCloudJiraIssueCustomFieldOption{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ContextId,
  
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Value,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$OptionId,

        [Parameter(Mandatory = $false, Position=4)]
        [bool]$Disabled = $false,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        options = @(
            @{
                disabled = $Disabled.ToString().ToLower()
                value = $Value
                optionId = $OptionId
            }
        )
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "field/$FieldId/context/$ContextId/option" -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).id
}