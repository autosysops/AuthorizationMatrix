<#
    .SYNOPSIS
        Connect for the services used by the Authorization Matrix
    .DESCRIPTION
        Connect for the services used by the Authorization Matrix
    .PARAMETER Token
        Azure AccessToken when using he az module this can be retrieved by using (Get-AzAccessToken).Token
    .PARAMETER GraphToken
        Azure Graph API AccessToken when using he az module this can be retrieved by using (Get-AzAccessToken -ResourceTypeName MSGraph).Token
    .EXAMPLE
        $Token = (Get-AzAccessToken).Token
        $GraphToken = (Get-AzAccessToken -ResourceTypeName MSGraph).Token
        Connect-AuthMatAccount -Token $Token -GraphToken $GraphToken
#>
function Connect-AuthMatAccount {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Token,

        [parameter(mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$GraphToken
    )

    # Add the token in the script context
    $script:AccessToken = $Token
    $script:AccessTokenGraph = $GraphToken

    # Get all subscriptions
    try{
        $subscriptions = Get-AuthMatSubscriptions
        $subscriptions | Format-Table state, displayName, subscriptionId, tenantid
    }
    catch {
        $script:AccessToken = '';
        $script:AccessTokenGraph = '';
        throw "Can't retrieve subscriptions with given Token. Error: $($_.Exception.Message)"
    }

    # Get the current loggedin user
    try{
        $domains = Get-AuthMatDomains
        $domains | Format-Table isDefault, id
    }
    catch {
        $script:AccessToken = '';
        $script:AccessTokenGraph = '';
        throw "Can't retrieve logged in user with given Token. Error: $($_.Exception.Message)"
    }
}