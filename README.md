# PSImgur v0.Beta
A PowerShell Module for working with Imgur via the REST API

This module makes it easy to connect to your Imgur account. 
   
####Exposed Cmdlets

* Connect-ImgurAccount
* Get-ImgurAccount


####Planned cmdlets

Name  | Planned Version | Delivered?
------------- | ------------- | --- 
Connect/Get-ImgurAccount | v0.beta | YES!
? | v0.2
? | v0.2
? | v0.?

![alt tag](https://github.com/1RedOne/PSImgur/blob/master/Img/OAuthWindow.png)

### How to use

* Create a [project on Imgur](https://api.imgur.com/oauth2/addclient) 
* Clone this Repo
* Import the module
```PowerShell
Import-Module PSImgur
```
* Use Connect-ImgurAccount to authenticate, and retrieve an Access Token.  
```PowerShell
Connect-ImgurAccount -ClientID [your app id] -ClientSecret [your client secret]
>Returns $Global:AccessToken, automatically passed to all subsequnet cmdlets
```
* The accessToken is safely stored using Windows API storage, in the users own roaming app data.  Subsequent cmdlets are aware of this storage location and will retrieve the key for you.
* You can test your Credential using Get-ImgurAccount
```PowerShell
PS C:\git\PSImgur> Get-ImgurAccount -username FoxDeploy 

UserName  Reputation Created               Expiration
--------  ---------- -------               ----------
FoxDeploy          0 10/13/2015 1:34:40 PM      False
```
###Change log
v0.beta Connect-ImgurAccount and Get-ImgurAccount both working

    Use Connect-ImgurAccount to connect to your account, you must provide your client secret and client ID.  
    use Get-ImgurAccount to verify that you're able to see account data
