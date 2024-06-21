function New-AtlassianCloudFormsTemplate{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Design,

        [Parameter(Mandatory = $false, Position=2)]
        [psobject]$Publish,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$CloudId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
        'X-ExperimentalApi' = 'opt-in'
    }

    $uri = "https://api.atlassian.com/jira/forms/cloud/$CloudId/project/$ProjectKey/form"

    $data = @{
        design = $Design
    }

    if ($Publish) {
        $data += @{
            publish = $Publish
        }
    }

    $body = ($data | ConvertTo-Json -Depth 10)
    Write-Verbose "[$POST] $uri"
    Write-Verbose "Body: $body"
    return Invoke-RestMethod -Method Post -Body $body -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

}