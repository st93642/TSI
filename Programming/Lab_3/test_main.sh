#!/bin/bash

# Test scenarios with and without Valgrind

PROGRAM="./main"
VALGRIND="valgrind --leak-check=full"

test_cases=(
    "Normal manual input|3\n1\n1\n-2\n3|0|4.00|-2.00|3.00 1.00 -2.00"
    "Normal auto input|2\n2\n0\n10|0||||"
    "Invalid size|0|1||||"
    "Invalid choice|3\n3|1||||"
    "Invalid manual input|2\n1\n1\na|1||||"
    "Invalid min|2\n2\na\n10|1||||"
    "Invalid max|2\n2\n0\nabc|1||||"
    "Empty input||1||||"
    "Large size|5\n1\n1\n2\n3\n4\n5|0|15.00|24.00|5.00 4.00 3.00 2.00 1.00"
    "No positives|3\n1\n-1\n-2\n-3|0|0.00|-2.00|-1.00 -2.00 -3.00"
    "All positives|3\n1\n1\n2\n3|0|6.00|2.00|3.00 2.00 1.00"
    "Adjacent extremes|3\n1\n4\n-1\n2|0|6.00|0.00|4.00 2.00 -1.00"
    "Equal abs values|3\n1\n2\n-2\n2|0|4.00|0.00|2.00 2.00 -2.00"
)

echo "=== Test Script for main.cpp ==="
echo

total_tests=${#test_cases[@]}
passed=0
failed=0

for i in "${!test_cases[@]}"; do
    IFS='|' read -r desc inputs expected_exit expected_sum expected_product expected_sorted <<< "${test_cases[$i]}"
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

    # Check calculations if expected values provided
    if [ -n "$expected_sum" ]; then
        actual_sum=$(echo "$output" | grep "Sum of positive elements:" | awk '{print $5}')
        if [ "$actual_sum" = "$expected_sum" ]; then
            echo "✓ Sum correct: $actual_sum"
        else
            echo "✗ Sum mismatch: expected $expected_sum, got $actual_sum"
            ((failed++))
        fi
    fi

    if [ -n "$expected_product" ]; then
        if [ "$expected_product" = "0.00" ]; then
            if echo "$output" | grep -q "No elements between extremes."; then
                echo "✓ No elements message correct"
            else
                echo "✗ No elements message missing"
                ((failed++))
            fi
        else
            if echo "$output" | grep -q "Product of elements between extremes:"; then
                actual_product=$(echo "$output" | grep "Product of elements between extremes:" | awk '{print $6}')
                if [ "$actual_product" = "$expected_product" ]; then
                    echo "✓ Product correct: $actual_product"
                else
                    echo "✗ Product mismatch: expected $expected_product, got $actual_product"
                    ((failed++))
                fi
            else
                echo "✗ Product line missing"
                ((failed++))
            fi
        fi
    fi

    if [ -n "$expected_sorted" ]; then
        actual_sorted=$(echo "$output" | grep "Sorted (descending):" | sed 's/.*: //' | xargs)
        if [ "$actual_sorted" = "$expected_sorted" ]; then
            echo "✓ Sorted correct: $actual_sorted"
        else
            echo "✗ Sorted mismatch: expected '$expected_sorted', got '$actual_sorted'"
            ((failed++))
        fi
    fi

    # Check output format
    if [ "$expected_exit" -eq 0 ]; then
        if echo "$output" | grep -q "Array:"; then
            echo "✓ Array printed"
        else
            echo "✗ Array not printed"
            ((failed++))
        fi
        if echo "$output" | grep -q "Sum of positive elements:"; then
            echo "✓ Sum printed"
        else
            echo "✗ Sum not printed"
            ((failed++))
        fi
        if echo "$output" | grep -q "Product of elements between extremes:\|No elements between extremes."; then
            echo "✓ Product info printed"
        else
            echo "✗ Product info not printed"
            ((failed++))
        fi
        if echo "$output" | grep -q "Sorted (descending):"; then
            echo "✓ Sorted printed"
        else
            echo "✗ Sorted not printed"
            ((failed++))
        fi
        # Check exact array for manual inputs
        if [ "$desc" = "Normal manual input" ]; then
            if echo "$output" | grep -q "Array: 1.00 -2.00 3.00"; then
                echo "✓ Correct array output"
            else
                echo "✗ Incorrect array output"
                ((failed++))
            fi
        fi
    else
        # Check error messages
        case "$desc" in
            "Invalid size")
                if echo "$output" | grep -q "Invalid size"; then
                    echo "✓ Correct error message: Invalid size"
                else
                    echo "✗ Wrong error message"
                    ((failed++))
                fi
                ;;
            "Invalid choice")
                if echo "$output" | grep -q "Invalid flag"; then
                    echo "✓ Correct error message: Invalid flag"
                else
                    echo "✗ Wrong error message"
                    ((failed++))
                fi
                ;;
            "Invalid manual input")
                if echo "$output" | grep -q "Invalid input"; then
                    echo "✓ Correct error message: Invalid input"
                else
                    echo "✗ Wrong error message"
                    ((failed++))
                fi
                ;;
            "Invalid min")
                if echo "$output" | grep -q "Invalid min"; then
                    echo "✓ Correct error message: Invalid min"
                else
                    echo "✗ Wrong error message"
                    ((failed++))
                fi
                ;;
            "Invalid max")
                if echo "$output" | grep -q "Invalid max"; then
                    echo "✓ Correct error message: Invalid max"
                else
                    echo "✗ Wrong error message"
                    ((failed++))
                fi
                ;;
            "Empty input")
                if echo "$output" | grep -q "Invalid size"; then
                    echo "✓ Correct error message: Invalid size"
                else
                    echo "✗ Wrong error message"
                    ((failed++))
                fi
                ;;
        esac
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
    echo "All tests passed"
else
    echo "Some tests failed. Check output above."
fi