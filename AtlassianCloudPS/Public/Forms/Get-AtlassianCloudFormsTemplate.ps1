function Get-AtlassianCloudFormsTemplate{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$FormId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$CloudId,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Pat
    )

    if ($FormId) {
        $endpoint = "project/$ProjectKey/form/$FormId"
    } else {
        $endpoint = "project/$ProjectKey/form"
    }
    return Get-AtlassianCloudFormsEntity -CloudId $CloudId -Endpoint $endpoint -Experimental -Pat $Pat -Verbose:($Verbose.IsPresent) 
}