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