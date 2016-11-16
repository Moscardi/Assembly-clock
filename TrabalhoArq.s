@Constantes
.section .data

.equ SWI_SETSEG8, 0x200
.equ SWI_SETLED, 0x201
.equ SWI_CheckBlack, 0x202
.equ SWI_CheckBlue, 0x203
.equ SWI_DRAW_STRING, 0x204
.equ SWI_DRAW_INT, 0x205
.equ SWI_CLEAR_DISPLAY,0x206
.equ SWI_DRAW_CHAR, 0x207
.equ SWI_CLEAR_LINE, 0x208
.equ SWI_EXIT, 0x11
.equ SWI_GetTicks, 0x6d
.equ SEG_A, 0x80
.equ SEG_B, 0x40
.equ SEG_C, 0x20
.equ SEG_D, 0x08
.equ SEG_E, 0x04
.equ SEG_F, 0x02
.equ SEG_G, 0x01
.equ SEG_P, 0x10
.equ LEFT_LED, 0x02
.equ RIGHT_LED, 0x01
.equ LEFT_BLACK_BUTTON,0x02
.equ RIGHT_BLACK_BUTTON,0x01
.equ BLUE_KEY_00, 1<<0
.equ BLUE_KEY_01, 1<<1
.equ BLUE_KEY_02, 1<<2
.equ BLUE_KEY_03, 1<<3
.equ BLUE_KEY_04, 1<<4
.equ BLUE_KEY_05, 1<<5
.equ BLUE_KEY_06, 1<<6
.equ BLUE_KEY_07, 1<<7
.equ BLUE_KEY_08, 1<<8
.equ BLUE_KEY_09, 1<<9
.equ BLUE_KEY_10, 1<<10
.equ BLUE_KEY_11, 1<<11
.equ BLUE_KEY_12, 1<<12
.equ BLUE_KEY_13, 1<<13
.equ BLUE_KEY_14, 1<<14
.equ BLUE_KEY_15, 1<<15

.equ DISPLAY_A, SEG_A | SEG_B | SEG_C | SEG_E | SEG_F | SEG_G
.equ DISPLAY_C, SEG_A | SEG_G | SEG_E | SEG_D

.equ DAY_MEMORY_ADDRESS, 0x0
.equ MONTH_MEMORY_ADDRESS, 0x1
.equ ALARM_HOUR_ADDRESS, 0x2
.equ ALARM_MINUTE_ADDRESS, 0x3
.equ YEAR_MEMORY_ADDRESS, 0x4


@Usar r1 para armazenar enderecos de memoria

.section .text

_start:
mov r0, #1; - dia
ldr r1, =DAY_MEMORY_ADDRESS
strb r0, [r1]

mov r0, #1; - mes
ldr r1, =MONTH_MEMORY_ADDRESS
strb r0, [r1]

mov r0, #2000; - ano
ldr r1, =YEAR_MEMORY_ADDRESS
str r0, [r1]

mov r0, #12; hora do alarme
ldr r1, =ALARM_HOUR_ADDRESS
strb r0, [r1]

mov r0, #30; minuto do alarme
ldr r1, =ALARM_MINUTE_ADDRESS
strb r0, [r1]

mov r5, #12; - horas
mov r6, #29; - minutos
mov r7, #45; - segundos

mov r8, #0; - cursor
mov r9, #0; - tempo do alarme

b ClockMode

LoopStart:

Wait:
swi SWI_GetTicks		;armazena em r0 o tick atual(ms)
mov r1, r0 		;backup em r1

WaitLoop:
swi SWI_GetTicks
sub r2, r0, r1 	;subtrai o tempo inicial armazenado em r1
cmp r2, #1000
blt WaitLoop

UpdateSecs:
add r7, r7, #1 ;incrementa segundos
cmp r7, #60
moveq r7, #0     ;zera segundos
bxlt r10

UpdateMinutes:
add r6, r6, #1
cmp r6, #60
moveq r6, #0      ;zera minutos
bxlt r10

UpdateHours:
add r5, r5, #1
cmp r5, #24
moveq r5, #0  ;zera horas
bxlt r10

UpdateDay:
ldr r1, =DAY_MEMORY_ADDRESS
ldrb r0, [r1]

cmp r0, #30
addlt r0, r0, #1
moveq r0, #1

str r0, [r1]
bxlt r10

UpdateMonth:
ldr r1, =MONTH_MEMORY_ADDRESS
ldrb r0, [r1]

cmp r0, #12
addlt r0, r0, #1
moveq r0, #1

str r0, [r1]
bxlt r10

UpdateYear:
ldr r1, =YEAR_MEMORY_ADDRESS
ldr r0, [r1]

add r0, r0, #1

str r0, [r1]

bx r10

@Funcoes reutilizaveis

UpdateAlarmDisplay:
mov r0, #0  ;posiciona x e y na origem (0,0)
mov r1, #0

ldr r3, =ALARM_HOUR_ADDRESS
ldrb r2, [r3]

swi SWI_DRAW_INT ;mostra hora do alarme
add r0, r0, #2 ;offset para a coordenada x de desenhar na tela

mov r2, #':
swi SWI_DRAW_CHAR
add r0, r0, #1

ldr r3, =ALARM_MINUTE_ADDRESS
ldrb r2, [r3]

swi SWI_DRAW_INT ;mostra minuto do alarme

bl DisplayCursor

b CheckButtons

UpdateClockDisplay:
mov r0, #0  ;posiciona x e y na origem (0,0)
mov r1, #0
swi SWI_CLEAR_LINE

