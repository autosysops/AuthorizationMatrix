<#
    .SYNOPSIS
        TODO
    .DESCRIPTION
        TODO
    .PARAMETER Token
        TODO
    .PARAMETER GraphToken
        TODO
    .EXAMPLE
        TODO
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
        $me = Get-AuthMatMe
        $me | Format-Table displayName, userPrincipalName, id
    }
    catch {
        $script:AccessToken = '';
        $script:AccessTokenGraph = '';
        throw "Can't retrieve logged in user with given Token. Error: $($_.Exception.Message)"
    }
}