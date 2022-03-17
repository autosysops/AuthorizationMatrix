function Expand-AuthMatPrincipals {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [String[]]$Principals
    )

    # Retrieve more data for the principals
    $uri = "https://graph.microsoft.com/v1.0/directoryObjects/getByIds"
    $body = @{
        "ids" = $Principals
    }
    $headers = @{
        "Content-Type" = "application/json"
    }

    $newprincipals = Invoke-AuthMatApiCall -Method POST -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -UseGraph

    return $newprincipals
}