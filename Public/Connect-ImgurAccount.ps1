﻿<#
.Synopsis
    Use this cmdlet to connect to a Imgur account for management via PowerShell
.DESCRIPTION
    With one cmdlet, you can connect to your Imgur account via the REST API.  After using this cmdlet, you can use any of the other *Imgur cmdlets to do things like upload an image or an album, etc (to come later)
.EXAMPLE
    Connect-ImgurAccount -ClientID [String] -ClientSecret [ClientSecret]

    Sign up at http://api.imgur.com/oauth2/addclient and make a new application ID, which is needed to query to Imgur API.  While you're there, specify a redirect URL, which should be the URL of any random site.  You'll receive a ClientID, ClientSecret which you must provide to this cmdlet.

    Upon running, a Internet Explorer com object window will be displayed, prompting you to login and authorize your Application ID (PowerShell, effectively) to interact with your Imgur account.  Click the appropriate boxes, and then close the browser window when you see the window get redirected.

    Behind the scenes, this cmdlet will retrieve an Access Token, convert it to an Authorization Token, and store it safely within your profile.  Other PSImgur API calls require this Authorization token, and it will be automatically provided when needed.
.EXAMPLE
    Connect-ImgurAccount -Force

    If you need to renew your API key (roughly once a month), then rerun the cmdlet with -Force
#>
Function Connect-ImgurAccount {
[CmdletBinding()]
param($ClientID,$clientSecret,[Switch]$force)

#load private functions
$PrivateFunctions = get-childitem "$((Get-Module PSImgur).ModuleBase)\Private" 

Foreach ($import in $PrivateFunctions)
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

    Write-Debug "test manually"
$configDir = "$Env:AppData\WindowsPowerShell\Modules\PSImgur\0.1\Config.ps1xml"
if (-not (Test-Path $configDir) -or $force){
        if ($force){"`$force detected"}
        New-item -Force -Path "$configDir" -ItemType File
        
        #response type must be code
        Get-ImgurAuthCode -ClientID $ClientID -ResponseType code

        Get-ImgurAuthToken -ClientID $ClientID -clientSecret $clientSecret -authCode $authCode -Debug

        #store the token
        $password = ConvertTo-SecureString $accessToken -AsPlainText -Force
        $password | ConvertFrom-SecureString | Export-Clixml $configDir -Force
    }
    else{
        try {
             $password = Import-Clixml -Path $configDir -ErrorAction STOP | ConvertTo-SecureString

             }
      catch {
        Write-Warning "Corrupt Password file found, rerun with -Force to fix this"
        BREAK
       }
        $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password)
        $result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
        $global:accessToken = $result 
        'Found cached Cred'
        continue
    }

}