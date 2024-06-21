function New-AtlassianCloudJiraAvatar{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Type,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [int]$Size,
 
        [Parameter(Mandatory = $false, Position=3)]
        [int]$X,
 
        [Parameter(Mandatory = $false, Position=4)]
        [int]$Y,
 
        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
        'X-Atlassian-Token' = 'no-check'
    }

    $jiraRoot = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    $uri = $jiraRoot + "universal_avatar/type/$Type/owner/$EntityId?size=$Size"

    if ($X) {
        $uri += "&X=$X"
    }
   
    if ($Y) {
        $uri += "&Y=$Y"
    }
    
    Write-Verbose "[POST] $uri"

    $file = Get-Item -Path $Path -ErrorAction Stop

    $contentType = "image/$($file.Extension.ToUpper())"
    if ($contentType -like '*JPG') {
        $contentType = $contentType -replace 'JPG','JPEG'
    }

    return Invoke-RestMethod -Method Post -InFile $Path -Uri $uri -ContentType $contentType -Headers $headers -Verbose:($Verbose.IsPresent)
}