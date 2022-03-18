<#
    .SYNOPSIS
        Get the Authorization Matrix data
    .DESCRIPTION
        Retrieve an object containing a list of the roles used in azure with the principals assigned to these roles. Also includes a list of all principles which are assigned permissions.
    .PARAMETER Managementgroups
        Filter on specific Managementgroups
    .PARAMETER Subscriptions
        Filter on specific Subscriptions
    .PARAMETER Resourcegroups
        Filter on specific Resourcegroups
    .EXAMPLE
        $matrix = Get-AuthMatMatrix
#>
function Get-AuthMatMatrix {

    [CmdLetBinding(DefaultParameterSetName = 'Tenant')]
    param(
        [parameter(mandatory = $true, ParameterSetName = 'ManagementGroup')]
        [parameter(mandatory = $false, ParameterSetName = 'Subscription')]
        [parameter(mandatory = $false, ParameterSetName = 'ResourceGroup')]
        [String[]]$Managementgroups,

        [parameter(mandatory = $true, ParameterSetName = 'Subscription')]
        [parameter(mandatory = $false, ParameterSetName = 'ResourceGroup')]
        [String[]]$Subscriptions,

        [parameter(mandatory = $true, ParameterSetName = 'ResourceGroup')]
        [String[]]$Resourcegroups
    )

    # Get the right parameters for the RoleAssignments
    if(-NOT $Managementgroups){
        if(-NOT $Subscriptions){
            $Managementgroups = (Get-AuthMatManagementGroups).name
        }
    }

    # Get the RoleAssignments
    $Params =@{}
    if($Resourcegroups){ $Params.ResourceGroups = $Resourcegroups }
    if($Subscriptions){ $Params.Subscriptions = $Subscriptions }
    if($Managementgroups){ $Params.Managementgroups = $Managementgroups }
    
    $roleAssignments = Get-AuthMatRoleAssignments @Params

    $roles = Optimize-AuthMatRoleAssignments -RoleAssignments $roleAssignments

    $principals = Optimize-AuthMatPrincipals -RoleAssignments $roleAssignments

    $matrix = [PSCustomObject]@{
        Roles = $roles
        Principals = $principals
    }

    return $matrix
}