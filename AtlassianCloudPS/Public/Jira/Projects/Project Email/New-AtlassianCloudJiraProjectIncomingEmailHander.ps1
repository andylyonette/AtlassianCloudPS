function New-AtlassianCloudJiraProjectIncomingEmailHander{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }
    https://uattemp.atlassian.net/secure/admin/EditHandlerDetailsUsingParams.jspa

    serverId: 10000
    serviceName: ITIMUAT41: Accept comments from email
    handler: com.atlassian.studio.theme.jira:cloud-mail-handler
    delay: 1
    params: stripquotes=true,senderEmail=itimal41@uattemp.atlassian.net,bulk=ignore

    $uri = "https://$AtlassianOrgName.atlassian.net/secure/admin/EditHandlerDetailsUsingParams!default.jspa?decorator=dialog&inline=true&serverId=10000&serviceName=$Name&handler=com.atlassian.studio.theme.jira%3Acloud-mail-handler&delay=1&serviceId=null"
    Write-Verbose "[POST] $uri"
    return (Invoke-RestMethod -Method Post -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent))
}