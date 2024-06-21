function Get-AtlassianCloudJsmRequestCommentAttachment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$CommentId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/comment/$CommentId/attachment" -Pat $Pat -Experimental -All:($-All.IsPresent) -Verbose:($Verbose.IsPresent) 
}