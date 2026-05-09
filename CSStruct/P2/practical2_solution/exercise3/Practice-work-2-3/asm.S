; Exercise 3
; Control five LEDs with one button

#define __SFR_OFFSET 0

#include "avr/io.h"

.global main

main:
  ldi   r16, 0x3E       ; Configure PB5..PB1 as LED outputs
  out   DDRB, r16       ; Enable the LED pins as outputs
  cbi   DDRD, 2         ; Keep PD2 (digital pin 2) as a button input
  sbi   PORTD, 2        ; Enable the internal pull-up on the button pin
  ldi   r17, 0x2A       ; Turn on odd LEDs: PB5, PB3, and PB1
  out   PORTB, r17      ; Show the initial odd/even pattern

poll_button:
  sbis  PIND, 2         ; Skip next instruction while the button is released
  rjmp  button_pressed  ; Jump only when the button pulls PD2 low
  rjmp  poll_button     ; Keep checking until the button is pressed

button_pressed:
  ldi   r25, hi8(20)    ; Load a short 20ms debounce delay high byte
  ldi   r24, lo8(20)    ; Load a short 20ms debounce delay low byte
  call  delay_ms        ; Wait for the button signal to settle
  sbis  PIND, 2         ; Skip next instruction if the button bounced high
  rjmp  toggle_pattern  ; Toggle only when the press is still valid
  rjmp  poll_button     ; Ignore false triggers and continue polling

toggle_pattern:
  ldi   r18, 0x3E       ; Build a mask covering the five LED bits
  eor   r17, r18        ; Swap odd LEDs with even LEDs
  out   PORTB, r17      ; Update the LED outputs

wait_release:
  sbis  PIND, 2         ; Skip next instruction once the button is released
  rjmp  wait_release    ; Prevent repeated toggles while still pressed
  ldi   r25, hi8(20)    ; Load a short release debounce delay high byte
  ldi   r24, lo8(20)    ; Load a short release debounce delay low byte
  call  delay_ms        ; Let the release state settle
  rjmp  poll_button     ; Return to the main polling loop

delay_ms:
                        ; Delay about (r25:r24) milliseconds at 16MHz
  ldi   r31, hi8(4000)  ; Load the inner-loop counter high byte
  ldi   r30, lo8(4000)  ; Load the inner-loop counter low byte
delay_inner:
  sbiw  r30, 1          ; Spend four clock cycles per inner-loop pass
  brne  delay_inner     ; Stay in the inner loop until it reaches zero
  sbiw  r24, 1          ; Decrement the millisecond counter
  brne  delay_ms        ; Repeat until the whole delay elapsed
  ret                   ; Return to the caller
