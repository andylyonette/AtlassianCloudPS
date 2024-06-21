function Set-AtlassianCloudJiraIssueFieldContext{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ContextId,
  
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}

    if ($Name) {
        $data += @{
            name = $Name
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "field/$FieldId/context/$ContextId" -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).id
}