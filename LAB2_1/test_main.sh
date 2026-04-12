#!/usr/bin/env bash

#*****************************************************************************#
#                                                                             #
#  test_main.sh                                           TTTTTTTT SSSSSSS II #
#                                                            TT    SS      II #
#  By: st93642@students.tsi.lv                               TT    SSSSSSS II #
#                                                            TT         SS II #
#  Created: Apr 12 2026 12:50 st93642                        TT    SSSSSSS II #
#  Updated: Apr 12 2026 17:55 st93642                                         #
#                                                                             #
#   Transport and Telecommunication Institute - Riga, Latvia                  #
#                       https://tsi.lv                                        #
#*****************************************************************************#

PROGRAM="./main"

echo "=== Test Script for LAB2_1 (Task 17: Shortest Word) ==="
echo

pass=0
fail=0

run_test() {
    name="$1"
    input="$2"
    expected_c="$3"
    expected_s="$4"

    echo "Test: $name"
    output=$(printf '%b\n' "$input" | "$PROGRAM" 2>&1)
    echo "$output"

    if echo "$output" | grep -q "$expected_c" && echo "$output" | grep -q "$expected_s"; then
        echo "PASS"
        pass=$((pass + 1))
    else
        echo "FAIL (expected c-string: '$expected_c', string: '$expected_s')"
        fail=$((fail + 1))
    fi
    echo "---"
}

run_error_test() {
    name="$1"
    input="$2"
    expected="$3"

    echo "Test: $name"
    output=$(printf '%b\n' "$input" | "$PROGRAM" 2>&1)
    echo "$output"

    if echo "$output" | grep -q "$expected"; then
        echo "PASS"
        pass=$((pass + 1))
    else
        echo "FAIL (expected: '$expected')"
        fail=$((fail + 1))
    fi
    echo "---"
}

# Test 1: Multiple words, different lengths
run_test "Basic multi-word" \
    "1\nhello world a test" \
    '"hello world a test" -> "a"' \
    '"hello world a test" -> "a"'

# Test 2: Single word
run_test "Single word" \
    "1\nhello" \
    '"hello" -> "hello"' \
    '"hello" -> "hello"'

# Test 3: Words of equal length (returns first encountered)
run_test "Equal length words" \
    "1\nabc def ghi" \
    '"abc def ghi" -> "abc"' \
    '"abc def ghi" -> "abc"'

# Test 4: Multiple strings
run_test "Multiple strings" \
    "2\nThe quick brown fox\nI am a programmer" \
    '"The quick brown fox" -> "The"' \
    '"I am a programmer" -> "I"'

# Test 5: Single character word
run_test "Single char word" \
    "1\nhello I world" \
    '"hello I world" -> "I"' \
    '"hello I world" -> "I"'

# Test 6: Two-letter shortest
run_test "Two-letter shortest" \
    "1\nhello is world" \
    '"hello is world" -> "is"' \
    '"hello is world" -> "is"'

# Test 7: Shortest at end
run_test "Shortest at end" \
    "1\nhello world a" \
    '"hello world a" -> "a"' \
    '"hello world a" -> "a"'

# Test 8: Shortest at beginning
run_test "Shortest at beginning" \
    "1\nI love programming" \
    '"I love programming" -> "I"' \
    '"I love programming" -> "I"'

# Test 9: Non-numeric count
run_error_test "Invalid count text" \
    "abc" \
    'Invalid count'

# Test 10: Too many strings requested
run_error_test "Invalid count too large" \
    "11" \
    'Invalid count'

echo
echo "=== Results: $pass passed, $fail failed ==="
