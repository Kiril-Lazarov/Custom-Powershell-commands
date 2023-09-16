'''
Commands:

adf - add to folder - Add the path to the current folder to the list of paths.
gt - go to folder (param: targetFolder) - Goes to the selected target folder if its path exists in the folders registry.
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


# Returns the terminal to `C:\` so that the absolute path to the selected target folder can be entered.
function backToRoot{
    param([int]$number)
    if ($number -eq 1){
        $back_command = '..'
    }
    else {
        $back_command = '../' * $number
    }
    
    Invoke-Expression "cd $back_command"
}


function GoToFolder {
    param([string]$targetFolder)
    if ($targetFolder -eq 'C:\'){
        $currFolderPath = [string](Get-Location)
        $currFolderLength = $currFolderPath.Split('\').Length
        backToRoot  $currFolderLength
    }
    else {
 
        $allPaths = @()
        foreach ($item in $folders){
       
            $lastItem = $item.Split('\')[-1]
       
            if ($targetFolder -eq $lastItem){
                $allPaths += $item               
        
            }
        }
        if ($allPaths.Length -eq 0){
            write-host "The folder $targetfolder is not in registry"
        }
        elseif ($allPaths.Length -eq 1){
            $pathToGo = $allPaths[0]
            $itemLength = $pathToGo.Split('\').Length
            backToRoot  $itemLength
            Invoke-Expression "cd '$pathToGo'"
            
        }
        else {
            $pathsCount = $allPaths.Length
            $numberList = @()
            for ($i = 1; $i -le $pathsCount; $i++) {
                $numberList += $i
            }
       
            Write-Host "There are $pathsCount folders with name '$targetFolder'."
            Write-Host "Choose one of them:"
            for ($i = 0; $i -lt $allPaths.Count; $i++) {
                Write-Host "$($i + 1): $($allPaths[$i])"
            }
            $choice = Read-Host "Enter a number of path"
            if ($numberList -notcontains $choice){
                Write-Host "Invalid choice"
            }
            else {
                backToRoot  $pathsCount
                $pathToGo = $allPaths[$choice-1]
                Invoke-Expression "cd '$pathToGo'"
            }

        } 
    }    
  
}
Set-Alias -Name gt -Value GoToFolder