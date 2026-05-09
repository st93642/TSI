; Exercise 4
; Countdown on a 7-segment display with reset button and buzzer.

#define __SFR_OFFSET 0

#include "avr/io.h"

.global main

main:
  ldi   r18, 0x3F   ; Configure PB0..PB5 as outputs for segments A..F.
  out   DDRB, r18   ; Enable the six Port B segment outputs.
  sbi   DDRD, 3     ; Configure PD3 as the output for segment G.
  sbi   DDRD, 4     ; Configure PD4 as the buzzer output.
  cbi   DDRD, 2     ; Keep PD2 as the reset-button input.
  sbi   PORTD, 2    ; Enable the internal pull-up on the button pin.
  cbi   PORTD, 3    ; Start with segment G turned off.
  cbi   PORTD, 4    ; Start with the buzzer turned off.
  ldi   r16, 9      ; Load the initial digit value.

show_digit:
  call  display_digit ; Update the 7-segment display for the current digit.
  cpi   r16, 0      ; Check whether the countdown reached zero.
  breq  alarm_mode  ; Start the alarm when digit 0 is displayed.
  ldi   r19, 100    ; Build a 1 second pause from 100 x 10ms slices.

wait_second:
  ldi   r25, hi8(10) ; Load a 10ms delay high byte.
  ldi   r24, lo8(10) ; Load a 10ms delay low byte.
  call  delay_ms    ; Wait for one time slice.
  sbis  PIND, 2     ; Skip next instruction if the button is not pressed.
  rjmp  reset_counter ; Reset immediately when the button is pressed.
  dec   r19         ; Count down one 10ms slice.
  brne  wait_second ; Stay here until 1 second elapsed.
  dec   r16         ; Move to the next digit in the countdown.
  rjmp  show_digit  ; Refresh the display with the new digit.

reset_counter:
  cbi   PORTD, 4    ; Silence the buzzer before restarting.

wait_reset_release:
  sbis  PIND, 2     ; Skip next instruction after the button is released.
  rjmp  wait_reset_release ; Wait until the reset button is released.
  ldi   r16, 9      ; Restore the start digit.
  rjmp  show_digit  ; Start the countdown from the beginning.

alarm_mode:
  ; The display already shows 0 here, so only the buzzer loop is needed.
alarm_loop:
  sbis  PIND, 2     ; Skip next instruction while the button is released.
  rjmp  reset_counter ; Reset the countdown when the button is pressed.
  sbi   PORTD, 4    ; Drive the buzzer output high.
  ldi   r25, hi8(1) ; Load the high byte for a 1ms half-period.
  ldi   r24, lo8(1) ; Load the low byte for a 1ms half-period.
  call  delay_ms    ; Keep the buzzer high briefly.
  cbi   PORTD, 4    ; Drive the buzzer output low.
  ldi   r25, hi8(1) ; Reload the high byte for the low half-period.
  ldi   r24, lo8(1) ; Reload the low byte for the low half-period.
  call  delay_ms    ; Keep the buzzer low briefly.
  rjmp  alarm_loop  ; Continue the alarm until reset.

display_digit:
  cpi   r16, 0      ; Compare the current digit with 0.
  breq  digit_0     ; Branch when the display should show 0.
  cpi   r16, 1      ; Compare the current digit with 1.
  breq  digit_1     ; Branch when the display should show 1.
  cpi   r16, 2      ; Compare the current digit with 2.
  breq  digit_2     ; Branch when the display should show 2.
  cpi   r16, 3      ; Compare the current digit with 3.
  breq  digit_3     ; Branch when the display should show 3.
  cpi   r16, 4      ; Compare the current digit with 4.
  breq  digit_4     ; Branch when the display should show 4.
  cpi   r16, 5      ; Compare the current digit with 5.
  breq  digit_5     ; Branch when the display should show 5.
  cpi   r16, 6      ; Compare the current digit with 6.
  breq  digit_6     ; Branch when the display should show 6.
  cpi   r16, 7      ; Compare the current digit with 7.
  breq  digit_7     ; Branch when the display should show 7.
  cpi   r16, 8      ; Compare the current digit with 8.
  breq  digit_8     ; Branch when the display should show 8.
  ldi   r18, 0x2F   ; Load the Port B pattern for digit 9.
  out   PORTB, r18  ; Enable segments A, B, C, D, and F.
  sbi   PORTD, 3    ; Turn on segment G.
  ret               ; Return to the caller.

digit_0:
  ldi   r18, 0x3F   ; Load the Port B pattern for digit 0.
  out   PORTB, r18  ; Enable segments A..F.
  cbi   PORTD, 3    ; Turn segment G off.
  ret               ; Return to the caller.

digit_1:
  ldi   r18, 0x06   ; Load the Port B pattern for digit 1.
  out   PORTB, r18  ; Enable segments B and C.
  cbi   PORTD, 3    ; Turn segment G off.
  ret               ; Return to the caller.

digit_2:
  ldi   r18, 0x1B   ; Load the Port B pattern for digit 2.
  out   PORTB, r18  ; Enable segments A, B, D, and E.
  sbi   PORTD, 3    ; Turn segment G on.
  ret               ; Return to the caller.

digit_3:
  ldi   r18, 0x0F   ; Load the Port B pattern for digit 3.
  out   PORTB, r18  ; Enable segments A, B, C, and D.
  sbi   PORTD, 3    ; Turn segment G on.
  ret               ; Return to the caller.

digit_4:
  ldi   r18, 0x26   ; Load the Port B pattern for digit 4.
  out   PORTB, r18  ; Enable segments B, C, and F.
  sbi   PORTD, 3    ; Turn segment G on.
  ret               ; Return to the caller.

digit_5:
  ldi   r18, 0x2D   ; Load the Port B pattern for digit 5.
  out   PORTB, r18  ; Enable segments A, C, D, and F.
  sbi   PORTD, 3    ; Turn segment G on.
  ret               ; Return to the caller.

digit_6:
  ldi   r18, 0x3D   ; Load the Port B pattern for digit 6.
  out   PORTB, r18  ; Enable segments A, C, D, E, and F.
  sbi   PORTD, 3    ; Turn segment G on.
  ret               ; Return to the caller.

digit_7:
  ldi   r18, 0x07   ; Load the Port B pattern for digit 7.
  out   PORTB, r18  ; Enable segments A, B, and C.
  cbi   PORTD, 3    ; Turn segment G off.
  ret               ; Return to the caller.

digit_8:
  ldi   r18, 0x3F   ; Load the Port B pattern for digit 8.
  out   PORTB, r18  ; Enable segments A..F.
  sbi   PORTD, 3    ; Turn segment G on.
  ret               ; Return to the caller.

delay_ms:
  ; Delay about (r25:r24) milliseconds at 16MHz.
  ldi   r31, hi8(4000) ; Load the inner-loop counter high byte.
  ldi   r30, lo8(4000) ; Load the inner-loop counter low byte.
delay_inner:
  sbiw  r30, 1      ; Spend four clock cycles per inner-loop pass.
  brne  delay_inner ; Stay in the inner loop until it reaches zero.
  sbiw  r24, 1      ; Decrement the millisecond counter.
  brne  delay_ms    ; Repeat until the whole delay elapsed.
  ret               ; Return to the caller.