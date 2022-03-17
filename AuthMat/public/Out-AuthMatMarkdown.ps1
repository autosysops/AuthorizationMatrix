<#
    .SYNOPSIS
        TODO
    .DESCRIPTION
        TODO
    .PARAMETER AuthMatrix
        TODO
    .PARAMETER FilePath
        TODO
    .EXAMPLE
        TODO
#>
function Out-AuthMatMarkdown {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true, ValueFromPipeline = $true)]
        [Object]$AuthMatrix,

        [parameter(mandatory = $false)]
        [String]$FilePath = ".\output.md"
    )

    ConvertTo-AuthmatHTMLTable -AuthMatrix $AuthMatrix | Out-File -FilePath $FilePath
}