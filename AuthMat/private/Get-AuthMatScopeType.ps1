function Get-AuthMatScopeType {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [String]$Scope
    )

    $ScopeType = "Unknown"

    # Split the scope up in different parts
    $scopeParts = $Scope -split "/"

    if($Scope -eq "/"){
        $ScopeType = "Root"
    }
    elseif($scopeParts.count -gt 5){
        if($scopeParts[5] -eq "providers"){
            $ScopeType = "Resource"
        }
    }
    elseif($scopeParts.count -eq 5){
        if($scopeParts[3] -eq "managementGroups"){
            $ScopeType = "ManagementGroup"
        }
        elseif($scopeParts[3] -eq "resourceGroups"){
            $ScopeType = "ResourceGroup"
        }
    }
    elseif($scopeParts.count -eq 3){
        if($scopeParts[1] -eq "subscriptions"){
            $ScopeType = "Subscription"
        }
    }

    return @{
        type = $ScopeType
        id = $scopeParts[-1]
    }
}