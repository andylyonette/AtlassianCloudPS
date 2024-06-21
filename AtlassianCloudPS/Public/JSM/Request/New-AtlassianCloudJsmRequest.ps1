function New-AtlassianCloudJsmRequest{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,

        [Parameter(Mandatory = $false, Position=3)]
        [psobject]$Fields,

        [Parameter(Mandatory = $false, Position=4)]
        [psobject]$Form,

        [Parameter(Mandatory = $false, Position=5)]
        [string]$RaiseOnBehalfOf,
        
        [Parameter(Mandatory = $false, Position=6)]
        [string]$RequestParticipants,

        [Parameter(Mandatory = $false, Position=7)]
        [string]$Channel,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$AdfRequest
    )

    $data = @{
          isAdfRequest = $AdfRequest.IsPresent
          requestTypeId = $RequestTypeId
          serviceDeskId = $ServiceDeskId
    }

    if ($Fields) {
        $data += @{
            requestFieldValues = $Fields
        }
    }

    if ($Form) {
        $data += @{
            form = $Form
        }
    }

    if ($RaiseOnBehalfOf) {
        $data += @{
            raiseOnBehalfOf = $RaiseOnBehalfOf
        }
    }

    if ($RequestParticipants) {
        $data += @{
            requestParticipants = @()
        }
        foreach ($requestParticipant in $RequestParticipants) {
            $data.requestParticipants += $requestParticipant
        }
    }

    if ($Channel) {
        $data += @{
            channel = $Channel
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint 'request' -Data $data -Pat $Pat -Experimental:($Channel.Length -gt 0) -Verbose:($Verbose.IsPresent)
}