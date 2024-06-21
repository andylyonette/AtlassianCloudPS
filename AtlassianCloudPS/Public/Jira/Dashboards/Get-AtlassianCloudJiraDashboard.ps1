function Get-AtlassianCloudJiraDashboard{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [int]$Id,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jiraRoot = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    $uri = $jiraRoot + "dashboard/$Id"

    Write-Verbose "[GET] $uri"
    $response = Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

    if ($response) {
            # multiple entities returned
        if ($All) {
            # return all pages
            $entities = @()
            foreach ($entity in $response.dashboards) {
                $entities += $entity
            }
            
            while ($response.next) {
                Write-Verbose "[GET] $($response.next)"
                $response = Invoke-RestMethod -Method Get -Uri $response.next -ContentType application/json -Headers $headers -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)
                foreach ($entity in $response.dashboards) {
                    $entities += $entity
                }
            } 
        } else {
            $entities = $response.dashboards
        }
        return $entities
    } else {
        return $response.dashboards
    }
}