

<#.SYNOPSIS
    Shows when last your PC started up. 
  .DESCRIPTION
      This is a WMI wrapper function to get the time that your PC last started up. 
  .PARAMETER ComputerName
        The name of the Computer you want to run the command against. 
  .EXAMPLE
        Get-LastBootTime -ComputerName localhost

#>
param([Parameter(Mandatory=$true)][string]$ComputerName)

Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName | 
Select-Object -Property CSNAME,@{n="Last Booted";e={[Management.ManagementDateTimeConverter]::ToDateTime($_.LastBootUpTime)}}
