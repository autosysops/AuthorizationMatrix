function Optimize-AuthMatPrincipals {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [Object]$RoleAssignments
    )

    # Get more data for the principals
    $principals = $RoleAssignments.principalId | Sort-Object -Unique
    $principals = Expand-AuthMatPrincipals -Principals $principals

    # Filter the data
    $newprincipals = @()
    foreach($principal in $principals){
        # Get the principaltype
        $principaltype = Get-AuthMatPrincipalType -Principal $principal

        $newprincipal = [PSCustomObject]@{
            principalType = $principaltype
            id = $principal.id
            displayName = $principal.displayName
        }

        # Add to the
        $newprincipals += $newprincipal
    }

    # Sort by Type
    $sortedprincipals = @()
    $sortorder = @("Group","Managedidentity","Application","User")

    foreach($sort in $sortorder){
        # Get all principals for this type
        $sortedprincipals += $newprincipals | Where-Object {$_.principalType -eq "$sort"} | Sort-Object displayName
    }

    return $sortedprincipals
}