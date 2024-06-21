function Set-AtlassianCloudJiraProjectRole{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,

        [Parameter(Mandatory = $false, Position=1)]
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

    if (!$Name -and !$Description) {
        Write-Erorr "Must supply at least one of Name and Description"
    } else {
        $data = @{}

        if ($Name) {
            $data += @{
                name = $Name
            }
        }
    
        if ($Description) {
            $data += @{
                description = $Description
            }
        }
    
        if ($Name -and $Description) {
            return Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "role" -Pat $Pat -Verbose:($Verbose.IsPresent)
        } else {
            return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -AtlassianOrgName $AtlassianOrgName -Endpoint "role" -Pat $Pat -Verbose:($Verbose.IsPresent)
        }
    }
}