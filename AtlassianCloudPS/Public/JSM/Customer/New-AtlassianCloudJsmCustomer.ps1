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