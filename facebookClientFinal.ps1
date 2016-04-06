$username = "make your own" 
$password = "" 
$ie = New-Object -com InternetExplorer.Application 
$ie.visible=$true
$ie.navigate("www.facebook.com") 
while($ie.ReadyState -ne 4) {start-sleep -m 100} 
$ie.document.getElementById("email").value= "$username" 
$ie.document.getElementById("pass").value = "$password" 
do {sleep 1} until (-not ($ie.Busy))
$link = $ie.Document.getElementById("loginbutton")
$link.click()




