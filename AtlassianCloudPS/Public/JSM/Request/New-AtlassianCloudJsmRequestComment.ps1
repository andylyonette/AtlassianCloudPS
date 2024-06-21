function New-AtlassianCloudJsmRequestComment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Comment,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [bool]$Public,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        body = $Comment
        public = $Public
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/comment" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}