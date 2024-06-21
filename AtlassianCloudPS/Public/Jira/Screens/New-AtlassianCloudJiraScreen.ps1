function New-AtlassianCloudJiraScreen{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint 'screens' -Experimental -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}