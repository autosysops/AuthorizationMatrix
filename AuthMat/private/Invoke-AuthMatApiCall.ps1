function Invoke-AuthMatApiCall {

    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Uri,

        [parameter(mandatory = $false)]
        [ValidateSet('CONNECT', 'DELETE', 'GET', 'HEAD', 'OPTIONS', 'POST', 'PUT', 'TRACE')]
        [String]$Method = 'GET',

        [parameter(mandatory = $false)]
        [Object]$Headers,

        [parameter(mandatory = $false)]
        [Object]$Body,

        [parameter(mandatory = $false)]
        [Switch]$UseGraph
    )

    # Check for authorization and if not present add it
    if(-NOT $Headers.Authorization){
        # Check if Headers object exists if not create it
        if(-NOT $Headers){
            $Headers = @{}
        }

        if($UseGraph.IsPresent){
            # Check if the AccessTokenGraph is set
            if($script:AccessTokenGraph){
                # Add the bearer token to the Headers
                $Headers.Authorization = "Bearer $($script:AccessTokenGraph)"
            }
            else {
                throw "AccessTokenGraph is not set. Call Connect-AuthMatAccount first or provide an Authorization attribute in the Headers."
            }
        }
        else {
            # Check if the AccessToken is set
            if($script:AccessToken){
                # Add the bearer token to the Headers
                $Headers.Authorization = "Bearer $($script:AccessToken)"
            }
            else {
                throw "AccessToken is not set. Call Connect-AuthMatAccount first or provide an Authorization attribute in the Headers."
            }
        }
    }
    
    try {
        $response = Invoke-RestMethod -Method $Method -Uri $Uri -Body $Body -Headers $Headers
    }
    catch {
        # Check if there is a response
        if($_.Exception.Response){
            $Statuscode = $_.Exception.Response.StatusCode.Value__
        }
        else {
            $Statuscode = 404
        }
        $StatusMessage = $_.Exception.Message

        throw "$Statuscode - $StatusMessage"
    }

    # If it's an array it will put the values in value so only return the array else return the response
    if($response.value){
        return $response.value
    }
    else {
        return $response
    }
}