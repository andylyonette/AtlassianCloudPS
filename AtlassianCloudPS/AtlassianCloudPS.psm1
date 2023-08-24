#region Internal functions
function Get-AtlassianCloudJsmEntity{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Pat,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [switch]$Experimental
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    if ($Experimental) {
        $headers += @{
            'X-ExperimentalApi' = 'opt-in'
        }
    }

    $jsmRoot = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $uri = $jsmRoot + $Endpoint

    Write-Verbose "[GET] $uri"
    $response = Invoke-RestMethod -Method Get -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)

    if ($response) {
        if ($response | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty' -and $_.Name -eq 'values'}) {
            # multiple entities returned
            if ($All) {
                # return all pages
                $entities = @()
                foreach ($entity in $response.values) {
                    $entities += $entity
                }

                if ($uri -contains '?') {
                    $uri += '&'
                } else {
                    $uri += '?'
                }
                
                while ($false -eq $response.isLast) {
                    $pageUri = $uri + 'start=' +(1 + $response.start + $response.size) + '&size=' + ($response.size)

                    Write-Verbose "[GET] $uri"
                    
                    $response = Invoke-RestMethod -Method Post -Body $body -Uri $pageUri -ContentType application/json -Headers $headers -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)
                    foreach ($entity in $response.values) {
                        $entities += $entity
                    }
                } 
            } else {
                $entities = $response.values
            }
            return $entities
        } else {
            # single entity
            return $response
        }
    }
}

function Invoke-AtlassianCloudJsmMethod{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory = $false, Position=2)]
        [psobject]$Data,

        [Parameter(Mandatory = $false, Position=3)]
        [ValidateSet('Delete','Post','Put')]
        [string]$Method = 'Post',

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Pat,

        [Parameter()]
        [switch]$Experimental
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    if ($Experimental) {
        $headers += @{
            'X-ExperimentalApi' = 'opt-in'
        }
    }

    $jsmRoot = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $uri = $jsmRoot + $Endpoint

    Write-Verbose "[POST] $uri"
    return Invoke-RestMethod -Method Post -Body ($Data | ConvertTo-Json -Depth 10) -Uri $uri -ContentType application/json -Headers $headers -Verbose:($Verbose.IsPresent)
}
#endregion Internal functions

#region General functions
function Convert-AtlassicanCloudApiKeyToPat{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress
    )

    $text = $EmailAddress + ':' + $ApiKey
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    return [Convert]::ToBase64String($bytes)
}

function Get-AtlassianCloudTenantInfo{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    return Invoke-RestMethod -Method Get -Uri "https://$orgName.atlassian.net/_edge/tenant_info" -ContentType application/json -Headers $headers
}
#endregion General functions

#region Assets
function Add-AtlassianCloudJsmOrganisationUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Organisation,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AccountId,

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

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $body = @{
        accountIds = @($AccountId)
    } | ConvertTo-Json
    
    return (Invoke-WebRequest -Method Post -Body $body -Uri ($jsmEndpoint + "organization/$($Organisation.id)/user") -ContentType application/json -Headers $headers)
}

function Get-AtlassianCloudAssetsObjectType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    Write-Verbose 'Getting schema objectTypes'
    $assetsObjectTypes = Invoke-RestMethod -Method Get -Uri ($assetsEndpoint + "objectschema/$($Schema.id)/objecttypes") -ContentType application/json -Headers $headers

    Write-Verbose 'Enumerating schema objectType attributes'
    $assetsObjectTypesWithAttributes = @()
    foreach ($assetsObjectType in $assetsObjectTypes) {
        $assetsObjectTypeWithAttributes = @{
            id = $assetsObjectType.id
            name = $assetsObjectType.name
            type = $assetsObjectType.type
            description = $assetsObjectType.description
            icon = $assetsObjectType.icon
            position = $assetsObjectType.position
            created = $assetsObjectType.created
            updated = $assetsObjectType.updated
            objectCount = $assetsObjectType.objectCount
            objectSchemaId = $assetsObjectType.objectSchemaId
            inherited = $assetsObjectType.inherited
            abstractObjectType = $assetsObjectType.abstractObjectType
            parentObjectTypeInherited = $assetsObjectType.parentObjectTypeInherited
            attributes  = Invoke-RestMethod -Method Get -Uri ($assetsEndpoint + "objecttype/$($assetsObjectType.id)/attributes") -ContentType application/json -Headers $headers
        }
        $assetsObjectTypesWithAttributes += $assetsObjectTypeWithAttributes
    }

    Write-Verbose "Enumerated objectType attributes"
    return $assetsObjectTypesWithAttributes
}

