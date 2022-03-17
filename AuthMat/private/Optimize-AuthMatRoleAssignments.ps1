function Optimize-AuthMatRoleAssignments {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [Object]$RoleAssignments
    )

    # Add an id to sort by to detect roles with multiple identities assigned to it
    foreach($RoleAssignment in $RoleAssignments){
        $RoleAssignment | Add-Member -NotePropertyName "combID" -NotePropertyValue "$($RoleAssignment.scope) - $($RoleAssignment.roleDefinitionId)"
    }

    # Sort the roles
    $RoleAssignments = $RoleAssignments| Sort-Object -Property combID

    # Create a new array
    $NewRoleAssignments = @()
    $CurrentCombId = ""

    foreach($RoleAssignment in $RoleAssignments){
        if($CurrentCombId -eq $RoleAssignment.CombId){
            # Duplicate so get the last added value
            $NewRoleAssignment = $NewRoleAssignments[-1]
        }
        else {
            # Get the role info
            $role = Get-AuthMatRole -roleDefinitionId ($RoleAssignment.roleDefinitionId)

            # Get the scope info
            $scope = Get-AuthMatScopeType -scope $RoleAssignment.scope

            # New value
            $NewRoleAssignment = [PSCustomObject]@{
                roleDefinitionId = $RoleAssignment.roleDefinitionId
                roleName = $role.properties.roleName
                roleType = $role.properties.type
                principalId = @()
                scope = $RoleAssignment.scope
                scopetype = $scope.type
                scopeid = $scope.id
                combID = $RoleAssignment.CombId
            }

            $NewRoleAssignments += $NewRoleAssignment
        }
        $NewRoleAssignment.principalId += $RoleAssignment.principalId

        # Set the currentCombId
        $CurrentCombId = $RoleAssignment.CombId
    }

    # Sort by Type
    $sortedroles = @()
    $sortorder = @("Root","ManagementGroup","Subscription","ResourceGroup","Resource")

    foreach($sort in $sortorder){
        # Get all principals for this type
        $sortedroles += $NewRoleAssignments | Where-Object {$_.scopetype -eq "$sort"} | Sort-Object roleType, roleName
    }

    return $sortedroles
}