function New-AtlassianCloudJsmServiceDeskRequestType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueTypeId,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$HelpText,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        ssueTypeId = $IssueTypeId
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($HelpText) {
        $data += @{
            helpText = $HelpText
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype" -Method Post -Data $data -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent)
}