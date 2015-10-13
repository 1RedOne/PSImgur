#this function calls the authorize API, using the Show-oAuthWindow to show a, uh, window for the user to login to
Function Get-ImgurAuthCode{
param($ClientID,$ResponseType)

    $url = "https://api.imgur.com/oauth2/authorize?client_id=$clientID&response_type=$ResponseType"
    
    If($ClientID -eq $null){
        Write-warning "Must provide the `-ClientID of your Imgur App to display a login Window"
        break}

    Show-OAuthWindow -url $url

    #After this, there should be a variable called $uri, which has our code!!!!!!!!!!!
    #(?<=code=)(.*)(?=&)
    $regex = '(?<=code=)(.*)'
    $authCode  = ($uri | Select-string -pattern $regex).Matches[0].Value
    "new auth code $authCode"
    $global:authCode = $authCode
    Write-output "Received an authCode, $authcode"
}
#Next, get an access token by presenting the code