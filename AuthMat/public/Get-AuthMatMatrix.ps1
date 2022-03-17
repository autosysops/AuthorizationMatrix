<#
    .SYNOPSIS
        TODO
    .DESCRIPTION
        TODO
    .PARAMETER Managementgroups
        TODO
    .PARAMETER Subscriptions
        TODO
    .PARAMETER Resourcegroups
        TODO
    .EXAMPLE
        TODO
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