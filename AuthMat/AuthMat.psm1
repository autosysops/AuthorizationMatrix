# USE THIS FILE FOR ADDITIONAL MODULE CODE.
# THIS FILE WILL NOT BE OVERWRITTEN WHEN NEW CONTENT IS PUBLISHED TO THIS MODULE

# Get function definition files.
$Public  = @( Get-ChildItem -Path (Join-Path $PSScriptRoot 'public') -Include *.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path (Join-Path $PSScriptRoot 'private') -Include *.ps1 -Recurse -ErrorAction SilentlyContinue )
$Init    = @( Get-ChildItem -Path (Join-Path $PSScriptRoot 'init') -Include *.ps1 -Recurse -ErrorAction SilentlyContinue )

# Dot source public & private function files
foreach ($import in @($Public + $Private)) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Import aliases
$Aliases = @()
foreach ($import in $Public) {
    $Aliases += Get-Alias -Definition $import.Basename -ErrorAction 'SilentlyContinue'
}

# Initialize module
foreach ($import in @($Init)) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failed to import $($import.fullname): $_"
    }
}

# Export public cmdlets and aliases
Export-ModuleMember -Function $Public.Basename
if ($Aliases.Count -gt 0) {
    Export-ModuleMember -Alias $Aliases.Name
}