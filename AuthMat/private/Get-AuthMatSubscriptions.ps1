function Get-AuthMatSubscriptions {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $false)]
        [String]$Managementgroup
    )

    if($Managementgroup){
        return Invoke-AuthMatApiCall -Uri "https://management.azure.com/providers/Microsoft.Management/managementGroups/$Managementgroup/subscriptions?api-version=2020-05-01"
    }
    else {
        return Invoke-AuthMatApiCall -Uri "https://management.azure.com/subscriptions?api-version=2020-01-01"
    }
    
}