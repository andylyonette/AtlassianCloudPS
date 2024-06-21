function New-AtlassianCloudJsmRequestType{
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
        [string]$IssueTypeId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=5)]
        [string]$HelpText,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
          name = $Name
          issueTypeId = $IssueTypeId
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

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype" -Data $data -Pat $Pat -Experimental:$true -Verbose:($Verbose.IsPresent)
}