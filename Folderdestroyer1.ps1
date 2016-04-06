#This destroys folders with the naming convention created from the Folder Creator Script

$j = 1
while ($j -le 10){
$foldername = "Testfolder_$j"
Remove-Item -Recurse -path ".\$foldername"
$j++

}