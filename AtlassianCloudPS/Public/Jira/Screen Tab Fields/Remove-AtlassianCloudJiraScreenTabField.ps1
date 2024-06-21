function Remove-AtlassianCloudJiraScreenTabField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$TabId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$ScreenId,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$FieldId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJiraMethod -Method Delete -Endpoint "screens/$($ScreenId)/tabs/$($TabId)/fields/$FieldId" -Experimental -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}