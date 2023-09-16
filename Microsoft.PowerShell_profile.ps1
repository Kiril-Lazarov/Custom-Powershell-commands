'''
Commands:

adf - add to folder - Add the path to the current folder to the list of paths.
'''

# The path to the file that contains the list of paths to the most frequently used folders. 
# The file is in .ps1 format to avoid user authorization issues.
$filePath = ""
Import-Module -Name $filePath
. $filePath
$folders  = $foldersPaths


function addFolder{
    $currPath = [string](Get-Location)
   
    $currFolder = $currPath.Split('\')[-1]
    if ($folders.Contains($currPath)){
        
        Write-Host "'$currFolder' is already in the registry"
    }
    else {
        $nulls = $folders.Add($currPath)
        $scriptText = @"
`$foldersPaths = [System.Collections.ArrayList]@(
            $(foreach ($item in $folders){
             "'$item'`n"
            })
            )
"@
    
    $scriptText | Set-Content -Path $filePath -Encoding UTF8
    Write-Host "'$currFolder' succesfully added to registry"
    }
}
Set-Alias -Name adf -Value addFolder