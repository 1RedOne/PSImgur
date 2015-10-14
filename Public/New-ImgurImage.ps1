<#
.SYNOPSIS 
    Upload an image to imgur using this one simple cmdlet
.Description
    After you've connected using Connect-ImgurAccount, you can use this cmdlet to push an image up to imgur
.PARAMETER filepath
    Required.  Specifies the filepath of the image you're uploading
.PARAMETER title
    Optional.  The title, as you'd like it to appear on imgur
.PARAMETER name
    Optional.  The name, as you'd like it to appear on imgur
.PARAMETER description
    Optional.  Specifies an optional description of an image.
.PARAMETER album
    Optional.  The **album ID** of an album to upload to.
.Example
 New-ImgurImage -filepath C:\temp\fox1.jpg -name "FoxDeploy" -title "My first Image Upload" -description "This image was uploaded using PowerShell!"
SUCCESS!

Title       : My first Image Upload
Width       : 900
Height      : 598
Size        : 247657
Created     : 10/14/2015 7:42:06 PM
URL         : http://i.imgur.com/CpuHZtX.jpg
description : This image was uploaded using PowerShell!

Simply specify the name of an image to directly upload from your PC to Imgur
.Example
New-ImgurAccount -filepath C:\temp\fox2.jpg

SUCCESS!


Title       : 
Width       : 900
Height      : 678
Size        : 156373
Created     : 10/14/2015 7:47:05 PM
URL         : http://i.imgur.com/jid8uHI.jpg
description : 

This shows how little info you need to push an image.  Just put in the file path and you're done!
.LINK
https://github.com/1RedOne/PSImgur
#>
Function New-ImgurImage {
[CmdletBinding()]
Param($accessToken=$Global:imgur_accessToken,
     [Parameter(Mandatory=$true)]$filepath,
     $album,$name,$title,$description
     )
        #for testing headers
        write-verbose @{"Authorization" = "Bearer $accessToken"}  

        #the image must be Base64 encoded
        $image = [convert]::ToBase64String((get-content $filepath -encoding byte))
        
        #for legacy sake, this didn't work
        #$image = (get-content $filepath -encoding byte)
        
        #imgur wants a hashtable of values, most are optional though, so we'll build a hashtable to send
        $body=@{image=$image}

        if ($album){
            $body.Add('album',$album)
                    }
        if ($name){
            $body.Add('name',$name)
                    }
        if ($title){
            $body.Add('title',$title)
                    }
        if ($description){
            $body.Add('description',$description)
                    }

    try {$result = Invoke-RestMethod -uri https://api.imgur.com/3/image.json `
            -Method Post -Headers @{"Authorization" = "Bearer $accessToken"} `
            -Body $body -UseBasicParsing -ErrorAction Stop}
   catch{write-debug "Check Credentials, error 400"}
  #finally{
        write-debug "test"
        #convert epoch time to normal human time
        #$origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        #$created = $origin.AddSeconds($result.data.created)
        #parse the result here
        #[pscustomobject]@{UserName=$result.data.url;Reputation=$result.data.reputation;Created=$created;Expiration=$result.data.pro_expiration}

   # }
    if ($result.status -eq 200){
    write-host -ForegroundColor Green "SUCCESS!"
    }

    $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $created = $origin.AddSeconds($result.data.datetime)
    
    [pscustomobject]@{Title=$result.data.title;
            Width=$result.data.width;
            Height=$result.data.height;
            Size=$result.data.size;
            Created=$created;
            URL=$result.data.link
            description=$result.data.description}

    Write-Debug "Test results"
    
    
}
