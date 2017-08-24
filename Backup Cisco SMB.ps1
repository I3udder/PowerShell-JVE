# Install-Module Posh-SSH first time use required
# Cisco SMB command ip ssh password-auth must be entered in the comfiguration of the device. If the device doesn't support the command the device needs to be upgraded to a later version of the firmware.
# Minimal Powershell Version 3
# (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
# iex (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")

$Switches = Import-Csv sample.csv

ForEach ($Switch in $Switches) {

$time = get-date -format yyyyMMdd-HHmmss 

$password = convertto-securestring -String $Switch.pass -AsPlainText -force
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $Switch.user,$password

$session = New-SSHSession -ComputerName $Switch.ipaddress -Credential $credentials
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("copy run scp://cisco:cisco@172.16.50.101/"+ $Switch.hostname  +"-" + $time + ".conf`n")
#Cisco Catalyst Switches require 3 enters
#Start-Sleep -s 5
#$stream.Write("`n")
#Start-Sleep -s 5
#$stream.Write("`n")
#Start-Sleep -s 5
#$stream.Write("`n")
#Start-Sleep -s 30
Remove-SSHSession $session



}
