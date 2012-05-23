Add-Type -AssemblyName System.Drawing

$exifTakenIndex  = 36867

# Define function to return "Date Picture Taken" EXIF Tag value
function Get-DateTaken($path) {
    $bmp = New-Object System.Drawing.Bitmap $path

    if($bmp.PropertyIdList.Contains(36867)){
        
        $prop = $bmp.GetPropertyItem($exifTakenIndex)
        $date = [System.Text.Encoding]::ASCII.GetString($prop.Value)
        [DateTime]::Parse($date.Substring(0,4)+"/"+$date.Substring(5,2)+"/"+$date.Substring(8))
    
    } else {
        [DateTime]::MinValue    
    }

    $bmp.Dispose()
}

$defaultSource = ((Split-Path -parent $MyInvocation.MyCommand.Definition) + "\")
$defaultDestination = ($defaultSource + "Imported\")

function Import-Images{
[CmdletBinding()]
Param(
    [string]$SourceDir = $defaultSource,
    [string]$DestinationDir = $defaultDestination,
    [bool]$RemoveAfterImport = $true
)

    $fullDestinationDirPath = [System.IO.Path]::GetFullPath($DestinationDir)

    dir -r $SourceDir *.jpg | where { !$_.FullName.Contains($fullDestinationDirPath) } | foreach {

        $dt = Get-DateTaken($_.FullName)
        $fdp = [System.IO.Path]::Combine($fullDestinationDirPath, ($dt.Year.ToString("0000") + "-" + $dt.Month.ToString("00") + "-" + $dt.Day.ToString("00")))

        if(!(Test-Path $fdp)){
            mkdir $fdp
        }

        $destinationFilePath = ""
        $counter = 1;

        do {
            
            $n = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)

            if(($counter -ge 2)){
                $n = ($n + " (" + $counter + ")" )
            }

            $destinationFilePath = [System.IO.Path]::Combine($fdp, ($n + $_.Extension))
            $counter = $counter + 1;

        } while(Test-Path ($destinationFilePath))

        if($RemoveAfterImport){
            Move-Item $_.FullName $destinationFilePath
        } else{
            Copy-Item $_.FullName $destinationFilePath
        }
    }
}
Set-Alias ipimg Import-Images 
Export-ModuleMember -Function Import-Images -Alias *