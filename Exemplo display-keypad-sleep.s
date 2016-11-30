@Constantes
.section .data

.equ SWI_SETSEG8, 0x200         ;comando atualiza o display de 8 segmentos, acendendo todos os segmentos armazenado em R0
.equ SWI_SETLED, 0x201          ;comando acende o led cujo o endereço está em R0
.equ SWI_CheckBlack, 0x202      ;Verifica se os botões foram apertados, caso R0 seja 1, é o botão da direita, caso seja 2 é o da esquerda
.equ SWI_CheckBlue, 0x203       ;Verifica se os botões azuis foram apertados, se não forem coloca 0 em R0
.equ SWI_DRAW_STRING, 0x204
.equ SWI_DRAW_INT, 0x205        ;Desenha um inteiro no display, desde que colocado em um registrador
.equ SWI_CLEAR_DISPLAY,0x206
.equ SWI_DRAW_CHAR, 0x207       ;Comando desenha o char na tela cujo o endereço está em R2 e a posição da letra está em r0
.equ SWI_CLEAR_LINE, 0x208      ;Apaga a linha contida em R0 e a seleciona para imprimir novos caracteres
.equ SWI_EXIT, 0x11
.equ SWI_GetTicks, 0x6d         ;Pega os ticks de execução do sistema
.equ SEG_A, 0x80                ;Segmentos do display de 8 segmentos (segmento horizontal superior)
.equ SEG_B, 0x40                ;Segmentos do display de 8 segmentos (segmento vertical superior direito)
.equ SEG_C, 0x20                ;Segmentos do display de 8 segmentos (segmento vertical inferior direito)
.equ SEG_D, 0x08                ;Segmentos do display de 8 segmentos (segmento horizontal inferior)
.equ SEG_E, 0x04                ;Segmentos do display de 8 segmentos (segmento vertical inferior esquerdo)
.equ SEG_F, 0x02                ;Segmentos do display de 8 segmentos (segmento horizontal central)
.equ SEG_G, 0x01                ;Segmentos do display de 8 segmentos (segmento vertical superior esquerdo)
.equ SEG_P, 0x10                ;Segmentos do display de 8 segmentos (segmento do ponto)
.equ LEFT_LED, 0x02             ;Endereço do Led esquerdo
.equ RIGHT_LED, 0x01            ;Endereço do LED direito
.equ LEFT_BLACK_BUTTON,0x02     ;Endereço do botão esquerdo
.equ RIGHT_BLACK_BUTTON,0x01    ;ENdereço do botão direito
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

.equ DISPLAY_1, SEG_B | SEG_C
.equ DISPLAY_2, SEG_A | SEG_B | SEG_D | SEG_E | SEG_F
.equ DISPLAY_3, SEG_A | SEG_B | SEG_C | SEG_D | SEG_F
.equ DISPLAY_4, SEG_G | SEG_F | SEG_B | SEG_C
.equ DISPLAY_5, SEG_A | SEG_G | SEG_F | SEG_C | SEG_D
.equ DISPLAY_6, SEG_A | SEG_G | SEG_F | SEG_C | SEG_D | SEG_E
.equ DISPLAY_7, SEG_A | SEG_B | SEG_C
.equ DISPLAY_8, SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_F | SEG_G
.equ DISPLAY_9, SEG_A | SEG_B | SEG_C | SEG_D | SEG_F | SEG_G
.equ DISPLAY_0, SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_G

.equ ALL_LEDS, LEFT_LED | RIGHT_LED

.equ DAY_MEMORY_ADDRESS, 0x0
.equ MONTH_MEMORY_ADDRESS, 0x1
.equ ALARM_HOUR_ADDRESS, 0x2
.equ ALARM_MINUTE_ADDRESS, 0x3
.equ YEAR_MEMORY_ADDRESS, 0x4

@Usar r1 para armazenar enderecos de memoria
@A interface via SWI se comunica via R0

.section .text

_start:
  @NESSE exemplo irei usar r3 para contar o número de atualiazações sem interação do programa
  @NESSE exemplo irei usar o r4 como tempo incial e R5 como tempo final
  mov r3, #0              ;Aqui zero o atualizador do programa
  mov r0, #0              ;Aqui zero R0 por segurança
  swi SWI_CLEAR_LINE      ; A partir daqui escrevo a palavra "Button: "
  mov r2, #'B             ;B (0)
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  mov r2, #'u             ;u (1)
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  mov r2, #'t             ;t (2)
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  mov r2, #'t             ;t (3)
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  mov r2, #'o             ;o (4)
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  mov r2, #'n             ;n (5)
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  mov r2, #':             ;: (6)
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  mov r2, #' '            ; (7)
  swi SWI_DRAW_CHAR

