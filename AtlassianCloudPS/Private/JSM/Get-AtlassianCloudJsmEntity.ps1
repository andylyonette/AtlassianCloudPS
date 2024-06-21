function Get-AtlassianCloudJsmEntity{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory, Position=2)]
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

    $jsmRoot = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $uri = $jsmRoot + $Endpoint

    Write-Verbose "[GET] $uri"
    $response = Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

    if ($response) {
        if ($response | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty' -and $_.Name -eq 'values'}) {
            # multiple entities returned
            if ($All) {
                # return all pages
                $entities = @()
                foreach ($entity in $response.values) {
                    $entities += $entity
                }
                
                while ($false -eq $response.isLastPage) {
                    if ($uri -contains '?') {
                        $pageUri = $uri + '&'
                    } else {
                        $pageUri = $uri + '?'
                    }
                    
                    $pageUri += 'start=' +(1 + $response.start + $response.size) + '&size=' + ($response.size)

                    Write-Host "[GET] $pageUri"
                    
                    $response = Invoke-RestMethod -Method Get -Uri $pageUri -ContentType application/json -Headers $headers -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)
                    foreach ($entity in $response.values) {
                        $entities += $entity
                    }
                } 
            } else {
                $entities = $response.values
            }
            return $entities
        } else {
            # single entity
            return $response
        }
    }
}