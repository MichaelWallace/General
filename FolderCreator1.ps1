#This script uses a loop to create a folder with an incrementing naming convention. 
#This script then populates those folders with files and then populates those files with numbers ranging from 1.57
#This is a proof of concept script to create a large amount of folders and fill those folders with files and data. 



$data = 1..57
$j = 1
while ($j -le 10){
$foldername = "Testfolder_$j"
New-Item -ItemType directory -Name $foldername
$j++

for ($i=0; $i -le 10; $i++){
     $filename = "file_$i.txt"
     Set-Content -Path "$foldername\$filename" -Value $data
}

}