init:       ; Tom Nardi, 2022 (dice-roll) / Brett Walach (Technobly) - Walk Animation
mov r0, 2   ; Set matrix page
mov [0xF0], r0

mov r0, 4   ; Set CPU speed
mov [0xF1], r0

mov r8, 0   ; Init index counter
mov r1, 0   ;  |

mov r2, 0b0001 ; Store input bit 0 mask

main:
gosub disableoutput ; Disable output while input bit 0 is low
gosub inc_ani       ; Increment animation
gosub drawframe     ; Start drawing routine
gosub delay         ; delay a bit
gosub delayautooff  ; delay auto-off
goto main

disableoutput:
and IN, r2 ; return if input bit 0 is high
skip z, 1
ret r0, 0

mov r0, 4   ; go to empty page
mov [0xF0], r0 
mov r0, [0xF3] ; turn off status leds
or r0, 0b1100
mov [0xF3], r0

disableoutput_loop:
and IN, r2
skip nz, 1
jr disableoutput_loop

mov r0, 2   ; go to display page
mov [0xF0], r0
mov r0, [0xF3] ; turn on status leds
and r0, 0b0011
mov [0xF3], r0

inc_ani:    ; Increment animation index
inc r8      ;
inc r8      ;
mov r1, r8  ; Copy R8 to R1
ret r0, 0   ; Return from sub

drawframe:
mov pch, 2  ; Set high jump coord
mov pcm, r1 ; Mid address maps to die face
mov jsr, 0  ; Execute jump with lowest nibble, R0 now loaded with 4 bits

mov r7, 0   ; Init counter
mov r5, 0   ; Set initial row
mov r3, 2   ; Set right matrix page
mov r4, 3   ; Set left matrix page

drawframe_loop:
mov [r3:r5], r0 ; Draw right-side nibble
inc jsr     ; Inc lowest bit reads next nibble
mov [r4:r5], r0 ; Draw left-side nibble
inc r7      ; Inc counter
mov r0, r7  ; Move counter, can only compare to R0
cp r0, 0    ; Check if we've looped 16 times (overflow to 0)
skip z, 3   ; Skip next 3 lines if true
inc r5      ; Move to next row
inc jsr     ; Read next nibble
jr drawframe_loop       ; Loop around
ret r0, 0   ; Return from sub

; count to 8
delay:
mov r0, 0
mov r1, 0
inc r0
cp r0,8
skip z,1
jr -4
inc r1
mov r0, r1
cp r0, 8
skip z,1
jr -9

delayautooff:
mov r0, 0b1111
mov [0xF9], r0
ret r0, 0

org 0x200
walkgfx:    ; Graphics data
    BYTE    0b00000000  ; CONTACT
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b01111100
    BYTE    0b10111010
    BYTE    0b10111001
    BYTE    0b10111001
    BYTE    0b10111001
    BYTE    0b10101001
    BYTE    0b10010001
    BYTE    0b00011000
    BYTE    0b00100100
    BYTE    0b01000100
    BYTE    0b10000110
    BYTE    0b11100100

    BYTE    0b00000000  ; LOW
    BYTE    0b00000000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b01111100
    BYTE    0b10111100
    BYTE    0b10111010
    BYTE    0b10111010
    BYTE    0b10111010
    BYTE    0b10101001
    BYTE    0b10010000
    BYTE    0b00111000
    BYTE    0b01001000
    BYTE    0b10001000
    BYTE    0b10001100

    BYTE    0b00000000  ; PASSING
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00101000
    BYTE    0b00101000
    BYTE    0b00011000
    BYTE    0b00110000
    BYTE    0b01010000
    BYTE    0b01010000
    BYTE    0b00011000

    BYTE    0b00111000  ; HIGH
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b00111000
    BYTE    0b01111000
    BYTE    0b10111000
    BYTE    0b10111000
    BYTE    0b10111000
    BYTE    0b10101000
    BYTE    0b00101100
    BYTE    0b00101000
    BYTE    0b00100100
    BYTE    0b01000010
    BYTE    0b01000010
    BYTE    0b01000011
    BYTE    0b00100000

    BYTE    0b00000000  ; CONTACT
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b00111000
    BYTE    0b01111000
    BYTE    0b10111000
    BYTE    0b10111000
    BYTE    0b10111100
    BYTE    0b10101010
    BYTE    0b10101000
    BYTE    0b00100100
    BYTE    0b00100100
    BYTE    0b01000010
    BYTE    0b10000011
    BYTE    0b11000010

    BYTE    0b00000000  ; LOW
    BYTE    0b00000000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00101000
    BYTE    0b00100100
    BYTE    0b00100100
    BYTE    0b11000010
    BYTE    0b10000010
    BYTE    0b00000011

    BYTE    0b00000000  ; PASSING
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00111000
    BYTE    0b00101000
    BYTE    0b00011000
    BYTE    0b00111000
    BYTE    0b11010000
    BYTE    0b10001000
    BYTE    0b00001000
    BYTE    0b00001100

    BYTE    0b00111000 ; HIGH
    BYTE    0b00111000
    BYTE    0b00100000
    BYTE    0b01111000
    BYTE    0b10111100
    BYTE    0b10111100
    BYTE    0b10111010
    BYTE    0b10111010
    BYTE    0b10101010
    BYTE    0b10101010
    BYTE    0b00010000
    BYTE    0b00101000
    BYTE    0b00100100
    BYTE    0b00100100
    BYTE    0b00100110
    BYTE    0b00110000

; EOF
