#define __SFR_OFFSET 0

#include "avr/io.h"

.global main

main:
  sbi   DDRB, 0         ; Configure PB0 (digital pin 8) as output

blink:
  sbi   PINB, 0         ; Toggle PB0 by writing to the PIN register
  ldi   r25, hi8(1000)  ; Load 1000ms delay high byte
  ldi   r24, lo8(1000)  ; Load 1000ms delay low byte
  call  delay_ms        ; Wait before the next toggle
  rjmp  blink           ; Repeat forever

delay_ms:
                        ; Delay about (r25:r24) milliseconds at 16MHz
  ldi   r31, hi8(4000)  ; Load the inner-loop counter high byte
  ldi   r30, lo8(4000)  ; Load the inner-loop counter low byte
delay_inner:
  sbiw  r30, 1          ; Consume four CPU cycles per iteration
  brne  delay_inner     ; Stay in the inner loop until it reaches zero
  sbiw  r24, 1          ; Decrement the millisecond counter
  brne  delay_ms        ; Repeat until the requested delay elapsed
  ret                   ; Return to the caller
  