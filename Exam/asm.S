; ==============================================================================
; Final Exam Practical Task - CSS_VP
; Student: Igors Oleinikovs   Student code: 93642
; Student-code digits shown in order: 9 -> 3 -> 6 -> 4 -> 2
;
; Hardware (Wokwi / Arduino Uno, ATmega328P):
;   LED1 (odd)  = PB5 (digital pin 13)
;   LED2 (even) = PB4 (digital pin 12)
;   LED3 (odd)  = PB3 (digital pin 11)
;   LED4 (even) = PB2 (digital pin 10)
;   LED5 (odd)  = PB1 (digital pin  9)
;   7-seg A..F  = PC5..PC0 (analog A5..A0)
;   7-seg G     = PD3 (digital pin 3)
;   Button      = PD2 (digital pin 2, internal pull-up, active low)
;
; Behaviour:
;   1. Initial state: display blank, LEDs show alternating pattern (1,3,5 ON)
;   2. Wait for button press AND release (debounced)
;   3. Show each student-code digit for ~1 s; LEDs show odd (1,3,5) / even (2,4)
;   4. Running light LED1->LED5, ~0.5 s each, display blank
;   5. Return to initial state and wait for the next button press
; ==============================================================================

#define __SFR_OFFSET 0

#include "avr/io.h"

.global main

main:
; ------------------- Port initialization -------------------
  ldi   r16, 0x3E       ; Configure PB5..PB1 as LED outputs
  out   DDRB, r16       ; Write the LED output mask into DDRB
  ldi   r16, 0x3F       ; Configure PC5..PC0 as outputs for segments A..F
  out   DDRC, r16       ; Write the segment output mask into DDRC
  sbi   DDRD, 3         ; Configure PD3 as the output for segment G
  cbi   DDRD, 2         ; Keep PD2 as the button input
  sbi   PORTD, 2        ; Enable the internal pull-up on the button pin

; ------------------- 1. Initial state -------------------
initial_state:
  call  display_blank   ; Blank the seven-segment display
  ldi   r16, 0x2A       ; Alternating pattern: LED1, LED3, LED5 ON (PB5,PB3,PB1)
  out   PORTB, r16      ; Show the initial alternating LED pattern

; ------------------- 2. Button waiting -------------------
wait_press:
  sbis  PIND, 2         ; Skip next instruction while the button is released
  rjmp  button_pressed  ; Button pulls PD2 low -> the button was pressed
  rjmp  wait_press      ; Keep polling until the button is pressed

button_pressed:
  ldi   r25, hi8(20)    ; Load a 20 ms debounce delay high byte
  ldi   r24, lo8(20)    ; Load a 20 ms debounce delay low byte
  call  delay_ms        ; Wait for the button signal to settle
  sbis  PIND, 2         ; Confirm the button is still pressed after the debounce
  rjmp  wait_release    ; Valid press -> wait for the button to be released
  rjmp  wait_press      ; False trigger -> resume polling

wait_release:
  sbis  PIND, 2         ; Skip next instruction once the button is released
  rjmp  wait_release    ; Stay here while the button is still held down
  ldi   r25, hi8(20)    ; Load a 20 ms release debounce delay high byte
  ldi   r24, lo8(20)    ; Load a 20 ms release debounce delay low byte
  call  delay_ms        ; Let the release state settle before continuing

; ------------------- 3. Student code display phase -------------------
  ldi   r20, 5          ; Five numeric digits in student code 93642
  ldi   ZH, hi8(code_table) ; Point Z to the student-code digit table
  ldi   ZL, lo8(code_table)

display_loop:
  lpm   r21, Z+         ; Load the next digit value from the table
  call  display_digit   ; Show the digit on the seven-segment display
  mov   r22, r21        ; Copy the digit value for the odd/even test
  andi  r22, 0x01       ; Isolate the least significant bit
  breq  even_digit      ; LSB = 0 -> the digit is even
odd_digit:               ; LSB = 1 -> the digit is odd
  ldi   r16, 0x2A       ; Odd: turn on LEDs 1, 3, and 5 (PB5, PB3, PB1)
  out   PORTB, r16      ; Update the LED outputs
  rjmp  digit_hold      ; Continue to the display delay
