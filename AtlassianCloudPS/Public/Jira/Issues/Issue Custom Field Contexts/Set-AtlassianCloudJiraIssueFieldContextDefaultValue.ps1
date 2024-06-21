function Set-AtlassianCloudJiraIssueFieldContextDefaultValue{
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
        [psobject]$Value,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateSet('datepicker','datetimepicker','option.single','option.multiple','option.cascading','single.user.select','multi.user.select','grouppicker.single','grouppicker.multiple','url','project','float','labels','textfield','textarea','readonly','version.multiple','version.single')]
        [string]$Type,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        defaultValues = @(
            @{
                contextId = $ContextId
                type = $Type            
            }
        )
    }

    $data.defaultValues[0] += $value

    return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "field/$FieldId/context/defaultValue" -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}