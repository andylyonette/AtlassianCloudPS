function Get-AtlassianCloudJiraAvatarById{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Type,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('xsmall','small','medium','large','xlarge')]
        [string]$Size,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('png','svg')]
        [string]$Format,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "universal_avatar/view/type/$Type/avatar/$Id"

    if ($Size -or $Format) {
        $endpoint += '?'

        if ($Size) {
            $endpoint += "size=$Size"
            if ($Format) {
                $endpoint += "&format=$Format"
            }
        } else {
            if ($Format) {
                $endpoint += "format=$Format"
            }
        }
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent)
}