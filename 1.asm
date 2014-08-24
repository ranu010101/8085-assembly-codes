

;<Program title>

jmp start

;data

;INPUT DATA 8  FROM BIT9291 AND 9292 LOCATION
READ8: NOP
LXI H, 9291h
MOV B, M
LXI H, 9292h
MOV C, M
MOV H, C
MVI C, 0
MVI L, 0
RET

;VARIANT READER
READDASH8: NOP
LXI H, 9292h
MOV B, M
LXI H, 9291h
MOV C, M
MOV L, C
MVI C, 0
MVI H, 0
RET

;INPUT DATA 16-BIT FROM 9293(9294) AND 9295(9296)LOCATION
READ16: NOP
CALL RESET
LXI H, 9293h
MOV B, M
LXI H, 9294h
MOV C, M
LXI H, 9295h
MOV D, M
LXI H, 9296h
MOV E, M
XCHG
LXI D, 0
MVI A, 0
RET

;ADD EIGHT TIMES FOR 8-BIT MULTIPLICATION
ADDEREIGHT: NOP
ADD B
DCR H
JNZ ADDEREIGHT
MOV H, A
RET

;ADD 16-BIT INTEGERS
ADDER16: NOP
CALL RESET 
CALL READ16
DAD B
CALL RESETH
RET

;ADD EIGHT BIT INTEGERS
ADDER8: NOP
CALL RESET
CALL READ8
MOV A, H
ADD B
MOV H, A
CALL RESETH
Rst 5

;SUBTRACT EIGHT BIT INTEGERS
SUB8: NOP 
CALL RESET
CALL READ8
MOV A, H
SUB B
MOV H, A
CALL RESETH
Rst 5

;COMPARE PART OF 16-BIT MULTIPLIER
COMPARE: NOP
CMP B
JNZ ADDERSIXTEEN
RET 

;ADD 16 TIMES FOR 16-BIT MULTIPLICATION
ADDERSIXTEEN: NOP
DAD D
DCX B
CMP C
JNZ ADDERSIXTEEN
JZ COMPARE
RET

;RESET ALL REGISTERS
RESET: NOP
MVI A, 0
LXI H, 0
LXI B, 0
LXI D, 0
RET 

;RESET ALL EXCEPT H & L
RESETH: NOP
MVI A, 0
LXI B, 0
LXI D, 0
RET 

;MULTIPY 8 BIT INTEGERS
MULTIPLY8: NOP
CALL RESET
CALL READ8
CALL ADDEREIGHT
CALL RESETH
Rst 5

;MULTIPLY 16 BITS
MULTIPLY16: NOP
CALL RESET
CALL READ16
XCHG
CALL ADDERSIXTEEN
CALL RESETH
Rst 5

;SELECT OPERATION TO PERFORM
SELECTOPERATION: NOP
CPI 0
JZ MULTIPLY8
CPI 1
JZ MULTIPLY16
CPI 2
JZ ADDER8
CPI 3
JZ ADDER16
CPI 4
JZ SUB8
CPI 5
JZ subtract16
CPI 6
JZ divide
CPI 7
JZ divide16
CPI 8
JZ mod8
CPI 9
JZ mod16
RET

;MOD 8-BIT
mod8: nop
CALL RESET
CALL READDASH8
call shift
call shift
call shift
call shift
call shift
call shift
call shift
call shift
call RESETH
rst 5

;SUBTRACT-16
subtract16: nop
CALL RESET
CALL READ16
mov a,l
sub c
mov l,a
mov a,h
sbb b
mov h,a
CALL RESETH
Rst 5

;DIVIDE-16
subtractdash16: nop
mov a,l
sub c
mov l,a
mov a,h
sbb b
mov h,a
ret

divide16: nop
CALL RESET
CALL READ16
while: nop
inx d
call subtractdash16
jnc while
dcx d
XCHG
rst 5

;MOD 16-BIT
mod16: nop
CALL RESET
CALL READ16
while1: nop
call subtractdash16
jnc while1
dad b
call RESETH
rst 5

;DIVISION 8-BIT
inc_quo: nop
mov h,a
mov a,c
add a
adi 0001h
mov c,a
ret

shift: nop
dad h
mov a,h
sub b
jnc inc_quo
mov a,c
add c
mov c,a
ret

divide: nop
CALL RESET
CALL READDASH8
call shift
call shift
call shift
call shift
call shift
call shift
call shift
call shift
MOV H, C
CALL RESETH
Rst 5

;code
start: nop

;SELECT OPERATION TYPE

LXI H, 9290h
MOV A, M

;SELECT OPERATION TO PERFORM
CALL SELECTOPERATION

Rst 5