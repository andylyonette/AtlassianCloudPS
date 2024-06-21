function New-AtlassianCloudJiraIssueLink{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$InwardIssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$OutwardIssueKey,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Comment,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        inwardIssue = @{
            key = $InwardIssueKey
        }
        outwardIssue = @{
            key = $OutwardIssueKey
        }
    }

    if ($Comment) {
        $data += @{
            description = $Description
        }
    }

    if ($SearcherKey) {
        $data += @{
            comment = @{
                body = @{
                    content = @(
                        content = @(
                            @{
                                text = $Comment
                                type = 'text'
                            }
                        )
                        type = 'paragraph'
                    )
                    type = 'doc'
                    vresion = 1
                }
            }
        }
    }

    return Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint 'issueLink' -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)
}