ldr r3, =DAY_MEMORY_ADDRESS
ldrb r2, [r3]
bl FormatWithLeadingZero

mov r2, #'-
swi SWI_DRAW_CHAR
add r0, r0, #1

ldr r3, =MONTH_MEMORY_ADDRESS
ldrb r2, [r3]
bl FormatWithLeadingZero

mov r2, #'-
swi SWI_DRAW_CHAR
add r0, r0, #1

ldr r3, =YEAR_MEMORY_ADDRESS
ldr r2, [r3]
swi SWI_DRAW_INT ;mostra ano
add r0, r0, #5

mov r2, r5
bl FormatWithLeadingZero

mov r2, #':
swi SWI_DRAW_CHAR
add r0, r0, #1

mov r2, r6
bl FormatWithLeadingZero

mov r2, #':
swi SWI_DRAW_CHAR
add r0, r0, #1

mov r2, r7
bl FormatWithLeadingZero

bl DisplayCursor

CheckButtons:

CheckAlarmMinute:
ldr r1, =ALARM_MINUTE_ADDRESS
ldrb r0, [r1]
cmp r0, r6
bne CheckBlackButtons

CheckAlarmHour:
ldr r1, =ALARM_HOUR_ADDRESS
ldrb r0, [r1]
cmp r0, r5
bne CheckBlackButtons
cmp r7, #0
moveq r9, #0

CheckAlarmInterval:
cmp r9, #10
beq TurnOffAlarm
bgt CheckBlackButtons

AlarmIsRunning:
mov r9, r7
cmp r9, #0
beq TurnOnAlarm
bgt CheckBlackButtons

TurnOffAlarm:
mov r0, #0
swi SWI_SETLED
b CheckBlackButtons

TurnOnAlarm:
mov r0, #3
swi SWI_SETLED

CheckBlackButtons:
swi SWI_CheckBlack
cmp r0, #1
beq MoveCursorRight
cmp r0, #2
beq MoveCursorLeft
bal CheckNumberPad

MoveCursorLeft:
cmp r8, #0
subgt r8, r8, #1
cmp r8, #2
subeq r8, r8, #1
cmp r8, #5
subeq r8, r8, #1
cmp r8, #10
subeq r8, r8, #1
cmp r8, #13
subeq r8, r8, #1
cmp r8, #16
subeq r8, r8, #1
b LoopStart

MoveCursorRight:
cmp r8, #18
addlt r8, r8, #1
cmp r8, #2
addeq r8, r8, #1
cmp r8, #5
addeq r8, r8, #1
cmp r8, #10
addeq r8, r8, #1
cmp r8, #13
addeq r8, r8, #1
cmp r8, #16
addeq r8, r8, #1

CheckNumberPad:
swi SWI_CheckBlue
cmp r0, #0
beq LoopStart
cmp r0, #BLUE_KEY_15
beq CheckModeButton
cmplt r4, #0
beq ClockModeAdjust
bgt AlarmModeAdjust

GetNumberFromNumPad:
cmp r0, #BLUE_KEY_00
moveq r0, #0
cmpne r0, #BLUE_KEY_01
moveq r0, #1
cmpne r0, #BLUE_KEY_02
moveq r0, #2
cmpne r0, #BLUE_KEY_03
moveq r0, #3
cmpne r0, #BLUE_KEY_04
moveq r0, #4
cmpne r0, #BLUE_KEY_05
moveq r0, #5
cmpne r0, #BLUE_KEY_06
moveq r0, #6
cmpne r0, #BLUE_KEY_07
moveq r0, #7
cmpne r0, #BLUE_KEY_08
moveq r0, #8
cmpne r0, #BLUE_KEY_09
moveq r0, #9
mov pc, r14

ClockModeAdjust:
bl GetNumberFromNumPad
cmp r8, #2
blt DayAdjust
cmp r8, #5
blt MonthAdjust
cmp r8, #10
blt YearAdjust

DayAdjust:
ldr r3, =DAY_MEMORY_ADDRESS
ldrb r2, [r3]
mov r1, #10
cmp r8, #0
mlaeq r2, r0, r1, r2
strb r2, [r3]

MonthAdjust:

YearAdjust:

AlarmModeAdjust:
bl GetNumberFromNumPad
cmp r8, #2
blt HourAdjust
cmp r8, #5
blt MinuteAdjust

HourAdjust:
cmp r8, #0
cmpeq r0, #2

MinuteAdjust:

CheckModeButton:
swi SWI_CLEAR_DISPLAY
cmp r4, #0
beq AlarmMode

ClockMode:
mov r4, #0
mov r0, #DISPLAY_C
swi SWI_SETSEG8
ldr r10, =UpdateClockDisplay
b LoopStart

AlarmMode:
mov r4, #1
mov r0, #DISPLAY_A
swi SWI_SETSEG8
ldr r10, =UpdateAlarmDisplay
b LoopStart

FormatWithLeadingZero:
cmp r2, #10
bge GreaterThanTen

mov r3, r2

mov r2, #0
swi SWI_DRAW_INT
add r0, r0, #1

mov r2, r3
swi SWI_DRAW_INT
add r0, r0, #1

mov pc, r14

GreaterThanTen:
swi SWI_DRAW_INT
add r0, r0, #2
mov pc, r14

DisplayCursor:
mov r0, #1
swi SWI_CLEAR_LINE

mov r0, r8
mov r1, #1
mov r2, #'_
swi SWI_DRAW_CHAR
mov pc, r14

