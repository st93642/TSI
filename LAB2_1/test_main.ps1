#*****************************************************************************#
#                                                                             #
#  test_main.ps1                                          TTTTTTTT SSSSSSS II #
#                                                            TT    SS      II #
#  By: st93642@students.tsi.lv                               TT    SSSSSSS II #
#                                                            TT         SS II #
#  Created: Apr 12 2026 18:10 st93642                        TT    SSSSSSS II #
#  Updated: Apr 12 2026 18:21 st93642                                         #
#                                                                             #
#   Transport and Telecommunication Institute - Riga, Latvia                  #
#                       https://tsi.lv                                        #
#*****************************************************************************#

$PROGRAM = (Resolve-Path ".\main.exe").Path

Write-Host "=== Test Script for LAB2_1 (Task 17: Shortest Word) ==="
Write-Host ""

$pass = 0
$fail = 0

function Invoke-Program {
    param([string]$InputData)
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $script:PROGRAM
    $pinfo.RedirectStandardInput = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.RedirectStandardError = $true
    $pinfo.UseShellExecute = $false
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.StandardInput.Write($InputData + "`n")
    $p.StandardInput.Close()
    $out = $p.StandardOutput.ReadToEnd()
    $err = $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    return $out + $err
}

function Run-Test {
    param (
        [string]$Name,
        [string]$InputData,
        [string]$ExpectedC,
        [string]$ExpectedS
    )

    Write-Host "Test: $Name"
    $output = Invoke-Program $InputData
    Write-Host $output.Trim()

    if (($output -match [regex]::Escape($ExpectedC)) -and ($output -match [regex]::Escape($ExpectedS))) {
        Write-Host "PASS"
        $script:pass++
    } else {
        Write-Host "FAIL (expected c-string: '$ExpectedC', string: '$ExpectedS')"
        $script:fail++
    }
    Write-Host "---"
}

function Run-ErrorTest {
    param (
        [string]$Name,
        [string]$InputData,
        [string]$Expected
    )

    Write-Host "Test: $Name"
    $output = Invoke-Program $InputData
    Write-Host $output.Trim()

    if ($output -match [regex]::Escape($Expected)) {
        Write-Host "PASS"
        $script:pass++
    } else {
        Write-Host "FAIL (expected: '$Expected')"
        $script:fail++
    }
    Write-Host "---"
}

# Test 1: Multiple words, different lengths
Run-Test "Basic multi-word" `
    "1`nhello world a test" `
    '"hello world a test" -> "a"' `
    '"hello world a test" -> "a"'

# Test 2: Single word
Run-Test "Single word" `
    "1`nhello" `
    '"hello" -> "hello"' `
    '"hello" -> "hello"'

# Test 3: Words of equal length (returns first encountered)
Run-Test "Equal length words" `
    "1`nabc def ghi" `
    '"abc def ghi" -> "abc"' `
    '"abc def ghi" -> "abc"'

# Test 4: Multiple strings
Run-Test "Multiple strings" `
    "2`nThe quick brown fox`nI am a programmer" `
    '"The quick brown fox" -> "The"' `
    '"I am a programmer" -> "I"'

# Test 5: Single character word
Run-Test "Single char word" `
    "1`nhello I world" `
    '"hello I world" -> "I"' `
    '"hello I world" -> "I"'

# Test 6: Two-letter shortest
Run-Test "Two-letter shortest" `
    "1`nhello is world" `
    '"hello is world" -> "is"' `
    '"hello is world" -> "is"'

# Test 7: Shortest at end
Run-Test "Shortest at end" `
    "1`nhello world a" `
    '"hello world a" -> "a"' `
    '"hello world a" -> "a"'

# Test 8: Shortest at beginning
Run-Test "Shortest at beginning" `
    "1`nI love programming" `
    '"I love programming" -> "I"' `
    '"I love programming" -> "I"'

# Test 9: Non-numeric count
Run-ErrorTest "Invalid count text" `
    "abc" `
    "Invalid count"

# Test 10: Too many strings requested
Run-ErrorTest "Invalid count too large" `
    "11" `
    "Invalid count"

Write-Host ""
Write-Host "=== Results: $pass passed, $fail failed ==="