function Convert-AtlassianCloudAssetsApiObjectToPsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Object,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $assetsObjectTypes = Get-AtlassianCloudAssetsObjectType -Schema $Schema -WorkspaceId $WorkspaceId -Pat $Pat
    $assetsObjectType = $assetsObjectTypes | Where-Object {$_.id -eq $Object.objectType.id}

    $psAttributes = New-Object -TypeName psobject
    foreach ($attribute in $Object.attributes) {
        if ($attribute.objectAttributeValues.searchValue -gt 1) {
            $psAttributes | Add-Member -MemberType NoteProperty -Name ($assetsObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).name -Value $attribute.objectAttributeValues.searchValue
        } else {
            $psAttributes | Add-Member -MemberType NoteProperty -Name ($assetsObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).name -Value (New-Object System.Collections.Generic.List[string])
            $psAttributes."$(($assetsObjectType.attributes | Where-Object {$_.id -eq $attribute.objectTypeAttributeId}).name)".Add($attribute.objectAttributeValues.searchValue)
        }
    }

    foreach ($attribute in $assetsObjectType.attributes | Where-Object {($psAttributes | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'}).Name -notcontains $_.name}) {
        $psAttributes | Add-Member -MemberType NoteProperty -Name $attribute.name -Value (New-Object System.Collections.Generic.List[string])
    }
    
    $Object.attributes = $psAttributes

    return $Object
}

function Convert-AtlassianCloudAssetPsObjectToApiObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Attributes,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$ObjectTypeName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $assetsObjectTypes = Get-AtlassianCloudAssetsObjectType -Schema $Schema -WorkspaceId $WorkspaceId -Pat $Pat
    $assetsObjectType = $assetsObjectTypes | Where-Object {$_.name -eq $ObjectTypeName}

    $apiObject = @{
        objectTypeId = $assetsObjectType.id
        attributes = @(
            $(
                foreach ($attribute in ($Attributes | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'})) {
                    @{
                        objectTypeAttributeId = ($assetsObjectType.attributes | Where-Object {$_.name -eq $attribute.Name}).id
                        objectAttributeValues = @(
                            $(
                                foreach ($value in $Attributes."$($attribute.Name)") {
                                    @{
                                        value = $value
                                    }
                                }
                            )
                        )
                    }
                }
            )
        )
    }

    return $apiObject
}

function Find-AtlassianCloudJiraIssue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Query,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jiraEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    $body = @{
        jql = $Query
    } | ConvertTo-Json
    $jqlIssueRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($jiraEndpoint + "search?maxResults=1000") -ContentType application/json -Headers $headers

    $issues = @()
    foreach ($issue in $jqlIssueRequest.issues) {
        $issues += $issue
    }

    while (($jqlIssueRequest.startAt + $jqlIssueRequest.maxResults) -lt $jqlIssueRequest.total) {
        $end = 2000 + $jqlIssueRequst.startAt
        if ($end -gt $jqlIssueRequst.total) {
            $end = $jqlIssueRequst.total
        }
        Write-Verbose "Getting issues [$($jqlIssueRequest.maxResults + $jqlIssueRequst.startAt)-$end/$($jqlIssueRequst.total)]"

        $jqlIssueRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($jiraEndpoint + "search?maxResults=1000&startAt=$($jqlIssueRequest.maxResults + $jqlIssueRequst.startAt)") -ContentType application/json -Headers $headers
        foreach ($issue in $jqlIssueRequest.issues) {
            $issues += $issue
        }
    }

    return $issues
}

