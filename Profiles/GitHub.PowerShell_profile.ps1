Write-Host "Setting environment for GitHub Powershell Profile"

$dir = (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
Push-Location $dir

. (Resolve-Path "$dir\Microsoft.Powershell_profile.ps1")

$MaximumDisplayedPathLength = 1

Set-Prompt GitHub

Pop-Location