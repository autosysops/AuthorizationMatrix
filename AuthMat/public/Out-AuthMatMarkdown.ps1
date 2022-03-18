<#
    .SYNOPSIS
        Create a markdown file containing the authorization matrix
    .DESCRIPTION
        Create a markdown file containing the authorization matrix
    .PARAMETER AuthMatrix
        The Authorization Matrix data object
    .PARAMETER FilePath
        The location where the file needs to be saved
    .EXAMPLE
        Get-AuthMatMatrix | Out-AuthMatMarkdown -FilePath ".\matrix.md"
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