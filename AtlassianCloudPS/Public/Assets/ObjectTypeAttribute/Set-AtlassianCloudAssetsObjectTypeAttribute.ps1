function Set-AtlassianCloudAssetsObjectTypeAttribute{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ObjectTypeId,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$AttributeId,

        [Parameter(Mandatory = $false, Position=2)]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=3)]
        [string]$Description,

        [Parameter(Mandatory = $false, Position=4)]
        [ValidateSet('Default','ObjectReference','User','Group','Status')]
        [string]$Type,

        [Parameter(Mandatory = $false, Position=5)]
        [ValidateSet('None','Text','Integer','Boolean','Double','Date','Time','DateTime','Url','Email','Textarea','Select','IP Address')]
        [string]$DefaultType = 'None',

        [Parameter(Mandatory = $false, Position=6)]
        [string]$ObjectTypeValue,

        [Parameter(Mandatory = $false, Position=7)]
        [string[]]$UserTypeGroupsFilter,

        [Parameter(Mandatory = $false, Position=8)]
        [string]$AdditionalValue,

        [Parameter(Mandatory = $false, Position=9)]
        [int]$MinimumCardinality,

        [Parameter(Mandatory = $false, Position=10)]
        [int]$MaximumCardinality,

        [Parameter(Mandatory = $false, Position=11)]
        [string]$Suffix,

        [Parameter(Mandatory = $false, Position=12)]
        [bool]$IncludeChildObjectTypes,

        [Parameter(Mandatory = $false, Position=13)]
        [bool]$Hidden,

        [Parameter(Mandatory = $false, Position=14)]
        [bool]$Unique,
        
        [Parameter(Mandatory = $false, Position=15)]
        [bool]$Summable,

        [Parameter(Mandatory = $false, Position=16)]
        [string]$RegexValidation,

        [Parameter(Mandatory = $false, Position=17)]
        [string]$QlQuery,

        [Parameter(Mandatory = $false, Position=18)]
        [string]$Options,

        [Parameter(Mandatory, Position=19)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory, Position=20)]
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

    if ($Type) {
        $data += @{
            type = $(
                switch ($type) {
                    'Default' { 0 }
                    'ObjectReference' { 1 }
                    'User' { 2 }
                    'Group' { 4 }
                    'Status' { 7 }
                }
            )
        }
    }

    if ($type -eq 'Default') {
        $data += @{
            defaultTypeId = $(
                switch ($DefaultType) {
                    'None' { -1 }
                    'Text' { 0 }
                    'Integer' { 1 }
                    'Boolean' { 2 }
                    'Double' { 3 }
                    'Date' { 4 }
                    'Time' { 5 }
                    'DateTime' { 6 }
                    'Url' { 7 }
                    'Email' { 8 }
                    'Textarea' { 9 }
                    'Select' { 10 }
                    'IP Address' { 11 }
                }
            )
        }
    }

    if ($ObjectTypeValue) {
        $data += @{
            typeValue = $ObjectTypeValue
        }
    }

    if ($UserTypeGroupsFilter) {
        $data += @{
            typeValueMulti = $UserTypeGroupsFilter
        }
    }

    if ($AdditionalValue) {
        $data += @{
            additionalValue = $AdditionalValue
        }
    }

    if ($MinimumCardinality) {
        $data += @{
            minimumCardinality = $MinimumCardinality
        }
    }

    if ($MaximumCardinality) {
        $data += @{
            maximumCardinality = $MaximumCardinality
        }
    }

    if ($Suffix) {
        $data += @{
            suffix = $Suffix
        }
    }

    if ($IncludeChildObjectTypes) {
        $data += @{
            includeChildObjectTypes = $IncludeChildObjectTypes
        }
    }

    if ($Hidden) {
        $data += @{
            hidden = $Hidden
        }
    }

    if ($Unique) {
        $data += @{
            uniqueAttribute = $Unique
        }
    }

    if ($Summable) {
        $data += @{
            summable = $Summable
        }
    }

    if ($RegexValidation) {
        $data += @{
            regexValidation = $RegexValidation
        }
    }

    if ($QlQuery) {
        $data += @{
            qlQuery = $QlQuery
        }
    }

    if ($Options) {
        $data += @{
            options = $Options
        }
    }

    Write-Host "$($data | ConvertTo-Json)"
    Invoke-AtlassianCloudAssetsMethod -Method Put -Data $data -Endpoint "objecttypeattribute/$ObjectTypeId/$AttributeId" -WorkspaceId $workspaceId -Pat $Pat -Verbose:($Verbose.IsPresent) 
}