function Get-AuthMatRole {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $false)]
        [String]$roleDefinitionId
    )

    return Invoke-AuthMatApiCall -Uri "https://management.azure.com$($roleDefinitionId)?api-version=2015-07-01"
}