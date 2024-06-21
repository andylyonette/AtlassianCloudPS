function Invoke-AtlassianCloudJiraIssueTransition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [int]$TransitionId,

        [Parameter(Mandatory = $false, Position=2)]
        [psobject]$Fields,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        transition = @{
            id = $TransitionId
        }
    }

    if ($Fields) {
        $data += @{
            fields = $Fields
        }
    }
    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint "issue/$($IssueKey)/transitions" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}