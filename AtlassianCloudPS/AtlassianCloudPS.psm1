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
        if ($assetsObject.objectKey -like "$($assetsSchemaKey)-*") {
            $assetsObjects += $assetsObject
        }
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

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jsmRoot = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $workspaceId = (Invoke-RestMethod -Method Get -Uri ($jsmRoot + "assets/workspace") -ContentType application/json -Headers $headers).values.workspaceId

    return $workspaceId
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

    } | ConvertTo-Json
    $jqlIssueRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($jiraEndpoint + "search?maxResults=1000") -ContentType application/json -Headers $headers

    $issues = @()
    foreach ($issue in $jqlIssueRequest.issues) {
        $issues += $issue
    }

    while ($jqlIssueRequest.startAt -lt $jqlIssueRequest.total) {
        $end = 2000 + $jqlIssueRequst.startAt
        if ($end -gt $jqlIssueRequst.total) {
            $end = $jqlIssueRequst.total
        }
        Write-Verbose "Getting issues [$(1000 + $jqlIssueRequst.startAt)-$end/$($jqlIssueRequst.total)]"

        $assetsObjectsRequest = Invoke-RestMethod -Method Post -Body $body -Uri ($jiraEndpoint + "search?maxResults=1000&startAt=$(1000 + $jqlIssueRequst.startAt)") -ContentType application/json -Headers $headers
        foreach ($issue in $jqlIssueRequest.issues) {
            $issues += $issue
        }
    }

    return $issues
}

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

function Get-AtlassianCloudJsmOrganisation{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
 
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

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $orgs = (Invoke-RestMethod -Method Get -Uri ($jsmEndpoint + 'organization') -ContentType application/json -Headers $headers).values

    if ($Name) {
        return $orgs | Where-Object {$_.name -eq $Name}
    } else {
        return $orgs
    }
}

function Get-AtlassianCloudJsmOrganisationUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Organisation,
 
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
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    $orgUsers = (Invoke-RestMethod -Method Get -Uri ($jsmEndpoint + "organization/$($Organisation.id)/user") -ContentType application/json -Headers $headers).values

    if ($AccountId -and $EmailAddress) {
        return $orgUsers | Where-Object {$_.accountId -eq $AccountId -and $_.emailAddress -eq $EmailAddress}
    } else {
        if ($AccountId) {
            return $orgUsers | Where-Object {$_.accountId -eq $AccountId}
        }

        if ($EmailAddress) {
            return $orgUsers | Where-Object {$_.emailAddress -eq $EmailAddress}
        } else {
            return $orgUsers
        }
    }
}

function Get-AtlassianCloudJsmRequest{
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

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    return Invoke-RestMethod -Method Get -Uri ($jsmEndpoint + "request/$IssueKey") -ContentType application/json -Headers $headers
}

function Get-AtlassianCloudJsmRequestType{
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

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"

    return Invoke-RestMethod -Method Get -Uri ($jsmEndpoint + "servicedesk/$ServiceDeskId/requesttype/$RequestTypeId") -ContentType application/json -Headers $headers
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
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"


    $body = @{
        displayName = $DisplayName
        email = $EmailAddress
    } | ConvertTo-Json
    
    return Invoke-RestMethod -Method Post -Body $body -Uri ($jsmEndpoint + "customer") -ContentType application/json -Headers $headers
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
        [string]$Pat
    )

    $headers = @{
        Authorization = "Basic $($Pat)"
    }

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"


    $body = @{
        body = $Comment
        public = $Public
    } | ConvertTo-Json
    
    return Invoke-RestMethod -Method Post -Body $body -Uri ($jsmEndpoint + "request/$IssueKey/comment") -ContentType application/json -Headers $headers
}

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

    $jsmEndpoint = "https://$AtlassianOrgName.atlassian.net/rest/servicedeskapi/"


    $body = @{
        emails = @($EmailAddress)
    } | ConvertTo-Json
    return (Invoke-RestMethod -Method Post -Body $body -Uri (($jsmEndpoint -replace 'servicedeskapi/','servicedesk/1/pages/') + "people/customers/pagination/$ProjectKey/invite") -ContentType application/json -Headers $headers)
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
    $object = Invoke-RestMethod -Method Put -Body $body -Uri ($assetsEndpoint + "object/$($Object.id)") -ContentType application/json -Headers $headers
    return Convert-AtlassianCloudAssetsApiObjectToPsObject -Schema $Schema -Object $object -WorkspaceId $WorkspaceId -Pat $Pat
}