function Get-AtlassianCloudJiraEntity{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$ResponseProperty,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Pat,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [switch]$Experimental
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    if ($Experimental) {
        $headers += @{
            'X-ExperimentalApi' = 'opt-in'
        }
    }

    $jiraRoot = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    $uri = $jiraRoot + $Endpoint

    Write-Verbose "[GET] $uri"
    $response = Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

    if ($response) {
        if ($response | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty' -and $_.Name -eq $ResponseProperty}) {
            # multiple entities returned
            if ($All) {
                # return all pages
                $entities = @()
                foreach ($entity in $response.$ResponseProperty) {
                    $entities += $entity
                }
                
                while ($false -eq $response.isLast) {
                    Write-Verbose "[GET] $($response.nextPage)"
                    $response = Invoke-RestMethod -Method Get -Uri $response.nextPage -ContentType application/json -Headers $headers -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)
                    foreach ($entity in $response.$ResponseProperty) {
                        $entities += $entity
                    }
                } 
            } else {
                $entities = $response.$ResponseProperty
            }
            return $entities
        } else {
            # single entity
            return $response
        }
    }
}