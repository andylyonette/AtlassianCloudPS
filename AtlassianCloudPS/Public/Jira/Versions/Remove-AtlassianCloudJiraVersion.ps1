function Remove-AtlassianCloudJiraVersion{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [psobject]$CustomFieldReplacementList,

        [Parameter(Mandatory = $false, Position=2)]
        [int]$MoveAffectedIssuesTo,

        [Parameter(Mandatory = $false, Position=3)]
        [int]$MoveFixIssuesTo,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}

    if ($CustomFieldReplacement) {
        $data += @{
            customFieldReplacementList = $CustomFieldReplacementList
        }
    }

    if ($MoveAffectedIssuesTo) {
        $data += @{
            moveAffectedIssuesTo = $MoveAffectedIssuesTo
        }
    }

    if ($MoveFixIssuesTo) {
        $data += @{
            moveFixIssuesTo = $MoveFixIssuesTo
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "version/$Id/removeAndSwap" -Pat $Pat -Verbose:($Verbose.IsPresent)
}