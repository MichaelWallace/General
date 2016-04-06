$username = "make your own" 
$password = "" 
$ie = New-Object -com InternetExplorer.Application 
$ie.visible=$true
$ie.navigate("www.reddit.com") 
while($ie.ReadyState -ne 4) {start-sleep -m 100} 
$ie.document.getElementById("user").value= "$username" 
$ie.document.getElementById("passwd").value = "$password" 
$ie.document.getElementById("login_login-main").submit()
start-sleep 2
#$ie.Document.body | Out-File -FilePath Put you path here