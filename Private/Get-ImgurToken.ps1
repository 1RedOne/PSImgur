Function Get-ImgurAuthToken{
[CmdletBinding()]
param($ClientID,$clientSecret,$authCode)
#params 
    $tokenURL = 'https://api.imgur.com/oauth2/token'
    #The money shot, this will have our token that we'll use
    try { 
        $result = Invoke-RestMethod $tokenURL -Method Post `
			-Body @{client_id=$clientId; 
				client_secret=$clientSecret; 
				grant_type="authorization_code"; 
				code=$authCode} `
			-ContentType "application/x-www-form-urlencoded" -ErrorAction STOP
     }
    catch{
    Write-Warning "Something didn't work"
    Write-debug "Test the -body params for the Rest command"
    }
    
    Write-Debug 'go through the results of $result, looking for our token'
    if ($result.access_token){
        Write-Output "Updated Authorization Token"
        $result
        $global:imgur_accessToken = $result.access_token
        $global:imgur_refreshToken = $result.refresh_token
        $global:imgur_username = $result.account_username
        
        }
    
}

<#refresh tokens, not implemented yet

$result = Invoke-RestMethod $tokenURL -Method Post `
			-Body @{
                refresh_token = $Imgur_refreshtoken;
                client_id=$clientId; 
				client_secret=$clientSecret; 
				grant_type="refresh_token"; 
            } -ContentType "application/x-www-form-urlencoded" -ErrorAction STOP

            #>