@Constantes
.section .data

.equ SWI_SETSEG8, 0x200         ;comando atualiza o display de 8 segmentos, acendendo todos os segmentos armazenado em R0
.equ SWI_SETLED, 0x201          ;comando acende o led cujo o endereço está em R0
.equ SWI_CheckBlack, 0x202      ;Verifica se os botões foram apertados, caso R0 seja 1, é o botão da direita, caso seja 2 é o da esquerda
.equ SWI_CheckBlue, 0x203       ;Verifica se os botões azuis foram apertados, se não forem coloca 0 em R0
.equ SWI_DRAW_STRING, 0x204
.equ SWI_DRAW_INT, 0x205        ;Desenha um inteiro no display, desde que colocado em um registrador
.equ SWI_CLEAR_DISPLAY,0x206
.equ SWI_DRAW_CHAR, 0x207       ;Comando desenha o char na tela cujo o endereço está em R0
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

.equ DAY_MEMORY_ADDRESS, 0x0
.equ MONTH_MEMORY_ADDRESS, 0x1
.equ ALARM_HOUR_ADDRESS, 0x2
.equ ALARM_MINUTE_ADDRESS, 0x3
.equ YEAR_MEMORY_ADDRESS, 0x4


@Usar r1 para armazenar enderecos de memoria
@A interface via SWI se comunica via R0

.section .text

_start:
  mov r0, #SEG_A      ;move o endereço do segmento A para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #SEG_B      ;move o endereço do segmento B para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #SEG_C      ;move o endereço do segmento C para R0
  swi SWI_SETSEG8     ;mostra r0

  mov r0, #SEG_D      ;move o endereço do segmento D para R0
  swi SWI_SETSEG8     ;mostra r0

  mov r0, #SEG_E      ; move o endereço do segmento E para R0
  swi SWI_SETSEG8     ;mostra r0

  mov r0, #SEG_F      ;move o endereço do segmento F para R0
  swi SWI_SETSEG8     ;mostra R0

  mov r0, #SEG_G      ;move o endereço do segmento G para R0
  swi SWI_SETSEG8     ;mostra R0

  mov r0, #SEG_P      ;move o endereço do segmento P para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_A  ;move o endereço dos segmento para forma a letra A para R0
  swi SWI_SETSEG8     ;mostra R0

  mov r0, #DISPLAY_C  ;move os endereços dos segmentos para formar a letra C para R0
  swi SWI_SETSEG8     ;mostra R0

  mov r0, #DISPLAY_1  ;Move os endereços dos segmentos para formar 1 para R0
  swi SWI_SETSEG8     ;mostra R0

  mov r0, #DISPLAY_2  ;Move os endereços dos segmentos para formar 2 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_3  ;Move os endereços dos segmentos para formar 3 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_4  ;Move os endereços dos segmentos para formar 4 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_5  ;Move os endereços dos segmentos para formar 5 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_6  ;Move os endereços dos segmentos para formar 6 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_7  ;Move os endereços dos segmentos para formar 7 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_8  ;Move os endereços dos segmentos para formar 8 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_9  ;Move os endereços dos segmentos para formar 9 para R0
  swi SWI_SETSEG8     ;Mostra R0

  mov r0, #DISPLAY_0  ;Move os endereços dos segmentos para formar 0 para R0
  swi SWI_SETSEG8     ;Mostra R0
