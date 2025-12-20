# Test script for main.exe in PowerShell

$program = "./main.exe"

Write-Host "=== Test Script for main.cpp ===" -ForegroundColor Cyan
Write-Host ""

$passed = 0
$failed = 0

# Test 1: Normal manual input
Write-Host "Test 1: Normal manual input"
$output = "3`n1`n1`n-2`n3" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 0) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Sum of positive elements: 4.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sum not correct" }
if ($output -match "Product of elements between extremes: -2.00") { $passed++ } else { $failed++; Write-Host "  ✗ Product not correct" }
if ($output -match "3.00 1.00 -2.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sorted not correct" }
Write-Host ""

# Test 2: Invalid size
Write-Host "Test 2: Invalid size"
$output = "0" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 1) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Invalid size") { $passed++ } else { $failed++; Write-Host "  ✗ Error message not correct" }
Write-Host ""

# Test 3: Invalid choice
Write-Host "Test 3: Invalid choice"
$output = "3`n3" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 1) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Invalid flag") { $passed++ } else { $failed++; Write-Host "  ✗ Error message not correct" }
Write-Host ""

# Test 4: Invalid manual input
Write-Host "Test 4: Invalid manual input"
$output = "2`n1`n1`na" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 1) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Invalid input") { $passed++ } else { $failed++; Write-Host "  ✗ Error message not correct" }
Write-Host ""

# Test 5: Invalid min
Write-Host "Test 5: Invalid min"
$output = "2`n2`na`n10" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 1) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Invalid min") { $passed++ } else { $failed++; Write-Host "  ✗ Error message not correct" }
Write-Host ""

# Test 6: Invalid max
Write-Host "Test 6: Invalid max"
$output = "2`n2`n0`nabc" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 1) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Invalid max") { $passed++ } else { $failed++; Write-Host "  ✗ Error message not correct" }
Write-Host ""

# Test 7: Large size
Write-Host "Test 7: Large size"
$output = "5`n1`n1`n2`n3`n4`n5" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 0) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Sum of positive elements: 15.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sum not correct" }
if ($output -match "Product of elements between extremes: 24.00") { $passed++ } else { $failed++; Write-Host "  ✗ Product not correct" }
if ($output -match "5.00 4.00 3.00 2.00 1.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sorted not correct" }
Write-Host ""

# Test 8: No positives
Write-Host "Test 8: No positives"
$output = "3`n1`n-1`n-2`n-3" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 0) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Sum of positive elements: 0.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sum not correct" }
if ($output -match "-1.00 -2.00 -3.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sorted not correct" }
Write-Host ""

# Test 9: All positives
Write-Host "Test 9: All positives"
$output = "3`n1`n1`n2`n3" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 0) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Sum of positive elements: 6.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sum not correct" }
if ($output -match "Product of elements between extremes: 2.00") { $passed++ } else { $failed++; Write-Host "  ✗ Product not correct" }
if ($output -match "3.00 2.00 1.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sorted not correct" }
Write-Host ""

# Test 10: Adjacent extremes
Write-Host "Test 10: Adjacent extremes"
$output = "3`n1`n4`n-1`n2" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 0) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Sum of positive elements: 6.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sum not correct" }
if ($output -match "No elements between extremes") { $passed++ } else { $failed++; Write-Host "  ✗ No elements message not correct" }
if ($output -match "4.00 2.00 -1.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sorted not correct" }
Write-Host ""

# Test 11: Equal abs values
Write-Host "Test 11: Equal abs values"
$output = "3`n1`n2`n-2`n2" | & $program 2>&1
$exit_code = $LASTEXITCODE
if ($exit_code -eq 0) { $passed++ } else { $failed++; Write-Host "  ✗ Exit code: $exit_code" }
if ($output -match "Sum of positive elements: 4.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sum not correct" }
if ($output -match "No elements between extremes") { $passed++ } else { $failed++; Write-Host "  ✗ No elements message not correct" }
if ($output -match "2.00 2.00 -2.00") { $passed++ } else { $failed++; Write-Host "  ✗ Sorted not correct" }
Write-Host ""

Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Passed: $passed"
Write-Host "Failed: $failed"
Write-Host "Total:  $(($passed + $failed))"

if ($failed -eq 0) {
    Write-Host "All tests passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Some tests failed" -ForegroundColor Red
    exit 1
}