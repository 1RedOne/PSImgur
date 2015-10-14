<#
.SYNOPSIS 
    Gets information about the currently logged in user
.Description
    After you've connected using Connect-ImgurAccount, you can use this cmdlet to get information about the currently logged in user
.PARAMETER username
    Required.  Specifies which username profile you'd like to look at
.PARAMETER accesstoken
    Optional.  Defaults to the current user imported with Connect-ImgurAccount.  If instead, you'd like to view a different user and have their access token, use this param.  
.SWITCH favorites
    Optional.  Specifies to return a list of user's favorite'd images
.Example
Get-RedditAccount

name               : 1RedOne
hide_from_robots   : False
gold_creddits      : 0
link_karma         : 2674
comment_karma      : 19080
over_18            : True
is_gold            : False
is_mod             : False
gold_expiration    : 
has_verified_email : True
inbox_count        : 2
Created Date       : 1/20/2010 6:44:21 PM
.LINK
https://github.com/1RedOne/PSReddit
#>
Function Get-ImgurAccount {
[CmdletBinding()]
Param($accessToken=$Global:imgur_accessToken,
                $username=$Global:imgur_username,
        [switch]$favorites)

if ($favorites){
    try {$result = Invoke-RestMethod https://api.imgur.com/3/account/$username/favorites -Method Get -Headers @{"Authorization" = "Bearer $accessToken"}}
    catch{throw "Check Credentials, error 400"}
    finally{
        #convert epoch time to normal human time
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        
       ForEach ($result in $result.data){
       $created = $origin.AddSeconds($result.data.created)
       [pscustomobject]@{UserName=$result.data.url;Reputation=$result.data.reputation;Created=$created;Expiration=$result.data.pro_expiration}
       }
}
    }
    else{
    try {$result = Invoke-RestMethod https://api.imgur.com/3/account/$username -Method Get -Headers @{"Authorization" = "Bearer $accessToken"}}
    catch{throw "Check Credentials, error 400"}
  finally{
        #convert epoch time to normal human time
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        $created = $origin.AddSeconds($result.data.created)

       [pscustomobject]@{UserName=$result.data.url;Reputation=$result.data.reputation;Created=$created;Expiration=$result.data.pro_expiration}
}
    }
    Write-Debug "Test results"
    
    
}
