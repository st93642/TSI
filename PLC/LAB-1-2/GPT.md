Question: Write a program in Python that asks the user to enter a number, determines whether the number is even or odd, and whether it is positive, negative, or zero. The program should display the result clearly. Please include comments in the code and explain how the program works in simple terms suitable for a beginner.

Here’s a simple Python program that does exactly what you asked, with beginner-friendly comments:

```python
# This program asks the user to enter a number
# Then it checks whether the number is even or odd
# And whether it is positive, negative, or zero

# Ask the user to input a number
number = float(input("Enter a number: "))

# Check if the number is positive, negative, or zero
if number > 0:
    sign = "positive"
elif number < 0:
    sign = "negative"
else:
    sign = "zero"

# Check if the number is even or odd
# Note: Even/odd only makes sense for integers
if number.is_integer():  # Check if the number is a whole number
    if int(number) % 2 == 0:
        parity = "even"
    else:
        parity = "odd"
else:
    parity = "neither even nor odd (not an integer)"

# Display the result
print("\nResult:")
print("The number is", sign)
print("The number is", parity)
```

---

## 🧠 Simple Explanation (Beginner-Friendly)

### 1. Getting input

```python
number = float(input("Enter a number: "))
```

* The program asks the user to type a number.
* `input()` reads it as text, so we convert it to a number using `float()` (this allows decimals too).

---

### 2. Checking if it’s positive, negative, or zero

```python
if number > 0:
    sign = "positive"
elif number < 0:
    sign = "negative"
else:
    sign = "zero"
```

* If the number is greater than 0 → positive
* If less than 0 → negative
* Otherwise → zero

---

### 3. Checking if it’s even or odd

```python
if number.is_integer():
```

* Even/odd only applies to whole numbers (like 2, 5, -8).
* So we first check if the number is an integer.

```pythonImprove the program so that it handles invalid input (for example, if the user enters text instead of a
number).
Explain what was changed and why.
if int(number) % 2 == 0:
```

* `%` means “remainder”
* If a number divided by 2 gives remainder 0 → even
* Otherwise → odd

---

### 4. Showing the result

```python
print("The number is", sign)
print("The number is", parity)
```

* The program prints clear results for the user.

---

## ✅ Example Output

```
Enter a number: -4

Result:
The number is negative
The number is even
```

---

If you want, I can simplify it further (e.g., only integers, or without floats) or turn it into a small interactive app.

Question: Improve the program so that it handles invalid input (for example, if the user enters text instead of a number). Explain what was changed and why.

Here’s an improved version of the program that safely handles invalid input (like text instead of a number):

```python
# This program asks the user to enter a number
# It checks if the input is valid and keeps asking until it gets a correct number
# Then it determines whether the number is even/odd and positive/negative/zero

while True:
    try:
        # Try to convert user input into a number
        number = float(input("Enter a number: "))
        break  # Exit the loop if input is valid
    except ValueError:
        # This runs if the user enters something that is not a number
        print("Invalid input! Please enter a valid number.\n")

# Check if the number is positive, negative, or zero
if number > 0:
    sign = "positive"
elif number < 0:
    sign = "negative"
else:
    sign = "zero"

# Check if the number is even or odd
if number.is_integer():  # Only works for whole numbers
    if int(number) % 2 == 0:
        parity = "even"
    else:
        parity = "odd"
else:
    parity = "neither even nor odd (not an integer)"

# Display the result
print("\nResult:")
print("The number is", sign)
print("The number is", parity)
```

---

## 🧠 What Was Changed and Why

### 1. Added a loop (`while True`)

```python
while True:
```

* This makes the program keep asking the user for input **until it’s valid**.
* Without this, the program would crash or stop after a bad input.

---

### 2. Used `try` and `except`

```python
try:
    number = float(input("Enter a number: "))
except ValueError:
```

* `try` means: *“attempt this code”*
* `except ValueError` means: *“if there’s an error converting to a number, handle it”*

👉 Example of invalid input:

* `"hello"`
* `"abc123"`
* `"five"`

Instead of crashing, the program now shows:

```
Invalid input! Please enter a valid number.
```

---

### 3. Used `break` to exit the loop

```python
break
```

* Once the user enters a valid number, the loop stops.
* Then the program continues normally.

---

## 🔍 Why This Improvement Matters

Before:

* The program would **crash** if the user entered text.

Now:

* The program is **user-friendly and safe**.
* It **guides the user** to enter correct input.
* It behaves like real-world programs that don’t crash easily.

---

## ✅ Example Run

```
Enter a number: hello
Invalid input! Please enter a valid number.

Enter a number: 7

Result:
The number is positive
The number is odd
```

---

If you want, I can also show a version that only accepts integers (no decimals) or adds more checks (like limiting range).
