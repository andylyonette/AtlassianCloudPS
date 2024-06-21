function New-AtlassianCloudJsmRequestAttachment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [bool]$Public,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Comment,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string[]]$TemporaryAttachmentIds,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        public = $Public
        temporaryAttachmentIds = @()
    }

    foreach ($temporaryAttachmentId in $TemporaryAttachmentIds) {
        $data.TemporaryAttachmentIds += $temporaryAttachmentId
    }

    if ($Comment) {
        $data += @{
            additionalComment = @{
                body = $Comment
            }
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/attachment" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}