write_nenhum:             ;A partir daqui escrevo a a palavra "nenhum" a depois daquela palavra
  mov r0, #8
  mov r2, #'n             ;n (8)
  swi SWI_DRAW_CHAR
  add r0, r0 , #1
  mov r2, #'e             ;e (9)
  swi SWI_DRAW_CHAR
  add r0, r0 , #1
  mov r2, #'n             ;n (10)
  swi SWI_DRAW_CHAR
  add r0, r0 , #1
  mov r2, #'h             ;h (11)
  swi SWI_DRAW_CHAR
  add r0, r0 , #1
  mov r2, #'u             ;u (12)
  swi SWI_DRAW_CHAR
  add r0, r0 , #1
  mov r2, #'m             ;m (13)
  swi SWI_DRAW_CHAR

start_looping:            ;Aqui inicio o looping do programa
  add r3, r3, #1          ; incremento em 1 o número de atualizações sem interação do programa
  swi SWI_CheckBlue       ;verifico se alguma tecla foi pressionada e coloca em R0
  cmp r0, #0              ;caso r0 seja igual a 0 nenhuma tecla foi apertada
    movne r3, #0          ;caso tenha sido apertada zero o número de atualização sem intereção
    bne get_num_pad       ;caso tenha sido apertado, pulo para parte que verifica e escreve qual número foi pressionado
  swi SWI_GetTicks        ;caso nínguem tenha precionado nada eu pego o tempo do sistema
  mov r4, r0              ; movo o tempo do sistema para r4
  b sleep                 ; pulo para o sleep

end_looping:
  cmp r3, #15              ;aqui vejo se o programa foi atualizado 8 vezes sem nenhum botão ser precionado
    movge r3, #0          ;caso sim eu zero o contador de interação
    bge write_nenhum      ;e pulo para parte que escrevo "nenhum"
  b start_looping

sleep:
  swi SWI_GetTicks      ;pego novamente o tempo
  mov r5, r0            ;e o coloco em r5
  sub r5, r5, r4        ;subtraio o tempo final e o inicial
  cmp r5, #100          ;comparo com 250 micro segundo
  ble sleep             ; caso seja menor ou igual repito o processo indo pra sleep
  bgt end_looping       ;caso seja maior pulo para end_looping (logo acima)

remove_nenhum:          ;aqui removo as letras que sobraram da palavra "nenhum"
  cmp r0, #14           ;r0 armazena a ultima posição em que algo foi escrito
    addlt r0, r0, #1    ;caso seja menor que 14 soma 1 na posição
    movlt r2, #' '      ;caso seja menor que 14 substitui a nova posição por ' '
    swilt SWI_DRAW_CHAR ;caso seja menor que 14 imprime no display
    blt remove_nenhum   ;caso seja menor que 14 repete o processo
    bge start_looping   ;caso seja maior que 14 retorna pro inicio do looping

get_num_pad:            ;Aqui verifico 1 a 1 qual tecla foi precionada e escrevo seu número na tela
  cmp r0, #BLUE_KEY_00  ;depois disso pulo para remove_nenhum
    moveq r0, #8
    moveq r2, #0
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #0
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_01
    moveq r0, #8
    moveq r2, #0
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #1
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_02
    moveq r0, #8
    moveq r2, #0
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #2
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_03
    moveq r0, #8
    moveq r2, #0
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #3
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_04
    moveq r0, #8
    moveq r2, #1
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #0
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_05
    moveq r0, #8
    moveq r2, #1
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #1
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_06
    moveq r0, #8
    moveq r2, #1
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #2
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_07
    moveq r0, #8
    moveq r2, #1
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #3
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_08
    moveq r0, #8
    moveq r2, #2
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #0
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_09
    moveq r0, #8
    moveq r2, #2
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #1
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_10
    moveq r0, #8
    moveq r2, #2
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #2
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_11
    moveq r0, #8
    moveq r2, #2
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #3
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_12
    moveq r0, #8
    moveq r2, #3
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #0
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_13
    moveq r0, #8
    moveq r2, #3
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #1
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_14
    moveq r0, #8
    moveq r2, #3
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #2
    swieq SWI_DRAW_INT
    beq remove_nenhum
  cmp r0, #BLUE_KEY_15
    moveq r0, #8
    moveq r2, #3
    swieq SWI_DRAW_INT
    addeq r0, r0, #1
    moveq r2, #'.
    swieq SWI_DRAW_CHAR
    addeq r0, r0, #1
    moveq r2, #3
    swieq SWI_DRAW_INT
    beq remove_nenhum
  b start_looping
