function New-AtlassianCloudJiraIssueCustomField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Description,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateSet('cmdb-object-cftype','cascadingselect','datepicker','datetime','float','grouppicker','importid','labels','multicheckboxes','multigrouppicker','multiselect','multiuserpicker','multiversion','project','radiobuttons','readonlyfield','select','textarea','textfield','url','userpicker','version')]
        [string]$Type,
 
        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('cmdb-object-searcher','cascadingselectsearcher','daterange','datetimerange','exactnumber','numberrange','grouppickersearcher','labelsearcher','multiselectsearcher','userpickergroupsearcher','vresionsearcher','projectsearcher','textsearcher','exacttextsearcher')]
        [string]$SearcherKey,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        type = $(
            if ($Type -eq 'cmdb-object-cftype') {
                "com.atlassian.jira.plugins.cmdb:$($Type)"
            } else {
                "com.atlassian.jira.plugin.system.customfieldtypes:$($Type)"
            }
        )
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($SearcherKey) {
        $data += @{
            searcherKey = $(
                if ($SearcherKey -eq 'cmdb-object-searcher') {
                    "com.atlassian.jira.plugins.cmdb:$($SearcherKey)"
                } else {
                    "com.atlassian.jira.plugin.system.customfieldtypes:$($SearcherKey)"
                }
            )
        }
    }

    return (Invoke-AtlassianCloudJiraMethod -Method Post -Data $data -Endpoint 'field' -Version 3 -AtlassianOrgName $AtlassianOrgName -Pat $Pat -Verbose:($Verbose.IsPresent)).id
}