function New-AtlassianCloudJiraProject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$LeadAccountId,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('PROJECT_LEAD','UNASSIGNED')]
        [string]$AssigneeType,
 
        [Parameter(Mandatory = $false, Position=4)]
        [int]$AvatarId,
 
        [Parameter(Mandatory = $false, Position=5)]
        [int]$CategoryId,
 
        [Parameter(Mandatory = $false, Position=6)]
        [string]$Description,
 
        [Parameter(Mandatory = $false, Position=7)]
        [int]$FieldConfigurationSchemeId,
 
        [Parameter(Mandatory = $false, Position=8)]
        [int]$IssueSecuritySchemeId,
 
        [Parameter(Mandatory = $false, Position=9)]
        [int]$IssueTypeSchemeId,
 
        [Parameter(Mandatory = $false, Position=10)]
        [int]$IssueTypeScreenSchemeId,
 
        [Parameter(Mandatory = $false, Position=11)]
        [int]$NotificationSchemeId,

        [Parameter(Mandatory = $false, Position=12)]
        [int]$PermissionSchemeId,
 
        [Parameter(Mandatory = $false, Position=13)]
        [ValidateSet('software','service_desk','business')]
        [string]$ProjectType,

        [Parameter(Mandatory = $false, Position=13)]
        [ValidateSet('com.pyxis.greenhopper.jira:gh-simplified-agility-kanban','com.pyxis.greenhopper.jira:gh-simplified-agility-scrum','com.pyxis.greenhopper.jira:gh-simplified-basic','com.pyxis.greenhopper.jira:gh-simplified-kanban-classic','com.pyxis.greenhopper.jira:gh-simplified-scrum-classic','com.pyxis.greenhopper.jira:gh-cross-team-template','com.atlassian.servicedesk:simplified-it-service-management','com.atlassian.servicedesk:simplified-general-service-desk','com.atlassian.servicedesk:simplified-general-service-desk-it','com.atlassian.servicedesk:simplified-general-service-desk-business','com.atlassian.servicedesk:simplified-internal-service-desk','com.atlassian.servicedesk:simplified-external-service-desk','com.atlassian.servicedesk:simplified-hr-service-desk','com.atlassian.servicedesk:simplified-facilities-service-desk','com.atlassian.servicedesk:simplified-legal-service-desk','com.atlassian.servicedesk:simplified-marketing-service-desk','com.atlassian.servicedesk:simplified-finance-service-desk','com.atlassian.servicedesk:simplified-analytics-service-desk','com.atlassian.servicedesk:simplified-design-service-desk','com.atlassian.servicedesk:simplified-sales-service-desk','com.atlassian.servicedesk:simplified-halp-service-desk','com.atlassian.servicedesk:simplified-blank-project-it','com.atlassian.servicedesk:simplified-blank-project-business','com.atlassian.servicedesk:next-gen-it-service-desk','com.atlassian.servicedesk:next-gen-hr-service-desk','com.atlassian.servicedesk:next-gen-legal-service-desk','com.atlassian.servicedesk:next-gen-marketing-service-desk','com.atlassian.servicedesk:next-gen-facilities-service-desk','com.atlassian.servicedesk:next-gen-general-service-desk','com.atlassian.servicedesk:next-gen-general-it-service-desk','com.atlassian.servicedesk:next-gen-general-business-service-desk','com.atlassian.servicedesk:next-gen-analytics-service-desk','com.atlassian.servicedesk:next-gen-finance-service-desk','com.atlassian.servicedesk:next-gen-design-service-desk','com.atlassian.servicedesk:next-gen-sales-service-desk','com.atlassian.jira-core-project-templates:jira-core-simplified-content-management','com.atlassian.jira-core-project-templates:jira-core-simplified-document-approval','com.atlassian.jira-core-project-templates:jira-core-simplified-lead-tracking','com.atlassian.jira-core-project-templates:jira-core-simplified-process-control','com.atlassian.jira-core-project-templates:jira-core-simplified-procurement','com.atlassian.jira-core-project-templates:jira-core-simplified-project-management','com.atlassian.jira-core-project-templates:jira-core-simplified-recruitment','com.atlassian.jira-core-project-templates:jira-core-simplified-task-tracking')]
        [string]$ProjectTemplateKey,

        [Parameter(Mandatory = $false, Position=14)]
        [string]$Url,
 
        [Parameter(Mandatory = $false, Position=15)]
        [int]$WorkflowSchemeId,
 
        [Parameter(Mandatory, Position=17)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=18)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        key = $ProjectKey
        name = $Name
        leadAccountId = $LeadAccountId
    }

    if ($AssigneeType) {
        $data += @{
            assigneeType = $AssigneeType
        }
    }

    if ($AvatarId) {
        $data += @{
            avatarId = $AvatarId
        }
    }

    if ($CategoryId) {
        $data += @{
            categoryId = $CategoryId
        }
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($FieldConfigurationSchemeId) {
        $data += @{
            fieldConfigurationScheme = $FieldConfigurationSchemeId
        }
    }

    if ($IssueSecuritySchemeId) {
        $data += @{
            issueSecurityScheme = $IssueSecuritySchemeId
        }
    }

    if ($IssueTypeSchemeId) {
        $data += @{
            issueTypeScheme = $IssueTypeSchemeId
        }
    }

    if ($IssueTypeScreenSchemeId) {
        $data += @{
            issueTypeScreenScheme = $IssueTypeScreenSchemeId
        }
    }

    if ($NotificationSchemeId) {
        $data += @{
            notificationScheme = $NotificationSchemeId
        }
    }

    if ($PermissionSchemeId) {
        $data += @{
            permissionScheme = $PermissionSchemeId
        }
    }

    if ($ProjectTemplateKey) {
        $data += @{
            projectTemplateKey = $ProjectTemplateKey
        }

        if ($ProjectTemplateKey -like 'com.atlassian.jira-core-project-templates:*') {
            $data += @{
                projectTypeKey = 'business'
            }
        }
    
        if ($ProjectTemplateKey -like 'com.atlassian.servicedesk:*') {
            $data += @{
                projectTypeKey = 'service_desk'
            }
        }
    
        if ($ProjectTemplateKey -like 'com.pyxis.greenhopper.jira:*') {
            $data += @{
                projectTypeKey = 'software'
            }
        }
    } else {
        if ($ProjectType) {
            $data += @{
                projectTypeKey = $ProjectType
            }        }
    }

    if ($Url) {
        $data += @{
            url = $Url
        }
    }

    if ($WorkflowSchemeId) {
        $data += @{
            workflowScheme = $WorkflowSchemeId
        }
    }

    Write-Host ($data | ConvertTo-Json)
    return Invoke-AtlassianCloudJiraMethod -Data $data -Method Post -AtlassianOrgName $AtlassianOrgName -Endpoint 'project' -Pat $Pat -Verbose:($Verbose.IsPresent)
}