function New-AtlassianCloudJsmRequestFeedback{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateRange(1,5)]
        [int]$Rating,

        [Parameter(Mandatory = $false, Position=2)]
        [bool]$Comment,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

       [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat

    )

    $data = @{
        rating = $Rating
        type  = 'cast'
    }

    if ($Comment) {
        $data += @{
            comment = @{
                body = $Comment
            }
        }
    }
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/feedback" -Body Delete -Pat $Pat -Verbose:($Verbose.IsPresent)
}