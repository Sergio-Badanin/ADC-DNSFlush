<#
    Script: Get-ADC-DNSFlush.ps1
    Author: Sergey Badanin
    Version: 1.0
    Creation Date: 2025-03-06
    Description: A script to retrieve a list of active computers from Active Directory and flush their DNS cache.
    License: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Function to create a working directory if it doesn’t exist
function Initialize-WorkingDirectory {
    $workingDir = "C:\ADC-DNSFlush"
    if (-not (Test-Path -Path $workingDir)) {
        New-Item -Path $workingDir -ItemType Directory | Out-Null
        Write-Host "Working directory created: $workingDir" -ForegroundColor Green
    }
    return $workingDir
}

# Function to create a log file
function Initialize-LogFile {
    param (
        [string]$workingDir
    )
    $logFile = "$workingDir\$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"
    Start-Transcript -Path $logFile -Append
    Write-Host "Log file created: $logFile" -ForegroundColor Green
}

# Function to create a list of active computers
function Get-ActiveComputers {
    param (
        [string]$workingDir
    )
    $computers = Get-ADComputer -Filter * -Property Name | Select-Object -ExpandProperty Name
    $activeComputers = @()

    foreach ($computer in $computers) {
        if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
            Write-Host "$computer is available" -ForegroundColor Green
            $activeComputers += $computer
        }
    }

    $activeComputers | Out-File -FilePath "$workingDir\ActiveComputers.txt"
    Write-Host "List of active computers saved to: $workingDir\ActiveComputers.txt" -ForegroundColor Green
}

# Function to flush DNS on active computers
function Clear-DNSCache {
    param (
        [string]$workingDir
    )
    $inputFile = "$workingDir\ActiveComputers.txt"
    if (-not (Test-Path -Path $inputFile)) {
        Write-Host "File with the list of active computers not found." -ForegroundColor Red
        return
    }

    $computers = Get-Content -Path $inputFile
    $successCount = 0
    $failCount = 0

    foreach ($computer in $computers) {
        try {
            Invoke-Command -ComputerName $computer -ScriptBlock { ipconfig /flushdns } -ErrorAction Stop
            Write-Host "DNS cache successfully flushed on: $computer" -ForegroundColor Green
            $successCount++
        } catch {
            Write-Host "Failed to flush DNS cache on: $computer" -ForegroundColor Red
            $failCount++
        }
    }

    Write-Host "Operation completed." -ForegroundColor Cyan
    Write-Host "Successful: $successCount, Failed: $failCount" -ForegroundColor Cyan
}

# Function to display a stylish centered menu
function Show-Menu {
    Clear-Host
    $menuWidth = 50
    $padding = [math]::Max(0, ($Host.UI.RawUI.WindowSize.Width - $menuWidth) / 2)
    $paddingSpaces = " " * [math]::Max(0, $padding)

    Write-Host ($paddingSpaces + "=" * $menuWidth) -ForegroundColor Cyan
    Write-Host ($paddingSpaces + "                ADC-DNSFlush                ") -ForegroundColor Cyan
    Write-Host ($paddingSpaces + "=" * $menuWidth) -ForegroundColor Cyan
    Write-Host ($paddingSpaces + "1. Generate list of active computers") -ForegroundColor Yellow
    Write-Host ($paddingSpaces + "2. Flush DNS on active computers") -ForegroundColor Yellow
    Write-Host ($paddingSpaces + "3. Generate list and flush DNS") -ForegroundColor Yellow
    Write-Host ($paddingSpaces + "4. Exit") -ForegroundColor Yellow
    Write-Host ($paddingSpaces + "=" * $menuWidth) -ForegroundColor Cyan
}

# Main script logic
$workingDir = Initialize-WorkingDirectory
Initialize-LogFile -workingDir $workingDir

while ($true) {
    Show-Menu
    $choice = Read-Host "Select an option (1-4)"
    switch ($choice) {
        1 {
            Get-ActiveComputers -workingDir $workingDir
            Pause
        }
        2 {
            Clear-DNSCache -workingDir $workingDir
            Pause
        }
        3 {
            Get-ActiveComputers -workingDir $workingDir
            Clear-DNSCache -workingDir $workingDir
            Pause
        }
        4 {
            Write-Host "Exiting script." -ForegroundColor Cyan
            Stop-Transcript
            Exit
        }
        default {
            Write-Host "Invalid choice. Please select an option from 1 to 4." -ForegroundColor Red
            Pause
        }
    }
}