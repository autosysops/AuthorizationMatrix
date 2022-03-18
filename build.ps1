# Define Variables
$MajorMinorPatch        = '0.0.1'  
$moduleName             = 'AuthMat'
$projectRoot            = (Resolve-Path (git rev-parse --show-toplevel)).Path
$modulePath             = Join-Path $ProjectRoot $moduleName
$ModuleSettings = [pscustomobject]@{ 
    Description = "Create a authorization matrix from a azure tenant"
    CompanyName = "AutoSysOps"
    Author = "Leo Visser"
    Copyright = "(c) AutoSysOps. All rights reserved."
    GUID = "43265b9d-bb07-4f19-b50f-cec3002f40d4"
    LicenseUri = "https://github.com/autosysops/AuthorizationMatrix/blob/main/LICENSE"
}


$RootModuleFile = Get-ChildItem -Path $modulePath -Recurse -Include '*.psm1' | Select-Object -First 1
$OutputPath = Join-Path -Path $modulePath -ChildPath ('{0}.psd1' -f $ModuleName)
$PublicPath = Join-Path -Path $modulePath -ChildPath 'public'
$functions = (Get-ChildItem -Path $PublicPath -Recurse).basename

$ModuleManifestData = @{
    CompanyName          = $ModuleSettings.CompanyName
    Author               = $ModuleSettings.Author
    Description          = $ModuleSettings.Description
    GUID                 = $ModuleSettings.GUID
    LicenseUri           = $ModuleSettings.LicenseUri
    FunctionsToExport    = $functions
    AliasesToExport      = @()
    RootModule           = $RootModuleFile.Name
    Path                 = $OutputPath
    ModuleVersion        = $MajorMinorPatch
    Copyright            = $ModuleSettings.Copyright
    CmdletsToExport      = @()
    VariablesToExport    = @()
    CompatiblePSEditions = @('Desktop', 'Core')
    PowerShellVersion    = [version]'5.1.0'
}

New-ModuleManifest @ModuleManifestData