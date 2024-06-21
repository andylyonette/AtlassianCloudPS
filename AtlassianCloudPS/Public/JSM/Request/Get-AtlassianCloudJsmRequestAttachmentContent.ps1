function Get-AtlassianCloudJsmRequestAttachmentContent{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AttachmentId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/attachment/$AttachmentId" -Pat $Pat -Verbose:($Verbose.IsPresent) 
}