function Invoke-AtlassianCloudJsmRequestTransition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$TransitionId,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Comment,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

         [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}
    
    if ($TransitionId) {
        $data += @{
            id = $TransitionId
        }
    }

    if ($Comment) {
        $data += @{
            additionalComment = @{
                body = $Comment
            }
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/transition" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}