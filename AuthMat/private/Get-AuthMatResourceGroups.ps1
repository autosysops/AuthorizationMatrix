function Get-AuthMatResourceGroups {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [String]$Subscription
    )

    return Invoke-AuthMatApiCall -Uri "https://management.azure.com/subscriptions/$Subscription/resourcegroups?api-version=2020-01-01"
}