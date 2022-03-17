function Get-AuthMatMe {

    [cmdletbinding()]
    param()

    return Invoke-AuthMatApiCall -Uri "https://graph.microsoft.com/v1.0/me" -UseGraph
}