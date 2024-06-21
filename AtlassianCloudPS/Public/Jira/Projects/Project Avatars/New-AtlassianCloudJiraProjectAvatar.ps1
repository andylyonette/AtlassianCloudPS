function New-AtlassianCloudJiraProjectAvatar{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
 
        [Parameter(Mandatory = $false, Position=2)]
        [int]$X,
 
        [Parameter(Mandatory = $false, Position=3)]
        [int]$Y,
 
        [Parameter(Mandatory = $false, Position=4)]
        [int]$Size,
 
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

    $uri = $jiraRoot + "project/$ProjectKey/avatar2?"

    if ($X) {
        if ($uri -like '*?') {
            $uri += "X=$X"
        } else {
            $uri += "&X=$X"
        }
    }
   
    if ($Y) {
        if ($uri -like '*?') {
            $uri += "Y=$Y"
        } else {
            $uri += "&Y=$Y"
        }
    }
    
    if ($Size) {
        if ($uri -like '*?') {
            $uri += "size=$Size"
        } else {
            $uri += "&size=$Size"
        }
    }
    
    Write-Verbose "[POST] $uri"

    $file = Get-Item -Path $Path -ErrorAction Stop

    $contentType = "image/$($file.Extension.ToUpper())"
    if ($contentType -like '*JPG') {
        $contentType = $contentType -replace 'JPG','JPEG'
    }

    return Invoke-RestMethod -Method Post -InFile $Path -Uri $uri -ContentType $contentType -Headers $headers -Verbose:($Verbose.IsPresent)
}