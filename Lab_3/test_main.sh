#!/bin/bash

# Comprehensive test script for main.cpp
# Tests various scenarios with and without Valgrind

PROGRAM="./main"
VALGRIND="valgrind --leak-check=full"

# Test cases: array of "description|inputs|expected_exit_code"
test_cases=(
    "Normal manual input|3\n1\n1\n-2\n3|0"
    "Normal auto input|2\n2\n0\n10|0"
    "Invalid size|0|1"
    "Invalid choice|3\n3|1"
    "Invalid manual input|2\n1\n1\na|1"
    "Invalid min|2\n2\na\n10|1"
    "Invalid max|2\n2\n0\nabc|1"
    "Empty input||1"
    "Large size|5\n1\n1\n2\n3\n4\n5|0"
)

echo "=== Comprehensive Test Script for main.cpp ==="
echo

total_tests=${#test_cases[@]}
passed=0
failed=0

for i in "${!test_cases[@]}"; do
    IFS='|' read -r desc inputs expected_exit <<< "${test_cases[$i]}"
    echo "Test $((i+1))/$total_tests: $desc"
    echo "Inputs: $(echo -e "$inputs" | head -c 50)..."
    echo

    # Run without Valgrind
    output=$(echo -e "$inputs" | timeout 10s $PROGRAM 2>&1)
    exit_code=$?
    echo "Exit code: $exit_code (expected: $expected_exit)"
    if [ "$exit_code" -eq "$expected_exit" ]; then
        echo "✓ Exit code correct"
        ((passed++))
    else
        echo "✗ Exit code mismatch"
        ((failed++))
    fi

    # Check for memory leaks with Valgrind
    valgrind_output=$(echo -e "$inputs" | timeout 10s $VALGRIND $PROGRAM 2>&1)
    valgrind_exit=$?
    if echo "$valgrind_output" | grep -q "no leaks are possible" && echo "$valgrind_output" | grep -q "ERROR SUMMARY: 0 errors"; then
        echo "✓ No memory leaks or errors"
    else
        echo "✗ Possible memory leaks or errors"
        echo "Valgrind summary:"
        echo "$valgrind_output" | grep -E "(HEAP SUMMARY|ERROR SUMMARY|definitely lost|indirectly lost|possibly lost|All heap blocks)" | head -10
    fi

    echo "Output preview:"
    echo "$output" | head -10
    echo
    echo "----------------------------------------"
    echo
done

echo "Summary: $passed passed, $failed failed out of $total_tests tests"
if [ $failed -eq 0 ]; then
    echo "All tests passed! 🎉"
else
    echo "Some tests failed. Check output above."
fi