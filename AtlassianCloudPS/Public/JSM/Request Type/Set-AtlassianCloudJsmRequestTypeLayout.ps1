function Set-AtlassianCloudJsmRequestTypeLayout{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$Items,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $graphUri = "https://$AtlassianOrgName.atlassian.net/rest/gira/1/"

    $graphBody = @{
        query = '%%query%%'
        variables = @{
            projectId = "$($ProjectId)"
            extraDefinerId = $RequestTypeId
            fieldPropertyKeys = @()
            availableItemsPageSize = 30
            layoutType = 'REQUEST_FORM'
            activeItemsLayoutType = 'ISSUE_VIEW'
        }
    }

    $graphBodyString = $graphBody | ConvertTo-Json -Depth 20
    $graphBodyString = $graphBodyString.Replace('%%query%%','\n            query SwiftJsmCmpCustomerViewInitial($projectId: Long!, $extraDefinerId: Long!, $fieldPropertyKeys: [String!]!, $availableItemsPageSize: Int!, $requestOwnerPropertyKeys: [String!] = [], $layoutType: IssueLayoutType!, $activeItemsLayoutType: IssueLayoutType!) {\n                ...CMPJSMLayoutConfigurationFragment\n            }\n            \n\n\nfragment JiraIssueLayoutOwnerFragment on JiraIssueLayoutOwner {\n  __typename\n  ... on JiraIssueLayoutIssueTypeOwner {\n    id\n    name\n    description\n    avatarId\n    iconUrl\n  }\n  ... on JiraIssueLayoutRequestTypeOwner {\n    id\n    name\n    description\n    avatarId\n    iconUrl\n    instructions\n    properties(keys: $requestOwnerPropertyKeys)\n  }\n}\n\nfragment JiraIssueLayoutUsageInfo on JiraIssueLayoutUsageInfoConnection {\n  edges {\n    currentProject\n    node {\n      avatarId\n      projectId\n      projectKey\n      projectName\n      layoutOwners {\n        ... JiraIssueLayoutOwnerFragment\n      }\n    }\n  }    \n}\n\n\n\n  fragment JiraIssueLayoutActivePanelItemFragment on JiraIssueItemPanelItem {\n  __typename\n    panelItemId\n  }\n\n\n  \n  fragment JiraIssueLayoutActiveFieldItemFragment on JiraIssueItemFieldItem {\n    __typename\n    fieldItemId\n    containerPosition\n  }\n\n  fragment JiraIssueLayoutTabContainerFragment on JiraIssueItemTabContainer {\n      __typename\n      tabContainerId\n      name\n      items {\n        nodes {\n          ...JiraIssueLayoutActiveFieldItemFragment\n        }\n        totalCount\n      }\n  }\n\nfragment JiraIssueLayoutItemContainerFragment on JiraIssueItemContainer {\n  containerType\n  items {\n    nodes {\n      __typename\n      ... JiraIssueLayoutActiveFieldItemFragment,\n      ... JiraIssueLayoutActivePanelItemFragment,\n      ... JiraIssueLayoutTabContainerFragment,\n    }\n  }  \n}\n\n\n\nfragment PanelItemFragment on JiraIssueLayoutPanelItemConfiguration {\n  panelItemId\n  name\n  operations {\n      editable\n      removable\n      categoriesWhitelist\n      canAssociateInSettings\n      deletable\n  }\n}\n\n  \nfragment FieldItemOperationsFragment on JiraIssueLayoutFieldOperations {\n  editable\n  canModifyRequired\n  canModifyOptions\n  canModifyDefaultValue\n  canModifyPropertyConfiguration\n  removable\n  deletable\n  canAssociateInSettings\n  categoriesWhitelist\n}\n\n  \nfragment FieldItemProviderFragment on JiraIssueLayoutFieldProvider {\n  key\n  name\n}\n\n  \nfragment FieldItemBaseFragment on JiraIssueLayoutFieldItemConfiguration {\n  fieldItemId\n  key\n  name\n  type\n  custom\n  global\n  description\n  configuration\n  required\n  externalUuid\n  defaultValue\n  options {\n    ...FieldItemOptionsFragment\n  }\n  operations {\n    ...FieldItemOperationsFragment\n  }\n  provider {\n    ...FieldItemProviderFragment\n  }\n  availability {\n    isHiddenIn {\n      __typename\n      ... on JiraIssueLayoutFieldConfigurationHiddenInGlobal {\n        fieldConfigs {\n          id\n          configName\n        }\n      }\n      ... on JiraIssueLayoutFieldConfigurationHiddenInLayoutOwner {\n        layoutOwnerId\n        fieldConfigs {\n          id\n          configName\n        }\n      }\n    }\n    context {\n      layoutOwnerIds\n      id\n    }\n    displayConditions\n    isHiddenByAppAccessRules\n  }\n}\n\n  \nfragment FieldItemOptionsFragment on JiraIssueLayoutFieldOption {\n  value\n  id\n  externalUuid\n  parentId\n}\n\n  fragment FieldItemFragment on JiraIssueLayoutFieldItemConfiguration {\n    ...FieldItemBaseFragment\n    properties(keys: $fieldPropertyKeys)  \n  }\n\n\nfragment SystemAvailableLayoutItemsGroup on JiraIssueLayoutFieldPanelItemConfigurationResult {\n  items {\n      totalCount\n      pageInfo {\n        hasNextPage\n        endCursor\n      }  \n      edges {\n          node {\n              __typename\n              ...FieldItemFragment\n              ...PanelItemFragment\n          }\n      }\n  }\n}\nfragment CustomAvailableLayoutItemsGroup on JiraIssueLayoutFieldItemConfigurationResult {\n  items {\n      totalCount\n      pageInfo {\n        hasNextPage\n        endCursor\n      }  \n      edges {\n          node {\n              __typename\n              ...FieldItemFragment\n          }\n      }\n  }\n}\n\n\nfragment JiraIssueLayoutItemConfigurationFragment on JiraIssueLayoutItemConfigurationResult {\n  items {\n    nodes {\n      __typename\n      ...FieldItemFragment\n      ...PanelItemFragment\n    }\n  }\n}\n\n\nfragment ActiveLayoutConfigurationItemsFragment on JiraIssueLayoutConfiguration {\n  ... on JiraIssueLayoutConfigurationResult {\n    issueLayoutResult {\n      containers {\n        containerType\n        items {\n          nodes {\n            __typename\n            ... on JiraIssueItemFieldItem {\n              fieldItemId\n            }\n            ... on JiraIssueItemTabContainer {\n              items {\n                nodes {\n                  __typename\n                  ... on JiraIssueItemFieldItem {\n                    fieldItemId\n                  }\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}\n\nfragment CMPJSMLayoutConfigurationFragment on Query {\n  issueLayoutConfiguration(issueLayoutKey: {projectId: $projectId, extraDefinerId: $extraDefinerId}, type: $layoutType) {\n    __typename\n    ... on JiraIssueLayoutConfigurationResult {\n      issueLayoutResult {\n        __typename\n        id\n        name\n        usageInfo {\n           ...JiraIssueLayoutUsageInfo\n        }\n        containers {\n            ...JiraIssueLayoutItemContainerFragment\n        }\n      }\n      metadata {\n        __typename\n        configuration {\n            ...JiraIssueLayoutItemConfigurationFragment\n        }\n        availableItems {\n          restrictedFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          suggestedFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          systemAndAppFields(first: $availableItemsPageSize) {\n            ...SystemAvailableLayoutItemsGroup\n          }\n          textFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          labelsFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          peopleFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          dateFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          selectFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          numberFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          otherFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n          advancedFields(first: $availableItemsPageSize) {\n            ...CustomAvailableLayoutItemsGroup\n          }\n        }\n      }\n    }\n  }\n  activeLayoutConfigurationItems: issueLayoutConfiguration(issueLayoutKey: {projectId: $projectId, extraDefinerId: $extraDefinerId}, type: $activeItemsLayoutType) {\n    ...ActiveLayoutConfigurationItemsFragment\n  }\n}')
    Write-Verbose "[Post] $graphUri"
    Write-Verbose "Body: $graphBody"    
    $graphRequest = Invoke-RestMethod -Method Post -Body $graphBodyString -Uri $graphUri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

    $id = $graphRequest.data.issueLayoutConfiguration.issueLayoutResult.id

    $data = @{
        projectId = $graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.projectId
        extraDefinerId = $graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.id
        issueLayoutType = 'REQUEST_FORM'
        issueLayoutConfig = @{
            items = $Items
        }
        owners = @(
            @{
                type = 'REQUEST_TYPE'
                data = @{
                    avatarId = "$($graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.avatarId)"
                    iconUrl = "$($graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.iconUrl)"
                    description = "$($graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.description)"
                    id ="$($graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.id)"
                    instructions = "$($graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.instructions)"
                    name = "$($graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.name)"
                    properties = $graphRequest.data.issueLayoutConfiguration.issueLayoutResult.usageInfo.edges.node.layoutOwners.properties
                }
            }
        )
    }

    $uri = "https://$AtlassianOrgName.atlassian.net/rest/servicedesk/1/servicedesk/issueLayouts/validate"

    $body = ($data | ConvertTo-Json -Depth 10)
    Write-Verbose "[Post] $uri"
    Write-Verbose "Body: $body"
    $validate = Invoke-RestMethod -Method Post -Body $body -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
    $uri2 = "https://$AtlassianOrgName.atlassian.net/rest/internal/1.0/issueLayouts/$id"
    Write-Verbose "[Put] $uri2"
    Write-Verbose "Body: $body"
    Invoke-RestMethod -Method Put -Body $body -Uri $uri2 -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}