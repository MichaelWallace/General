$username = "make your own" 
$password = "" 
$ie = New-Object -com InternetExplorer.Application 
$ie.visible=$true
$ie.navigate("https://accounts.google.com/ServiceLogin?service=mail&continue=https://mail.google.com/mail/#identifier") 
while($ie.ReadyState -ne 4) {start-sleep -m 100} 
$ie.document.getElementById("Email").value= "$username" 
$ie.document.getElementById("gaia_loginform").submit()
start-sleep 3
$ie.document.getElementById("Passwd").value = "$password" 
$ie.document.getElementById("gaia_loginform").submit()

do {sleep 1} until (-not ($ie.Busy)) 
#$ie.Document.body | Out-File -FilePath Put you path here