even_digit:
  ldi   r16, 0x14       ; Even: turn on LEDs 2 and 4 (PB4, PB2)
  out   PORTB, r16      ; Update the LED outputs
digit_hold:
  ldi   r25, hi8(1000)  ; Load the ~1 second display time high byte
  ldi   r24, lo8(1000)  ; Load the ~1 second display time low byte
  call  delay_ms        ; Keep the digit visible for about 1 second
  dec   r20             ; Move to the next digit
  brne  display_loop    ; Repeat until all digits have been shown

; ------------------- 4. Running light finish phase -------------------
  call  display_blank   ; Blank the seven-segment display
  ldi   r18, 5          ; Five LED positions to light in sequence
  ldi   r17, 0x20       ; Start with LED1 (PB5)
running_light:
  out   PORTB, r17      ; Turn on only the current LED
  ldi   r25, hi8(500)   ; Load the ~0.5 second per-position delay high byte
  ldi   r24, lo8(500)   ; Load the ~0.5 second per-position delay low byte
  call  delay_ms        ; Hold the current LED position
  lsr   r17             ; Shift the lit LED one position toward PB1 (LED5)
  dec   r18             ; Count down the remaining positions
  brne  running_light   ; Continue until LED5 has been shown

; ------------------- 5. Return to waiting state -------------------
  rjmp  initial_state   ; Restore the alternating pattern and wait again

; ==============================================================================
; Subroutine: display_blank
; Turns off every segment of the seven-segment display.
; ==============================================================================
display_blank:
  ldi   r16, 0x00       ; All segment lines low
  out   PORTC, r16      ; Segments A..F off
  cbi   PORTD, 3        ; Segment G off
  ret                   ; Return to the caller

; ==============================================================================
; Subroutine: display_digit
; Shows the digit stored in r21 (0..9) on the seven-segment display.
; Reads a 7-bit pattern from seg_table using lpm:
;   bit 6 = segment G, bits 5..0 = segments F, E, D, C, B, A
; The lower 6 bits are written to PORTC, bit 6 controls segment G on PD3.
; ==============================================================================
display_digit:
  ldi   ZH, hi8(seg_table) ; Point Z to the seven-segment pattern table
  ldi   ZL, lo8(seg_table)
  add   ZL, r21         ; Offset Z by the digit value
  clr   r19             ; Clear a scratch register for carry propagation
  adc   ZH, r19         ; Propagate any carry into the high byte of Z
  lpm   r23, Z          ; Load the 7-bit segment pattern from the table
  mov   r19, r23        ; Copy the pattern for masking
  andi  r19, 0x3F       ; Keep only the six segment bits A..F
  out   PORTC, r19      ; Drive segments A..F from PORTC
  sbrc  r23, 6          ; Skip the clear instruction if bit 6 (segment G) is set
  rjmp  seg_g_on        ; Segment G must be turned on
  cbi   PORTD, 3        ; Segment G off
  ret                   ; Return to the caller
seg_g_on:
  sbi   PORTD, 3        ; Segment G on
  ret                   ; Return to the caller

; ==============================================================================
; Subroutine: delay_ms
; Delays about (r25:r24) milliseconds at 16 MHz.
; Each millisecond uses roughly 4000 inner-loop iterations of 4 CPU cycles.
; ==============================================================================
delay_ms:
  ldi   r31, hi8(4000)  ; Load the inner-loop counter high byte
  ldi   r30, lo8(4000)  ; Load the inner-loop counter low byte
delay_inner:
  sbiw  r30, 1          ; Spend four clock cycles per inner-loop pass
  brne  delay_inner     ; Stay in the inner loop until it reaches zero
  sbiw  r24, 1          ; Decrement the millisecond counter
  brne  delay_ms        ; Repeat until the whole delay has elapsed
  ret                   ; Return to the caller

; ==============================================================================
; Lookup tables stored in program memory (read with the lpm instruction)
; ==============================================================================

; Seven-segment patterns for digits 0..9
; Bit mapping: bit0=A bit1=B bit2=C bit3=D bit4=E bit5=F bit6=G
; Active-high patterns for a common-cathode display.
seg_table:
  .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

; Numeric digits of student code 93642, shown in the same order as the code.
; The trailing 0 is padding so the table keeps word alignment in flash.
code_table:
  .byte 9, 3, 6, 4, 2, 0
