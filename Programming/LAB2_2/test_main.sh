#!/bin/bash
# Test script for LAB2_2 shop program
# Tests: build, view, add, find, and edge cases

set -e

BINARY="./shops"
DATA="shops.dat"
PASS=0
FAIL=0
RUN_DIR=""

cleanup() {
    if [ -n "$RUN_DIR" ]; then
        rm -rf "$RUN_DIR"
    fi
}
trap cleanup EXIT

echo "=== Building ==="
make clean > /dev/null 2>&1 || true
if make; then
    echo "[PASS] Build"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Build"
    FAIL=$((FAIL + 1))
    exit 1
fi

RUN_DIR=$(mktemp -d)
BINARY=$(pwd)/shops

run_program() {
    (cd "$RUN_DIR" && printf "%b" "$1" | "$BINARY")
}

reset_data() {
    rm -f "$RUN_DIR/$DATA"
}

echo ""
echo "=== Test 1: View empty file ==="
reset_data
run_program "2\n4\n" | grep -q "File is empty" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Empty file message"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Empty file message"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 2: Add a shop ==="
reset_data
run_program "1\nTestShop\n123 Test St\n555-1234\n4\n" | grep -q "Data saved" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Add shop"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Add shop"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 3: View after add ==="
run_program "2\n4\n" | grep -q "TestShop" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] View shows added shop"
    PASS=$((PASS + 1))
else
    echo "[FAIL] View shows added shop"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 4: Find phone by address ==="
run_program "3\n123 Test St\n4\n" | grep -q "555-1234" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Find phone by address"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Find phone by address"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 5: Find non-existent address ==="
run_program "3\nNowhere\n4\n" | grep -q "not found" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Non-existent address"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Non-existent address"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 6: Multiple shops ==="
reset_data
run_program "1\nShopA\nAddrA\n111-1111\n1\nShopB\nAddrB\n222-2222\n2\n4\n" | grep -q "Shops in file: 2" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Multiple shops count"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Multiple shops count"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 7: Pipe character allowed in binary data ==="
reset_data
run_program "1\nBad|Shop\n12|3 Pipe St\n555-1234\n2\n4\n" | grep -q "Bad|Shop" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Pipe character stored and displayed"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Pipe character stored and displayed"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 8: Invalid menu choice ==="
run_program "99\n4\n" | grep -q "Invalid menu item" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Invalid menu choice"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Invalid menu choice"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 9: Exit ==="
run_program "4\n" > /dev/null 2>&1 && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Exit"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Exit"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 10: Invalid non-numeric menu input ==="
run_program "abc\n4\n" | grep -q "Invalid menu item" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Non-numeric menu"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Non-numeric menu"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 11: Lookup after multiple adds and verify count ==="
reset_data
run_program "1\nShop1\nAddr1\n111\n1\nShop2\nAddr2\n222\n2\n3\nAddr2\n4\n" | grep -q "Shops in file: 2" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Multi-add count and lookup"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Multi-add count and lookup"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 12: Negative menu choice ==="
run_program "-1\n4\n" | grep -q "Invalid menu item" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Negative menu choice"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Negative menu choice"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Test 13: Address with spaces and special chars ==="
reset_data
run_program "1\nMy Shop\n123 Main St, Bldg #4\n+1 (555) 999-0000\n2\n4\n" | grep -q "My Shop" && r=0 || r=1
if [ $r -eq 0 ]; then
    echo "[PASS] Special chars in fields"
    PASS=$((PASS + 1))
else
    echo "[FAIL] Special chars in fields"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=============================="
echo "Results: $PASS passed, $FAIL failed"
echo "=============================="

[ $FAIL -eq 0 ] && exit 0 || exit 1
