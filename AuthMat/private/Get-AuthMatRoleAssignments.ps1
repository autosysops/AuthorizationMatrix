function Get-AuthMatRoleAssignments {

    [CmdLetBinding()]
    param(
        [parameter(mandatory = $false)]
        [String[]]$Managementgroups,

        [parameter(mandatory = $false)]
        [String[]]$Subscriptions,

        [parameter(mandatory = $false)]
        [String[]]$Resourcegroups
    )

    # Create an array to store all assignments
    $RoleAssignments = @()
    $RoleAssignmentsIds = @()

    # Start building the uri
    $baseuriprefix = "https://management.azure.com/"
    $baseurisuffix = "/providers/Microsoft.Authorization/roleAssignments?api-version=2015-07-01"

    # Check if subscriptions are entered
    if($Subscriptions){
        $setSubscriptions = $false
    }
    else {
        $Subscriptions = @()
        $setSubscriptions = $true
    }

    # Check the management groups
    if($Managementgroups){
        $mgroups = (Get-AuthMatManagementGroups).name
        foreach($mgroup in $mgroups){
            if($mgroup -in $Managementgroups){
                # Get the subscriptions in the managementgroup
                if($setSubscriptions){
                    [Array]$subs = (Get-AuthMatSubscriptions -Managementgroup $mgroup).name
                    if($subs.count -gt 0){
                        $Subscriptions += $subs
                    }
                }

                # Get the roleassignments directly to the managementgroup
                $url = "$($baseuriprefix)providers/Microsoft.Management/managementGroups/$mgroup$baseurisuffix"

                $Responses = Invoke-AuthMatApiCall -Method GET -Uri $url

                # Loop through all responses
                foreach($response in $Responses){
                    # Test if the assignment is unique
                    if($response.id -notin $RoleAssignmentsIds){
                        # Store the responses in a hashtable
                        $RoleAssignments += $response.properties | Select-Object roleDefinitionId, principalId, scope
                        $RoleAssignmentsIds += $response.id
                    }
                }
            }
        }
    }

    foreach($subscription in $Subscriptions){
        # Create an array of url's to call
        $urls = @()

        # Get all resourcegroups in the subscription
        if($Resourcegroups){
            $rgroups = (Get-AuthMatResourceGroups -Subscription $subscription).name
            foreach($rgroup in $rgroups){
                if($rgroup -in $Resourcegroups){
                    $urls += "$($baseuriprefix)subscriptions/$subscription/resourceGroups/$rgroup$baseurisuffix"
                }
            }
        }
        else {
            $urls += "$($baseuriprefix)subscriptions/$subscription$baseurisuffix"
        }

        # Call all url's
        foreach($url in $urls){
            $Responses = Invoke-AuthMatApiCall -Method GET -Uri $url
            
            # Loop through all responses
            foreach($response in $Responses){
                # Test if the assignment is unique
                if($response.id -notin $RoleAssignmentsIds){
                    # Store the responses in a hashtable
                    $RoleAssignments += $response.properties | Select-Object roleDefinitionId, principalId, scope
                    $RoleAssignmentsIds += $response.id
                }
            }
        }
    }

    return $RoleAssignments
}