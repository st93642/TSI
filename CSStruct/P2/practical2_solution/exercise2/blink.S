; Exercise 2
; Create a running-lights effect on Arduino Uno pins 13..9 (PB5..PB1).

#define __SFR_OFFSET 0

#include "avr/io.h"

.global main

main:
  ldi   r16, 0x3E   ; Configure PB5..PB1 as LED outputs.
  out   DDRB, r16   ; Write the output mask into DDRB.
  ldi   r17, 0x20   ; Start with the LED on PB5 (digital pin 13).

run_lights:
  out   PORTB, r17  ; Show the current running-light position.
  ldi   r25, hi8(250) ; Load a 250ms pause high byte.
  ldi   r24, lo8(250) ; Load a 250ms pause low byte.
  call  delay_ms    ; Keep the current LED on for the same time.
  lsr   r17         ; Move the lit LED one position toward PB1.
  cpi   r17, 0x01   ; Check whether the shift moved outside PB1..PB5.
  brne  run_lights  ; Continue if a valid LED bit is still set.
  ldi   r17, 0x20   ; Restart from PB5 after PB1 was displayed.
  rjmp  run_lights  ; Repeat forever.

delay_ms:
  ; Delay about (r25:r24) milliseconds at 16MHz.
  ldi   r31, hi8(4000) ; Load the inner-loop counter high byte.
  ldi   r30, lo8(4000) ; Load the inner-loop counter low byte.
delay_inner:
  sbiw  r30, 1      ; Spend four clock cycles per inner-loop pass.
  brne  delay_inner ; Stay here until the inner loop reaches zero.
  sbiw  r24, 1      ; Decrement the millisecond counter.
  brne  delay_ms    ; Repeat until the whole delay elapsed.
  ret               ; Return to the caller.