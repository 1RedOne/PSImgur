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
 Get-ImgurAccount -favorites 
                                                                                                                          

Title         : Phone flop
Link          : http://i.imgur.com/gsWiMw3h.gif
Bandwidth(mb) : 34820664
Created       : 10/14/2015 2:15:59 AM
views         : 597229
Upvotes       : 7522
Downvotes     : 114


Title         : This jerkface just pooped on a chihuahua at the petstore. She's not even sorry.
Link          : http://i.imgur.com/pQWtGJs.jpg
Bandwidth(mb) : 10226
Created       : 10/14/2015 12:26:43 AM
views         : 233445
Upvotes       : 3913
Downvotes     : 121

To see a listing of all of your favorites, specify the -Favorites Switch
.Example
Get-ImgurAccount

UserName  Reputation Created               Expiration
--------  ---------- -------               ----------
FoxDeploy          0 10/13/2015 1:34:40 PM      False

See various information about your account.
.LINK
https://github.com/1RedOne/PSImgur
#>
Function Get-ImgurAccount {
[CmdletBinding()]
Param($accessToken=$Global:imgur_accessToken,
                $username=$Global:imgur_username,
        [switch]$favorites,
        [switch]$uploads)
        write-verbose @{"Authorization" = "Bearer $accessToken"}
if ($favorites){
    try {$result = Invoke-RestMethod https://api.imgur.com/3/account/$username/favorites -Method Get -Headers @{"Authorization" = "Bearer $accessToken"}}
    catch{throw "Check Credentials, error 400";break}
    
        #convert epoch time to normal human time
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        
       ForEach ($result in $result.data){
       $created = $origin.AddSeconds($result.datetime)
       [pscustomobject]@{Title=$result.title;Link=$result.link;'Bandwidth(mb)'=$result.bandwidth / 1mb -as [int];Created=$created;views=$result.views;Upvotes=$result.ups;Downvotes=$result.downs}
       
    break
    }
    
}
    try {$result = Invoke-RestMethod https://api.imgur.com/3/account/$username -Method Get -Headers @{"Authorization" = "Bearer $accessToken"}}
    catch{throw "Check Credentials, error 400";break}
  
        #convert epoch time to normal human time
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        $created = $origin.AddSeconds($result.data.created)

       [pscustomobject]@{UserName=$result.data.url;Reputation=$result.data.reputation;Created=$created;Expiration=$result.data.pro_expiration}

   
    Write-Debug "Test results"
    
    
}
