# PSImgur v0.1
A PowerShell Module for working with Imgur via the REST API

This module makes it easy to connect to your Imgur account. 
   
####Exposed Cmdlets

* Connect-ImgurAccount
* Get-ImgurAccount
* Get-ImgurImage
* New-ImgurImage

####Planned cmdlets or features

Name  | Planned Version | Delivered?
------------- | ------------- | --- 
Connect/Get-ImgurAccount | v0.beta | YES!
New-ImgurImage | v0.1 | YES!
Get-ImgurAlbum | v0.2 | ?
New-ImgurAlbum | v0.2 | ?
Remove-ImgurAccount | v0.3 | ?
Automatically update tokens | v0.2 | ?
? | v0.? | ?

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

```PowerShell
New-ImgurImage -filepath C:\temp\fox1.jpg -name "FoxDeploy" -title "My first Image Upload" -description "This image was uploaded using PowerShell!"
SUCCESS!

Title       : My first Image Upload
Width       : 900
Height      : 598
Size        : 247657
Created     : 10/14/2015 7:42:06 PM
URL         : http://i.imgur.com/CpuHZtX.jpg
description : This image was uploaded using PowerShell!
```
![alt tag](https://github.com/1RedOne/PSImgur/blob/master/Img/FirstUpload.png)

###Whats next?

* Get-ImgurAlbum - to see albums our token has access to
* New-ImgurAlbum - to make a new album
* Remove-ImgurAccount - to make it easy to remove credentials and readd them
* Multi account support - uh, sure, maybe we can do this too!
* Automatically update tokens | v0.2 | ?
* Find [useful looking API endpoints](http://api.imgur.com/endpoints) and write wrappers for using them, using Get-ImgurAccount as an example.  
Automate the creation of albums.  Automate the mirroring of image resources from other sites.  Automate everything!

####Known issues

Currently, we don't have a working refresh token process.  We're saving the refresh token, but not doing anything with it.  In a future verson, we should fix this.

###Change log
v0.1    New-ImgurImage upload works!
    In a first for me, finally figured out how to upload files using Invoke-WebRequest.  Awww yeessss!

v0.beta Connect-ImgurAccount and Get-ImgurAccount both working

    Use Connect-ImgurAccount to connect to your account, you must provide your client secret and client ID.  
    use Get-ImgurAccount to verify that you're able to see account data
