function Get-AtlassianCloudJiraAvatarByType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Type,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateSet('xsmall','small','medium','large','xlarge')]
        [string]$Size,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateSet('png','svg')]
        [string]$Format,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = "universal_avatar/view/type/$Type"

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