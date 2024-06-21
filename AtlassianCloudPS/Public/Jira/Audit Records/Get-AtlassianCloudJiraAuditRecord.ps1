function Get-AtlassianCloudJiraAuditRecord{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$Offset,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Limit,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Filter,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$From,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$To,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $endpoint = 'auditing/record?'

    if ($Offset) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }
        
        $endpoint += "offset=$Offset"
    }

    if ($Limit) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }
        
        $endpoint += "limit=$Limit"
    }

    if ($Filter) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }
        
        $endpoint += "filter=$Filter"
    }

    if ($From) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }
        
        $endpoint += "from=$From"
    }
    
    if ($To) {
        if ($endpoint -notlike '*?') {
            $endpoint += '&'
        }
        
        $endpoint += "to=$To"
    }

    return Get-AtlassianCloudJiraEntity -AtlassianOrgName $AtlassianOrgName -Endpoint $endpoint -Pat $Pat -Verbose:($Verbose.IsPresent)
}