#define __SFR_OFFSET 0

#include "avr/io.h"

.global main

; LED patterns on PORTB bits PB5..PB1
; LED1=PB5, LED2=PB4, LED3=PB3, LED4=PB2, LED5=PB1
.equ LED_ODD,    0x2A   ; LEDs 1,3,5 ON
.equ LED_EVEN,   0x14   ; LEDs 2,4 ON
.equ LED_RUN_1,  0x20   ; running-light start at LED1
.equ DIGIT_COUNT, 5

main:
; Port initialization
  ldi   r16, 0x3E
  out   DDRB, r16
  ldi   r16, 0x3F
  out   DDRC, r16
  sbi   DDRD, 3
  cbi   DDRD, 2
  sbi   PORTD, 2

; Initial state
initial_state:
  call  display_blank
  ldi   r16, LED_ODD
  out   PORTB, r16

; Button waiting
wait_press:
  sbis  PIND, 2
  rjmp  button_pressed
  rjmp  wait_press

button_pressed:
  ldi   r25, hi8(20)
  ldi   r24, lo8(20)
  call  delay_ms
  sbis  PIND, 2
  rjmp  wait_release
  rjmp  wait_press

wait_release:
  sbis  PIND, 2
  rjmp  wait_release
  ldi   r25, hi8(20)
  ldi   r24, lo8(20)
  call  delay_ms

; Student code display phase
  ldi   r20, DIGIT_COUNT
  ldi   ZH, hi8(code_table)
  ldi   ZL, lo8(code_table)

display_loop:
  lpm   r21, Z+
  call  display_digit
  mov   r22, r21
  andi  r22, 0x01
  breq  even_digit
odd_digit:
  ldi   r16, LED_ODD
  out   PORTB, r16
  rjmp  digit_hold
even_digit:
  ldi   r16, LED_EVEN
  out   PORTB, r16
digit_hold:
  ldi   r25, hi8(1000)
  ldi   r24, lo8(1000)
  call  delay_ms
  dec   r20
  brne  display_loop

; Running light finish phase
  call  display_blank
  ldi   r18, DIGIT_COUNT
  ldi   r17, LED_RUN_1
running_light:
  out   PORTB, r17
  ldi   r25, hi8(500)
  ldi   r24, lo8(500)
  call  delay_ms
  lsr   r17
  dec   r18
  brne  running_light

; Return to waiting state
  rjmp  initial_state

; Subroutine: display_blank
; Turns off every segment of display
display_blank:
  ldi   r16, 0x00
  out   PORTC, r16
  cbi   PORTD, 3
  ret

; Subroutine: display_digit — show r21 (0-9) on 7-seg
; Saves and restores Z so callers Z is preserved
display_digit:
  push  r30
  push  r31
  ldi   ZH, hi8(seg_table)
  ldi   ZL, lo8(seg_table)
  add   ZL, r21
  clr   r19
  adc   ZH, r19
  lpm   r23, Z
  mov   r19, r23
  andi  r19, 0x3F
  out   PORTC, r19
  sbrc  r23, 6
  rjmp  seg_g_on
  cbi   PORTD, 3
  pop   r31
  pop   r30
  ret
seg_g_on:
  sbi   PORTD, 3
  pop   r31
  pop   r30
  ret

; Subroutine: delay_ms
delay_ms:
  ldi   r29, hi8(4000)
  ldi   r28, lo8(4000)
delay_inner:
  sbiw  r28, 1
  brne  delay_inner
  sbiw  r24, 1
  brne  delay_ms
  ret

; Seven-segment patterns for digits 0..9
; Bit mapping: bit0=A bit1=B bit2=C bit3=D bit4=E bit5=F bit6=G
seg_table:
  .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
code_table:
  .byte 9, 3, 6, 4, 2
