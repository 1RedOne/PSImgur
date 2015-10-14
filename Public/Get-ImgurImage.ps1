<#
.SYNOPSIS 
    View information about images you've uploaded on Imgur using this cmdlet
.Description
    After you've connected using Connect-ImgurAccount, you can use this cmdlet to review all of your images
.Example
 Get-ImgurImage 

 Title         : My first Image Upload
Link          : http://i.imgur.com/CpuHZtX.jpg
Bandwidth(kb) : 484
Created       : 1/1/1970 12:00:00 AM
views         : 2
Upvotes       : 
Downvotes     : 
Width         : 900
Height        : 598
Size          : 247657
description   : This image was uploaded using PowerShell!

Simply specify the name of an image to directly upload from your PC to Imgur
.LINK
https://github.com/1RedOne/PSImgur
#>
Function Get-ImgurImage {
[CmdletBinding()]
Param($accessToken=$Global:imgur_accessToken
     )
        #for testing headers
        write-verbose @{"Authorization" = "Bearer $accessToken"}  

        
    try {$result = Invoke-RestMethod https://api.imgur.com/3/account/$username/images -Method Get -Headers @{"Authorization" = "Bearer $accessToken"} -ErrorAction Stop}
   catch{write-debug "Check Credentials, error 400"}
         
        
    if ($result.status -eq 200){
    write-host -ForegroundColor Green "SUCCESS!"
    }

    #convert epoch time to normal human time
    $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        
    ForEach ($image in $result.data){
    $created = $origin.AddSeconds($result.datetime)
    [pscustomobject]@{Title=$image.title;
                Link=$image.link;
                'Bandwidth(kb)'=$image.bandwidth / 1kb -as [int];
                Created=$created;
                views=$image.views;
                Upvotes=$image.ups;
                Downvotes=$image.downs
                Width=$image.width;
                Height=$image.height;
                Size=$image.size;
                description=$image.description}
    }
    
    Write-Debug "Test results"
    
    
}
