#This is a one line Ping sweep command utilizing the Test-Connection cmdlet. 
#The test-connection cmdlet allows pings to be set from a separate source address. 
#This can allow you to specify credentials to a 3rd party computer and that computer will ping on your behalf

1..224 | ForEach-Object {"127.0.0.$($_): $(Test-Connection -Count 1 -ComputerName 127.0.0.$($_) -Quiet)"}

