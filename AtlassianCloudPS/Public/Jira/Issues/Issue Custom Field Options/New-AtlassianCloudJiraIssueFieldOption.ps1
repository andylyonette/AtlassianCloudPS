function New-AtlassianCloudJiraIssueFieldOption{
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
 
        [Parameter(Mandatory = $false, Position=3)]
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
            }
        )
    }

    if ($OptionId) {
        $data.options[0] += @{
            optionId = $OptionId
        }
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint "field/$FieldId/context/$ContextId/option" -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).options
}