function Get-AtlassianCloudAssetsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
        
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AQL,
 
        [Parameter(Mandatory = $false, Position=2)]
        [switch]$IncludeAttributes,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    if ($Schema -and $AQL) {
        $qlQuery = "objectSchemaId in ($($Schema.id)) AND ($AQL)"
    } else {
        $qlQuery = "objectSchemaId in ($($Schema.id))"
    }

    Write-Verbose "Getting objects with $qlQuery"

    $body = @{
        qlQuery = $qlQuery
    } | ConvertTo-Json

    Write-Verbose $body
    $assetsObjectsRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($assetsEndpoint + "object/aql?maxResults=1000&includeAttributes=$($IncludeAttributes.ToString().ToLower())") -ContentType application/json -Headers $headers

    $assetsObjects = @()
    foreach ($assetsObject in $assetsObjectsRequest.values) {
        $assetsObjects += $assetsObject
    }

    while ($false -eq $assetsObjectsRequest.isLast) {
        Write-Verbose "Getting objects [$($assetsObjectsRequest.pageNumber)/$($assetsObjectsRequest.pageSize)]"

        $assetsObjectsRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($assetsEndpoint + "object/aql?maxResults=1000&includeAttributes=$($IncludeAttributes.ToString().ToLower())&startAt=$(1 + $assetsObjectsRequest.startAt + $assetsObjectsRequest.maxResults)") -ContentType application/json -Headers $headers
        foreach ($assetsObject in $assetsObjectsRequest.values) {
            $assetsObjects += $assetsObject
        }
    } 

    $assetsPsObjects = @()
    foreach ($assetsObject in $assetsObjects) {
        if ($assetsObject.attributes.Count -gt 0) {
            $assetsPsObject = Convert-AtlassianCloudAssetsApiObjectToPsObject -Schema $Schema -Object $assetsObject -WorkspaceId $WorkspaceId -Pat $Pat
            $assetsPsObjects += $assetsPsObject
        } else {
            $assetsPsObjects += $assetsObject
        }
    }

    return $assetsPsObjects
}

function Get-AtlassianCloudAssetsSchema{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemaKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    Write-Verbose 'Getting schemas'
    $assetsSchemas = (Invoke-RestMethod -Method Get -Uri ($assetsEndpoint + "objectschema/list") -ContentType application/json -Headers $headers).values

    if ($SchemaKey) {
        Write-Verbose 'Filtering schemas'
        return $assetsSchemas | Where-Object {$_.objectSchemaKey -eq $SchemaKey}
    } else {
        return $assetsSchemas
    }
}

function Get-AtlassianCloudAssetsWorkspaceId{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return (Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "assets/workspace" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)).workspaceId
}

function New-AtlassianCloudAssetsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ObjectTypeName,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Attributes,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    $apiObject = Convert-AtlassianCloudAssetPsObjectToApiObject -Schema $Schema -Attributes $Attributes -ObjectTypeName $ObjectTypeName -WorkspaceId $WorkspaceId -Pat $Pat
    $body = $apiObject | ConvertTo-Json -Depth 10
    $newObject = Invoke-RestMethod -Method Post -Body $body -Uri ($assetsEndpoint + "object/create") -ContentType application/json -Headers $headers
    
    $psObject = Get-AtlassianCloudAssetsObject -Schema $Schema -AQL "objectId = $($newObject.id)" -IncludeAttributes -WorkspaceId $WorkspaceId -Pat $Pat

    return $psObject
}

function Remove-AtlassianCloudAssetsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Object,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=2)]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    $request = Invoke-RestMethod -Method Delete -Uri ($assetsEndpoint + "object/$($Object.id)") -ContentType application/json -Headers $headers
    return $request
}

function Set-AtlassianCloudAssetsObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Object,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Schema,
 
        [Parameter(Mandatory, Position=2)]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $assetsEndpoint = "https://api.atlassian.com/jsm/assets/workspace/$WorkspaceId/v1/"

    $apiObject = Convert-AtlassianCloudAssetPsObjectToApiObject -Attributes $Object.attributes -ObjectTypeName $Object.objectType.name -Schema $Schema -WorkspaceId $WorkspaceId -Pat $Pat

    $body = $apiObject | ConvertTo-Json -Depth 10
    $updatedObject = Invoke-RestMethod -Method Put -Body $body -Uri ($assetsEndpoint + "object/$($Object.id)") -ContentType application/json -Headers $headers

    return Convert-AtlassianCloudAssetsApiObjectToPsObject -Schema $Schema -Object $updatedObject -WorkspaceId $WorkspaceId -Pat $Pat
}
#endregion Assets

#reion Forms

#endregion Forms

#region Jira
function Get-AtlassianCloudJiraIssue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jiraEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    return Invoke-RestMethod -Method Get -Uri ($jiraEndpoint + "issue/$IssueKey") -ContentType application/json -Headers $headers
}

