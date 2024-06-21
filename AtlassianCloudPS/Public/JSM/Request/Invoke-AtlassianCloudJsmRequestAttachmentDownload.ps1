function Invoke-AtlassianCloudJsmRequestAttachmentDownload{
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
        [string]$Path,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $uri = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/request/$IssueKey/attachment/$AttachmentId"

    Write-Verbose "[GET] $uri"
    return Invoke-RestMethod -Method Get -Uri $uri -OutFile $Path -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}