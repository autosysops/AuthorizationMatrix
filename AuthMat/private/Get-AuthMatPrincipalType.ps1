function Get-AuthMatPrincipalType {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [Object]$Principal
    )

    $principaltype = "Unknown"

    if($Principal."@odata.type" -eq "#microsoft.graph.servicePrincipal"){
        $principaltype = $Principal.servicePrincipalType
    }
    elseif($Principal."@odata.type" -eq "#microsoft.graph.user"){
        $principaltype = "User"
    }
    elseif($Principal."@odata.type" -eq "#microsoft.graph.group"){
        $principaltype = "Group"
    }

    return $principaltype
}