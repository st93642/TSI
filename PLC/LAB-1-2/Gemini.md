 Question: Write a program in Python that asks the user to enter a number, determines whether the
number is even or odd, and whether it is positive, negative, or zero. The program should display the
result clearly.
Please include comments in the code and explain how the program works in simple terms suitable for a
beginner.

Here is the Python program. I've added comments inside the code (lines starting with `#`) to explain what each part does. 

### The Python Code

```python
# Ask the user to enter a number and store it in a variable called 'user_number'
# We use int() to convert the user's text input into an integer (a whole number)
user_number = int(input("Please enter a whole number: "))

# --- Part 1: Check if it is positive, negative, or zero ---
if user_number > 0:
    print(f"{user_number} is a positive number.")
elif user_number < 0:
    print(f"{user_number} is a negative number.")
else:
    # If it's not greater than 0 and not less than 0, it must be exactly 0
    print("The number is exactly zero.")

# --- Part 2: Check if it is even or odd ---
# We use the modulo operator (%), which divides the number by 2 and gives us the remainder.
# If the remainder is 0, the number divides perfectly by 2, meaning it is even.
if user_number % 2 == 0:
    print(f"{user_number} is an even number.")
else:
    # If the remainder is not 0 (it will be 1), the number is odd.
    print(f"{user_number} is an odd number.")
```

***

### How It Works (Beginner's Guide)

Here is a step-by-step breakdown of the concepts used in the program:

* **Getting Input (`input` & `int`):** When you use `input()`, Python pauses and waits for the user to type something on the keyboard. However, Python treats whatever you type as regular text (a "string"). Because we want to do math with it, we wrap it in `int()`, which translates that text into an **integer** (a whole number).
* **Making Decisions (`if`, `elif`, `else`):** These are called conditional statements. They let the program make choices based on the number you entered.
    * `if`: This is the first check. (e.g., "Is the number bigger than zero?")
    * `elif` (short for "else if"): If the first check was false, try this one next. (e.g., "Okay, is it less than zero?")
    * `else`: This is the catch-all at the end. If none of the above were true, this happens automatically. (e.g., "If it's not positive or negative, it has to be zero.")
* **The Math Magic (`%`):** The `%` symbol is called the **modulo** operator. Instead of giving you the result of a division, it gives you the *remainder*. 
    * If you divide 10 by 2, the remainder is 0. (`10 % 2 == 0`) -> Even!
    * If you divide 11 by 2, the remainder is 1. (`11 % 2 == 1`) -> Odd!
* **Printing the Result (`print` & `f-strings`):**
    The `print()` function displays text on the screen. The little `f` right before the quotation marks (like `f"{user_number} is..."`) is a neat Python trick called an "f-string." It allows you to magically insert the value of your variables right into the middle of a sentence by wrapping them in curly braces `{}`.

    Question: Improve the program so that it handles invalid input (for example, if the user enters text instead of a
number).
Explain what was changed and why.

Here is the improved version of the program. I have added a `try...except` block inside a loop to catch errors and prevent the program from crashing if the user types something unexpected.

### The Improved Python Code

```python
# We use a 'while True' loop to keep asking for input until the user gets it right.
while True:
    try:
        # Ask the user for input
        user_input = input("Please enter a whole number: ")
        
        # Try to convert the text into an integer
        user_number = int(user_input)
        
        # If the conversion succeeds, we 'break' out of the loop and move on
        break
        
    except ValueError:
        # If the user typed text or a decimal, int() will trigger a ValueError.
        # We catch that error here, print a friendly message, and the loop repeats.
        print("Oops! That is not a valid whole number. Please try again.\n")


# --- Part 1: Check if it is positive, negative, or zero ---
if user_number > 0:
    print(f"{user_number} is a positive number.")
elif user_number < 0:
    print(f"{user_number} is a negative number.")
else:
    print("The number is exactly zero.")

# --- Part 2: Check if it is even or odd ---
if user_number % 2 == 0:
    print(f"{user_number} is an even number.")
else:
    print(f"{user_number} is an odd number.")
```

***

### What Was Changed and Why

When writing programs, we can never completely trust that the user will type exactly what we ask for. If we ask for a number and they type "hello" or "5.5", the original program would crash because the `int()` function doesn't know how to turn those into a whole number. 

To fix this, we added a concept called **Error Handling** (specifically, a `try...except` block) combined with a **loop**. Here is how the new additions work:

* **The `while True:` Loop:** This creates an infinite loop. It traps the program in the asking phase, meaning the user cannot move on to the math part of the code until they provide a valid number.
* **The `try:` Block:** We put the "risky" code inside this block. We are essentially telling Python, *"Try to run this code. If it works, great! If it crashes, don't panic, just let me handle it."*
* **The `break` Statement:** If the user enters a valid number, `int()` succeeds, and the program reaches the `break` command. This command tells Python to immediately exit the `while` loop and continue with the rest of the program (the math checks).
* **The `except ValueError:` Block:** If the user types text (like "apple"), the `int()` function fails and throws a specific error called a `ValueError`. Because we are using `try`, the program doesn't crash. Instead, it immediately jumps down to this `except` block, prints our custom "Oops!" message, and then goes back to the start of the `while` loop to ask again. 

This approach makes your code much more robust and user-friendly, as it gently guides the user to correct their mistake instead of abruptly shutting down!