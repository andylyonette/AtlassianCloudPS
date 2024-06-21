function Add-AtlassianCloudJiraDefaultScreenField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Post -Endpoint "screens/AddToDefault/$FieldId" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}