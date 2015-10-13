Function Get-ImgurAccount {
[CmdletBinding()]
param($accessToken=$Global:accessToken,$username)

try {$result = Invoke-RestMethod https://api.imgur.com/3/account/$username -Method Get -Headers @{"Authorization" = "Bearer $accessToken"}}
catch{throw "Check Credentials, error 400"}
write-debug 'ham'
    
    #convert epoch time to normal human time
    $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $created = $origin.AddSeconds($result.data.created)

   [pscustomobject]@{UserName=$result.data.url;Reputation=$result.data.reputation;Created=$created;Expiration=$result.data.pro_expiration}
}
