# This Script Automatically renames whatever files $filetype into $newfiletype
# this is useful to change .txt into whatever .xml.  
$filetype = ".xml"
$newfiletype = ".txt"
 dir "*$filetype" | Rename-item -path {$_.name} `
-NewName {$_.name -replace "$filetype", "$newfiletype"} 