
;<Program title>

; REQUIRED T STATES
; = 10ms/.333us
; = 30030 T STATES
; SO WE CAN SAY VALUE OF COUNT HERE WILL BE HIGH
; THEREFORE TAKING A REGISTER PAIR AS A COUNTER
jmp start;

DELAY1S: NOP

                    MVI C, 0AH
LOOP:         MVI D, 64H
LOOP1:       MVI E, 0DEH
LOOP2:       DCR E
JNZ LOOP2
DCR D
JNZ LOOP1
DCR C
JNZ LOOP
RET 

;code
start: nop

CALL DELAY1S

hlt