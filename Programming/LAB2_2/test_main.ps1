# Test script for LAB2_2 shop program
# Tests: build, view, add, find, and edge cases

$ErrorActionPreference = "Stop"

$Binary = "$PSScriptRoot\shops.exe"
$Data = "shops.dat"
$Pass = 0
$Fail = 0
$TempDir = $null

# Use a temp dir so tests don't pollute the source tree
$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("lab2_2_test_" + [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

function Reset-Data {
    Remove-Item (Join-Path $TempDir $Data) -ErrorAction SilentlyContinue
}

function Invoke-Program {
    param([string]$InputText)
    $stdinFile  = Join-Path $TempDir "stdin.txt"

    # Write input to temp file (no trailing newline, to match bash printf "%b" behavior)
    [System.IO.File]::WriteAllText($stdinFile, $InputText)

    # Run binary inside temp dir so shops.dat stays isolated per test
    Push-Location $TempDir
    try {
        $result = Get-Content $stdinFile -Raw | & $Binary *>&1 | Out-String
    } finally {
        Pop-Location
    }
    return $result
}

function Assert-Output {
    param([string]$Label, [string]$Pattern)
    $output = Invoke-Program -InputText $args[2]
    if ($output -match $Pattern) {
        Write-Host "[PASS] $Label" -ForegroundColor Green
        $script:Pass++
    } else {
        Write-Host "[FAIL] $Label" -ForegroundColor Red
        Write-Host "  Expected pattern: $Pattern"
        Write-Host "  Got output:"
        Write-Host $output
        $script:Fail++
    }
}

Write-Host "=== Building ===" -ForegroundColor Cyan

# Clean and build
Push-Location $PSScriptRoot
try {
    if (Test-Path $Binary) { Remove-Item $Binary -Force }
    if (Test-Path "shops.o") { Remove-Item "shops.o" -Force }

    $buildResult = & g++ -Wextra -Wall -Werror -pedantic -std=c++17 -o shops.exe main.cpp 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[PASS] Build" -ForegroundColor Green
        $Pass++
    } else {
        Write-Host "[FAIL] Build" -ForegroundColor Red
        Write-Host $buildResult
        $Fail++
        exit 1
    }
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "=== Test 1: View empty file ===" -ForegroundColor Cyan
Reset-Data
$output = Invoke-Program "2`n4`n"
if ($output -match "File is empty") { Write-Host "[PASS] Empty file message" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Empty file message" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 2: Add a shop ===" -ForegroundColor Cyan
Reset-Data
$output = Invoke-Program "1`nTestShop`n123 Test St`n555-1234`n4`n"
if ($output -match "Data saved") { Write-Host "[PASS] Add shop" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Add shop" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 3: View after add ===" -ForegroundColor Cyan
$output = Invoke-Program "2`n4`n"
if ($output -match "TestShop") { Write-Host "[PASS] View shows added shop" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] View shows added shop" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 4: Find phone by address ===" -ForegroundColor Cyan
$output = Invoke-Program "3`n123 Test St`n4`n"
if ($output -match "555-1234") { Write-Host "[PASS] Find phone by address" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Find phone by address" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 5: Find non-existent address ===" -ForegroundColor Cyan
$output = Invoke-Program "3`nNowhere`n4`n"
if ($output -match "not found") { Write-Host "[PASS] Non-existent address" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Non-existent address" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 6: Multiple shops ===" -ForegroundColor Cyan
Reset-Data
$output = Invoke-Program "1`nShopA`nAddrA`n111-1111`n1`nShopB`nAddrB`n222-2222`n2`n4`n"
if ($output -match "Shops in file: 2") { Write-Host "[PASS] Multiple shops count" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Multiple shops count" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 7: Pipe character allowed in binary data ===" -ForegroundColor Cyan
Reset-Data
$output = Invoke-Program "1`nBad|Shop`n12|3 Pipe St`n555-1234`n2`n4`n"
if ($output -match "Bad\|Shop") { Write-Host "[PASS] Pipe character stored and displayed" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Pipe character stored and displayed" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 8: Invalid menu choice ===" -ForegroundColor Cyan
$output = Invoke-Program "99`n4`n"
if ($output -match "Invalid menu item") { Write-Host "[PASS] Invalid menu choice" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Invalid menu choice" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 9: Exit ===" -ForegroundColor Cyan
$output = Invoke-Program "4`n"
if ($LASTEXITCODE -eq 0) { Write-Host "[PASS] Exit" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Exit" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 10: Invalid non-numeric menu input ===" -ForegroundColor Cyan
$output = Invoke-Program "abc`n4`n"
if ($output -match "Invalid menu item") { Write-Host "[PASS] Non-numeric menu" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Non-numeric menu" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 11: Multi-add count and lookup ===" -ForegroundColor Cyan
Reset-Data
$output = Invoke-Program "1`nShop1`nAddr1`n111`n1`nShop2`nAddr2`n222`n2`n3`nAddr2`n4`n"
if ($output -match "Shops in file: 2") { Write-Host "[PASS] Multi-add count and lookup" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Multi-add count and lookup" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 12: Negative menu choice ===" -ForegroundColor Cyan
$output = Invoke-Program "-1`n4`n"
if ($output -match "Invalid menu item") { Write-Host "[PASS] Negative menu choice" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Negative menu choice" -ForegroundColor Red; $Fail++ }

Write-Host ""
Write-Host "=== Test 13: Special chars in fields ===" -ForegroundColor Cyan
Reset-Data
$output = Invoke-Program "1`nMy Shop`n123 Main St, Bldg #4`n+1 (555) 999-0000`n2`n4`n"
if ($output -match "My Shop") { Write-Host "[PASS] Special chars in fields" -ForegroundColor Green; $Pass++ }
else { Write-Host "[FAIL] Special chars in fields" -ForegroundColor Red; $Fail++ }

# Cleanup
if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "Results: $Pass passed, $Fail failed" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

if ($Fail -gt 0) { exit 1 } else { exit 0 }
