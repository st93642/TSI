# Practical Work 2 Solution

This folder contains four standalone Wokwi-ready projects and a report source file:

- `exercise1/` - external LED blink on Arduino Uno pin 8
- `exercise2/` - running lights on pins 13 to 9
- `exercise3/` - odd/even LED toggle with a pushbutton
- `exercise4/` - 7-segment countdown with reset button and buzzer
- `Practical_Work_2_Report.html` - report source that can be converted to DOCX/PDF
- `practical2_solution.code-workspace` - multi-root VS Code workspace for the four exercises

Each exercise folder contains:

- a matching Arduino sketch entry file such as `exercise1.ino`
- `blink.S`
- `diagram.json`
- `wokwi.toml`

## Running In VS Code Wokwi

The Wokwi VS Code extension simulates compiled firmware, so each exercise must be built before starting the simulator.

1. Open `practical2_solution.code-workspace` in VS Code, or open any individual `exerciseN` folder as a separate folder.
2. Make sure `arduino-cli` is installed and the Arduino Uno core is available.
3. Build an exercise from its own folder, for example:

	`arduino-cli compile --fqbn arduino:avr:uno --build-path build .`

4. Press `F1`, run `Wokwi: Start Simulator`, and Wokwi will load the firmware from `build/*.hex` as configured in `wokwi.toml`.

If `arduino-cli` is not installed yet, install it first and then run:

- `arduino-cli core update-index`
- `arduino-cli core install arduino:avr`

To use any exercise on the Wokwi website instead of VS Code, create/import an Arduino Uno project and replace the project files with the files from the corresponding exercise directory.