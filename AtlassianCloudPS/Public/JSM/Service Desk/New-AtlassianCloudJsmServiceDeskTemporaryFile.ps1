function New-AtlassianCloudJsmServiceDeskTemporaryFile{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
        'X-Atlassian-Token' = 'no-check'
        'X-ExperimentalApi' = 'opt-in'
    }

    $jsmRoot = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $uri = $jsmRoot + "servicedesk/$ServiceDeskId/attachTemporaryFile"

    $file = Get-Item -Path $Path -ErrorAction Stop

    $form = @{
        file = $file
    }
        
    Write-Verbose "[POST] $uri"
    return (Invoke-RestMethod -Method Post -Form $form -Uri $uri -ContentType multipart/form-data -Headers $headers -Verbose:($Verbose.IsPresent)).temporaryAttachments
}