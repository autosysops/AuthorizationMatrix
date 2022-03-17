function Get-AuthMatManagementGroups {

    [cmdletbinding()]
    param()

    return Invoke-AuthMatApiCall -Uri "https://management.azure.com/providers/Microsoft.Management/managementGroups?api-version=2020-05-01"
}