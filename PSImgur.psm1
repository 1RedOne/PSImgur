#Get public and private function definition files.
    $PublicFunction  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Exclude *tests* -ErrorAction SilentlyContinue )
    $PrivateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Exclude *tests* -ErrorAction SilentlyContinue )
    
#Dot source the files
    Foreach($import in @($PublicFunction + $PrivateFunction))
    {
        "importing $import"
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

# Here I might...
    # Read in or create an initial config file and variable
    # Export Public functions ($Public.BaseName) for WIP modules
    # Set variables visible to the module and its functions only

    #Initialize our variables.  I know, I know...

    $configDir = "$Env:AppData\WindowsPowerShell\Modules\PSImgur\0.1\Config.ps1xml"
 $confusername = "$Env:AppData\WindowsPowerShell\Modules\PSImgur\0.1\Config_username.ps1xml"
    if (Test-Path $configDir){
        Write-Verbose "Cached Credential found, importing"

        Try
        {
            #Import the config
            $password = Import-Clixml -Path $configDir -ErrorAction STOP | ConvertTo-SecureString
            $username = Import-Clixml -Path $confusername -ErrorAction STOP | ConvertTo-SecureString
        
         }
        catch {
        Write-Warning "Corrupt Password file found, rerun with -Force to fix this"
        }
   
           
    if ($password){Get-DecryptedValue -inputObj $password -name Imgur_accessToken}
    if ($username){Get-DecryptedValue -inputObj $username -name Imgur_username}
    }
    else{
    Write-Output "Run Connect-ImgurAccount to begin"
    }


Export-ModuleMember -Function $PublicFunction.Basename