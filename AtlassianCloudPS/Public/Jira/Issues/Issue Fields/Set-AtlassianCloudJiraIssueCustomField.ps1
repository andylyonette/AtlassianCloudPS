function Set-AtlassianCloudJiraIssueCustomField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$Description,
  
        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('cascadingselectsearcher','daterange','datetimerange','exactnumber','numberrange','grouppickersearcher','labelsearcher','multiselectsearcher','userprickergroupsearcher','vresionsearcher','projectsearcher','textsearcher','exacttextsearcher')]
        [string]$SearcherKey,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

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

    if ($SearcherKey) {
        $data += @{
            searcherKey = $SearcherKey
        }
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Put -Data $data -Endpoint "field/$($Id)" -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).id
}