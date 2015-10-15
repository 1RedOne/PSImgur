For (;;){
    $files = dir c:\CheerPhotos\ -Recurse *.png,*.jpg
    ForEach ($thisfile in $files){
        if ($thisfile.Name -in (import-csv .\Status.csv){
            Write-output "already uploaded, skipping $($thisfile.Name)"
            }
            else{
            #File wasn't uploaded yet, let's upload
                #try this command and see if it errors.  If not, we'll have the filename and status, stored in $status
                try {$status = New-ImgurImage -filepath $thisfile.FullName -ErrorAction Stop | select FileName,Status}
                #if the above command errored, run this instead.  In this case, we'll make an object called status, with the file name and the word 'Failed' for status
               catch{$status = [pscustomobject]@{FileName=$thisFile.Name;Status="Failed"}}
                #whether it errored or not, track this file in the csv
             finally{$status | convertto-csv -NoTypeInformation | Export-Csv -Append .\Status.csv}

            }

    #EndofThisFile
    }

}