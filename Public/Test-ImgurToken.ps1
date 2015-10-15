Function Test-ImgurToken{
[CmdletBinding()]
param($ClientID,$clientSecret,$authCode)
    #URL to use, and place to store credentials
        $tokenURL = 'https://api.imgur.com/oauth2/token'
       $configDir = "$Env:AppData\WindowsPowerShell\Modules\PSImgur\0.1\Config.ps1xml"
    $confusername = "$Env:AppData\WindowsPowerShell\Modules\PSImgur\0.1\Config_username.ps1xml"
     $ConfRefresh = "$Env:AppData\WindowsPowerShell\Modules\PSImgur\0.1\Config_refresh.ps1xml"
    
    #verify that the keys work
    try {$success = Get-ImgurAccount -ErrorAction Stop}
    catch {Write-warning "Token expired, trying to refresh"
           Invoke-RestMethod -Uri $tokenURL -Method Post `
			        -Body @{
                        refresh_token = $Imgur_refreshtoken;
                        client_id=$clientId; 
				        client_secret=$clientSecret; 
				        grant_type="refresh_token"; 
                    } -ContentType "application/x-www-form-urlencoded" -ErrorAction STOP | tee -Variable result
        
        Write-Debug 'go through the results of $result, looking for our token'
        if ($result.access_token){
            Write-Output "Updated Authorization Token"
            #result
            $global:imgur_accessToken = $result.access_token
            $global:imgur_refreshToken = $result.refresh_token
            $global:imgur_username = $result.account_username
        
            #store the token and the username, securely
            $password = ConvertTo-SecureString $imgur_accessToken -AsPlainText -Force
            $password | ConvertFrom-SecureString | Export-Clixml $configDir -Force

            $username = ConvertTo-SecureString $imgur_username -AsPlainText -Force
            $username | ConvertFrom-SecureString | Export-Clixml $Confusername -Force

            $refreshtkn = ConvertTo-SecureString $imgur_refreshToken -AsPlainText -Force
            $refreshtkn | ConvertFrom-SecureString | Export-Clixml $ConfRefresh -Force
            #End Update Tokens
        }
        else{
        Write-Warning "Couldn't update tokens, try Connect-ImgurAccount -Force"
        }

    #End Catch   
    }
    
    
    
  if ($success -ne $null){Write-Host -ForegroundColor Green "Token good"}   
#Eof   
}
