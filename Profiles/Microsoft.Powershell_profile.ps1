$MaximumDisplayedPathLength = $pwd.Path.Split('\').Length

Function Format-Path
{
    $finalPath = $pwd
    $paths = $finalPath.Path.Split('\')
 
    if($paths.Length -gt $MaximumDisplayedPathLength){
        $start = $paths.Length - $MaximumDisplayedPathLength
        $finalPath = ".."
        for($i = $start; $i -le $paths.Length; $i++){
            $finalPath = $finalPath + "\" + $paths[$i]
        }
    }
 
    return $finalPath
}

Function Set-Prompt
{
    Param
    (
        [Parameter(Position=0)]
        [ValidateSet("Default","DC","GitHub")]
        $Choice
    )
    
    switch ($Choice)
    {
        "DC"
        {
            Function global:prompt 
            {
                #check and see if logon server is the same as the computername
                if ( $env:logonserver -ne "\\$env:computername" ) {
                    #strip off the \\
                    $label = ($env:logonserver).Substring(2)
                    $color = "Green"
                }
                else {
                    $label = "Not Connected"
                    $color = "gray"
                }
             
                Write-Host ("[$label]") -ForegroundColor $color -NoNewline
                Write (" PS " + (Get-Location) + "> ")
            }
        }

        "GitHub"
        {
            Write-Host ""
            Write-Host "Setting up GitHub Environment"

            $shellPath = "$env:LOCALAPPDATA\GitHub\shell.ps1"
            Write-Verbose "Resolving and executing GitHub shell from $shellPath"
            . (Resolve-Path $shellPath)

            Write-Host "Setting up Posh-Git"

            $profilePath = "$env:github_posh_git\profile.example.ps1"
            Write-Verbose "Resolving and executing GitHub profile from $profilePath"
            . (Resolve-Path $profilePath)
            
            Write-Host "Prompt depth will be set to $MaximumDisplayedPathLength. " -NoNewline
            Write-Host "Please change the 'MaximumDisplayedPathLength' environment variable if you want something different."

            Function global:prompt 
            {
                $realLASTEXITCODE = $LASTEXITCODE
                Write-Host(Format-Path) -nonewline
                Write-VcsStatus
                $global:LASTEXITCODE = $realLASTEXITCODE
	            return "> "
            }
            
            Write-Host ""
        }
        
        default
        {
            Function global:prompt
            {
                  $(if (test-path variable:/PSDebugContext) { '[DBG]: ' } else { '' }) + 
                  'PS ' + $(Get-Location) ` + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '> '
            }
        }
    }
}