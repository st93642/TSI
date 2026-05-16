#*****************************************************************************#
#                                                                             #
#  test_main.ps1                                          TTTTTTTT SSSSSSS II #
#                                                            TT    SS      II #
#  By: st93642@students.tsi.lv                               TT    SSSSSSS II #
#                                                            TT         SS II #
#  Created: May 16 2026 15:04 st93642                        TT    SSSSSSS II #
#  Updated: May 16 2026 15:04 st93642                                         #
#                                                                             #
#   Transport and Telecommunication Institute - Riga, Latvia                  #
#                       https://tsi.lv                                        #
#*****************************************************************************#

$PROGRAM = Join-Path $PSScriptRoot "main.exe"
$DATA_FILE = Join-Path $PSScriptRoot "shops.txt"

Write-Host "=== Test Script for LAB2_2 (Task 2: Shop Telephone by Address) ==="
Write-Host ""

if (-not (Test-Path $PROGRAM)) {
    Write-Host "main.exe not found. Build the program first."
    exit 1
}

$pass = 0
$fail = 0

function Reset-DataFile {
    if (Test-Path $script:DATA_FILE) {
        Remove-Item $script:DATA_FILE -Force
    }
}

function Invoke-Program {
    param([string]$InputData)

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $script:PROGRAM
    $pinfo.WorkingDirectory = $PSScriptRoot
    $pinfo.RedirectStandardInput = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.RedirectStandardError = $true
    $pinfo.UseShellExecute = $false

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $pinfo
    $process.Start() | Out-Null
    $process.StandardInput.Write($InputData + "`n")
    $process.StandardInput.Close()

    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()

    $process.WaitForExit()
    return $stdout + $stderr
}

function Test-OutputContainsAll {
    param(
        [string]$Output,
        [string[]]$ExpectedParts
    )

    foreach ($part in $ExpectedParts) {
        if ($Output -notmatch [regex]::Escape($part)) {
            return $false
        }
    }
    return $true
}

function Run-Test {
    param(
        [string]$Name,
        [string]$InputData,
        [string[]]$ExpectedParts,
        [switch]$ResetFile
    )

    if ($ResetFile) {
        Reset-DataFile
    }

    Write-Host "Test: $Name"
    $output = Invoke-Program $InputData
    Write-Host $output.Trim()

    if (Test-OutputContainsAll -Output $output -ExpectedParts $ExpectedParts) {
        Write-Host "PASS"
        $script:pass++
    }
    else {
        Write-Host "FAIL"
        Write-Host "Expected output to contain:"
        foreach ($part in $ExpectedParts) {
            Write-Host "  $part"
        }
        $script:fail++
    }
    Write-Host "---"
}

Run-Test "Empty file view" `
    "1`n4" `
    @(
        "Task Nr 2",
        "File is empty or does not exist."
    ) `
    -ResetFile

Run-Test "Add and view one shop" `
    "2`nCentral Shop`nBrivibas 10`n+371111111`n1`n4" `
    @(
        "Data saved.",
        "Count of shops in file: 1",
        "Title: Central Shop",
        "Address: Brivibas 10",
        "Tel. number: +371111111"
    ) `
    -ResetFile

Run-Test "Find phone by address" `
    "2`nCentral Shop`nBrivibas 10`n+371111111`n2`nCorner Shop`nMaskavas 5`n+371222222`n3`nMaskavas 5`n4" `
    @(
        "Data saved.",
        "Tel. number: +371222222"
    ) `
    -ResetFile

Run-Test "Address not found" `
    "2`nCentral Shop`nBrivibas 10`n+371111111`n3`nUnknown street`n4" `
    @(
        "Data saved.",
        "Shop with this address was not found."
    ) `
    -ResetFile

Run-Test "Separator validation" `
    "2`nBad|Shop`n4" `
    @(
        "Character '|' is not allowed in data."
    ) `
    -ResetFile

Run-Test "Invalid menu input" `
    "abc`n4" `
    @(
        "Invalid menu item."
    ) `
    -ResetFile

Reset-DataFile

Write-Host ""
Write-Host "=== Results: $pass passed, $fail failed ==="

if ($fail -gt 0) {
    exit 1
}