function Get-AtlassianCloudJiraIssueTransition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jiraEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    return Invoke-RestMethod -Method Get -Uri ($jiraEndpoint + "issue/$IssueKey/transitions") -ContentType application/json -Headers $headers
}

function Invoke-AtlassianCloudJiraIssueTransition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Transition,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jiraEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/api/3/"

    $body = @{
        transition = {
            id = $Transition.id
        }
    } | ConvertTo-Json

    return Invoke-RestMethod -Method Post -Body $body -Uri ($jiraEndpoint + "issue/$IssueKey/transitions") -ContentType application/json -Headers $headers
}
#endregion Jira


#region JSM
#region JSM - Customer
function New-AtlassianCloudJsmCustomer{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$StrictConflictStatusCode
    )

    $data = @{
        displayName = $DisplayName
        email = $EmailAddress
    } 

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "customer?strictConflictStatusCode=$StrictConflictStatusCode" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent) 
}
#endregion JSM - Customer

#region JSM - Info
function Get-AtlassianCloudJsmInfo{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "info" -Pat $Pat -Verbose:($Verbose.IsPresent) 
}
#endregion JSM - Info

#region JSM - Knowledgebase
function Get-AtlassianCloudJsmKbArticle{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Query,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$ApprovalId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$Highlight,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "knowledgebase/article?query=$QUery&highlight=$Highlight" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}
#endregion JSM - Knowledgebase

