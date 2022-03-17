function ConvertTo-AuthmatHTMLTable {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [Object]$AuthMatrix
    )

    $colors = @("#808080","#999999")
    $colorindex = 0
    $cellsize = 50

    $HTML = '<table border="1">'

    # Create the top header
    $HTML += '<tr><th style="background-color:'+$colors[0]+'" colspan="2" rowspan="2"><font color="black">Roles</font></th>'
    foreach($principaltype in ($AuthMatrix.Principals.principalType | Get-Unique)){
        $pcount = ($AuthMatrix.Principals | Where-Object {$_.principalType -eq $principaltype}).count
        if($pcount -gt 0){
            $HTML += '<th colspan="'+$pcount+'" style="background-color:'+$colors[$colorindex]+'"><font color="black">'+$principaltype+'</font></th>'
        }
        $colorindex++
        if($colorindex -ge $colors.count){ $colorindex = 0}
    }
    $HTML += '</tr><tr>'

    $colorindex = 0

    foreach($principal in $AuthMatrix.Principals){
        $HTML += '<th style="word-wrap: break-word; background-color:'+$colors[$colorindex]+'" width="'+$cellsize+'px"><font color="black">'+$principal.displayName+'</font></th>'
        $colorindex++
        if($colorindex -ge $colors.count){ $colorindex = 0}
    }

    $HTML += '</tr><tr>'

    # Rest of table
    $currentscope = ''
    $colorstable = @("#d9d9d9","#f2f2f2")
    $colorindex = 0
    $colorindexsub = 0

    foreach($role in $AuthMatrix.Roles){
        $HTML += '<tr>'
        # Check for the rolescope
        if($currentscope -ne $role.scopetype){
            $currentscope = $role.scopetype
            $scopecount = ($AuthMatrix.Roles | Where-Object {$_.scopetype -eq $currentscope}).count
            $HTML += '<td rowspan="'+$scopecount+'" style="word-wrap: break-word; background-color:'+$colors[$colorindex]+'" width="'+$cellsize+'px"><font color="black">'+$currentscope+'</font></td>'
        
            $colorindex++
            if($colorindex -ge $colors.count){ $colorindex = 0}
        }
        $HTML += '<td style="word-wrap: break-word; background-color:'+$colors[$colorindexsub]+'" width="'+$cellsize+'px"><font color="black">'+$role.roleName+'<br>('+$role.scopeid+')</font></td>'

        # Add the cell for every principal
        foreach($principal in $AuthMatrix.Principals){
            $cellvalue = ""
            if($principal.id -in $role.principalId){
                $cellvalue = "SET"
            }
            $HTML += '<td style="background-color:'+$colorstable[$colorindexsub]+'"><b><font color="black">'+$cellvalue+'</font></b></td>'
        }

        $colorindexsub++
        if($colorindexsub -ge $colors.count){ $colorindexsub = 0}

        $HTML += '</tr>'
    }

    $HTML += '</table>'
    return $HTML
}