#region JSM - Organisation
function Add-AtlassianCloudJsmOrganisationUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string[]]$AccountIds,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Usernames,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        accountIds = @()
        usernames = @()
    }

    foreach ($accountId in $AccountIds) {
        $data.accountIds += $accountId
    }

    foreach ($username in $Usernames) {
        $data.usernames += $username
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/user" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmOrganisationPropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/property/$PropertyKey" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmOrganisationUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory = $false, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AccountId,

        [Parameter(Mandatory = $false, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/user" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function New-AtlassianCloudJsmOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )
    
    $data = @{
        name = $Name
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Remove-AtlassianCloudJsmOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )


    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$Organisation" -Method Delete -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Remove-AtlassianCloudJsmOrganisationPropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/property/$PropertyKey" -Method Delete -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Set-AtlassianCloudJsmOrganisationPropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/property/$PropertyKey" -Method Put -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Remove-AtlassianCloudJsmOrganisationUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string[]]$AccountIds,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Usernames,
 
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        accountIds = @()
        usernames = @()
    }

    foreach ($accountId in $AccountIds) {
        $data.accountIds += $accountId
    }

    foreach ($username in $Usernames) {
        $data.usernames += $username
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "organization/$OrganisationId/user" -Data $data -Method Delete -Pat $Pat -Verbose:($Verbose.IsPresent) 
}
#endregion JSM - Organisation

#region JSM - Request
function Get-AtlassianCloudJsmApproval{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$IssueKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$ApprovalId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/approval/$ApprovalId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequest{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$IssueKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$SummaryFilter,
  
        [Parameter(Mandatory = $false, Position=2)]
        [string]$OrganisationId,
  
        [Parameter(Mandatory = $false, Position=3)]
        [string]$RequestTypeId,
  
        [Parameter(Mandatory = $false, Position=4)]
        [string]$ServiceDeskId,
  
        [Parameter(Mandatory = $false, Position=5)]
        [ValidateSet('OWNED_REQUESTS','PARTICIPATED_REQUESTS','ORGANIZATION','ALL_ORGANIZATIONS','APPROVER','ALL_REQUESTS')]
        [string[]]$RequestOwnership,
 
        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    $queryParameters = @()
    
    if ($SummaryFilter) {
        $queryParameters += "searchTerm=$SummaryFilter"
    }    

    if ($RequestOwnership) {
        foreach ($requsetOwnershipValue in $RequestOwnership) {
            $queryParameters += "requestOwnership=$requsetOwnershipValue"
        }
    }
    
    if ($OrganisationId) {
        $queryParameters += "organizationId=$OrganisationId"
    }
    
    if ($RequestTypeId) {
        $queryParameters += "requestTypeId=$RequestTypeId"
    }
    
    if ($ServiceDeskId) {
        $queryParameters += "serviceDeskId=$ServiceDeskId"
    }

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint ('request' + $(if ($IssueKey) {"/$IssueKey"}) + '?' + ($queryParameters -join '&')) -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestAttachment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/attachment" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestAttachmentContent{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AttachmentId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/attachment/$AttachmentId" -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestAttachmentThumbnail{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AttachmentId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/attachment/$AttachmentId/Thumbnail" -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestComment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$CommentId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/comment/$CommentId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestCommentAttachment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$CommentId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/comment/$CommentId/attachment" -Pat $Pat -Experimental -All:($-All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestParticipant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/participant" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestSubscriptionStatus{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/notification" -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestSla{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory = $false, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$SlaMetricId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/sla/$SlaMetricId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestStatus{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/status" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmRequestTransition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/transition" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent)
}

function Get-AtlassianCloudJsmRequestFeedback{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/feedback" -Pat $Pat -Experimental -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Invoke-AtlassianCloudJsmRequestApprovalDecision{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ApprovalId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateSet("Approve","Decline")]
        [string]$Decision,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        decision = "$($Decision.ToLower())"
    } | ConvertTo-Json

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/approval/$ApprovalId" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function Invoke-AtlassianCloudJsmRequestTransition{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory = $false, Position=1)]
        [string]$TransitionId,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Comment,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

         [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{}
    
    if ($TransitionId) {
        $data += @{
            id = $TransitionId
        }
    }

    if ($Comment) {
        $data += @{
            additionalComment = @{
                body = $Comment
            }
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/transition" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmRequest{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,

        [Parameter(Mandatory = $false, Position=3)]
        [psobject]$Fields,

        [Parameter(Mandatory = $false, Position=4)]
        [psobject]$Form,

        [Parameter(Mandatory = $false, Position=5)]
        [string]$RaiseOnBehalfOf,
        
        [Parameter(Mandatory = $false, Position=6)]
        [string]$RequestParticipants,

        [Parameter(Mandatory = $false, Position=7)]
        [string]$Channel,

        [Parameter(Mandatory, Position=8)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$AdfRequest
    )

    $data = @{
          isAdfRequest = $AdfRequest.IsPresent
          requestTypeId = $RequestTypeId
          serviceDeskId = $ServiceDeskId
    }

    if ($Fields) {
        $data += @{
            requestFieldValues = $Fields
        }
    }

    if ($Form) {
        $data += @{
            form = $Form
        }
    }

    if ($RaiseOnBehalfOf) {
        $data += @{
            raiseOnBehalfOf = $RaiseOnBehalfOf
        }
    }

    if ($RequestParticipants) {
        $data += @{
            requestParticipants = @()
        }
        foreach ($requestParticipant in $RequestParticipants) {
            $data.requestParticipants += $requestParticipant
        }
    }

    if ($Channel) {
        $data += @{
            channel = $Channel
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint 'request' -Data $data -Pat $Pat -Experimental:($Channel.Length -gt 0) -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmRequestAttachment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [bool]$Public,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Comment,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string[]]$TemporaryAttatchmentIds,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        Public = $Public
        TemporaryAttatchmentIds = @()
    }

    foreach ($temporaryAttatchmentId in $TemporaryAttatchmentIds) {
        $data.TemporaryAttatchmentIds += $temporaryAttatchmentId
    }

    if ($Comment) {
        $data += @{
            additionalComment = @{
                body = $Comment
            }
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/attachment" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmRequestComment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Comment,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [bool]$Public,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        body = $Comment
        public = $Public
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/comment" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmRequestFeedback{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateRange(1,5)]
        [int]$Rating,

        [Parameter(Mandatory = $false, Position=2)]
        [bool]$Comment,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

       [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat

    )

    $data = @{
        rating = $Rating
        type  = 'cast'
    }

    if ($Comment) {
        $data += @{
            comment = @{
                body = $Comment
            }
        }
    }
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/feedback" -Body Delete -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmRequestParticipant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$AccountIds,

        [Parameter(Mandatory = $false, Position=2)]
        [string[]]$Usernames,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

      [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        accountIds = @()
        usernames = @()
    }

    foreach ($accountId in $AccountIds) {
        $data.accountIds += $accountId
    }

    foreach ($username in $Usernames) {
        $data.usernames += $username
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/participant" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmRequestSubscription{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )


    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/notification" -Method Put -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function Remove-AtlassianCloudJsmRequestFeedback{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/feedback" -Method Delete -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function Remove-AtlassianCloudJsmRequestParticipant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueKey,
 
  
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,
        
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        accountIds = @()
        usernames = @()
    }

    foreach ($accountId in $AccountIds) {
        $data.accountIds += $accountId
    }

    foreach ($username in $Usernames) {
        $data.usernames += $username
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "request/$IssueKey/participant" -Method Delete -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}

#endregion JSM - Request

#region JSM - RequestType
function Get-AtlassianCloudJsmRequestType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Query,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$ServiceDeskIds,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "requesttype?searchQuery=$Query$(foreach ($serviceDeskId in $ServiceDeskIds) {"&serviceDeskId=$serviceDeskId"})" -Experimental -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

#endregion JSM - RequestType

#region JSM - ServiceDesk
function Add-AtlassianCloudJsmServiceDeskOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        organizationId = $OrganisationId
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/organization" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDesk{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskCustomer{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/customer" -Pat $Pat -Experimental -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskKbArticle{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Query,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$Highlight,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/knowledgebase/article?query=$QUery&highlight=$Highlight" -Experimental -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskQueue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$QueueId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$IncludeCount,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/queue/$QueueId?invludeCount=$IncludeCount" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$AccountId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/organization?accountId=$AccountId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskQueueIssue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$QueueId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/queue/$QueueId/issue" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskRequestType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [string]$RequestTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskRequestTypeField{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId/field" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskRequestTypeGroup{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttypegroup" -Pat $Pat -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function Get-AtlassianCloudJsmServiceDeskRequestTypePropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory = $false, Position=2)]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat,

        [Parameter()]
        [switch]$All
    )

    return Get-AtlassianCloudJsmEntity -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId/property/$PropertyKey" -Pat $Pat -Experimental -All:($All.IsPresent) -Verbose:($Verbose.IsPresent) 
}

function New-AtlassianCloudJsmServiceDeskCustomer{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string[]]$AccountIds,

        [Parameter(Mandatory = $false, Position=2)]
        [string[]]$Usernames,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        accountIds = @()
        usernames = @()
    }

    foreach ($accountId in $AccountIds) {
        $data.accountIds += $accountId
    }

    foreach ($username in $Usernames) {
        $data.usernames += $username
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/customer" -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmServiceDeskRequestType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$IssueTypeId,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=4)]
        [string]$HelpText,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        name = $Name
        ssueTypeId = $IssueTypeId
    }

    if ($Description) {
        $data += @{
            description = $Description
        }
    }

    if ($HelpText) {
        $data += @{
            helpText = $HelpText
        }
    }

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype" -Method Post -Data $data -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent)
}

function New-AtlassianCloudJsmServiceDeskTmporaryFile{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string[]]$FilePaths,

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

    $form = @{
        FileData = $file
    }
        
    Write-Verbose "[POST] $uri"
    return Invoke-RestMethod -Method Post -Form $form -Uri $uri -ContentType multipart/form-data -Headers $headers -Verbose:($Verbose.IsPresent)
}

function Remove-AtlassianCloudJsmServiceDeskOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganisationId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    $data = @{
        organizationId = $OrganisationId
    }
    
    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/organization" -Method Delete -Data $data -Pat $Pat -Verbose:($Verbose.IsPresent) 
}

function Remove-AtlassianCloudJsmServiceDeskRequestType{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId" -Method Delete -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent) 
}

function Remove-AtlassianCloudJsmServiceDeskRequestTypePropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId/property/$PropertyKey" -Method Delete -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent) 
}

function Set-AtlassianCloudJsmServiceDeskRequestTypePropertyKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestTypeId,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceDeskId,
 
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyKey,
 
        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$AtlassianOrgName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    return Invoke-AtlassianCloudJsmMethod -AtlassianOrgName $AtlassianOrgName -Endpoint "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId/property/$PropertyKey" -Method Put -Pat $Pat -Experimental -Verbose:($Verbose.IsPresent) 
}
#endregion JSM - ServiceDesk

#region JSM - Undocumented
function Send-AtlassianCloudJsmCustomerInvite{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

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

    $body = @{
        emails = @($EmailAddress)
    } | ConvertTo-Json

    return Invoke-RestMethod -Method Post -Body $body -Uri "https://$AtlassianOrgName.atlassian.net/rest/servicedesk/1/pages/people/customers/pagination/$ProjectKey/invite" -ContentType application/json -Headers $headers
}
#endregion JSM - Undocumented
#endregion JSM