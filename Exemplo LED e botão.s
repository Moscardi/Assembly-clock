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

.equ ALL_LEDS, LEFT_LED | RIGHT_LED

.equ DAY_MEMORY_ADDRESS, 0x0
.equ MONTH_MEMORY_ADDRESS, 0x1
.equ ALARM_HOUR_ADDRESS, 0x2
.equ ALARM_MINUTE_ADDRESS, 0x3
.equ YEAR_MEMORY_ADDRESS, 0x4


@Usar r1 para armazenar enderecos de memoria
@A interface via SWI se comunica via R0


@ aqui NESSE exemplo usarei R8 e R9 como controlador

.section .text

_start:
  mov r0, #0    ;coloca r0 em zero
  mov r8, #0    ;significa que o led esquerdo está apagado
  mov r9, #0    ;significa que o led direito está pagado

looping:
  swi SWI_CheckBlack      ;Move para r0 se algum botão foi apertado
  cmp r0, #1              ;Compara o valor retornado
  beq right_button        ;Caso tenha retornado 1 o botão direito foi apertado
  cmp r0, #2              ;Compara o valor retornado com 2
  beq left_button         ;Caso seja 2 o botão esquedo foi apertado
  b led_control           ;Vai para o controlador de LEDS

left_button:
  cmp r8, #0              ;Verifca se o LED esquerdo já está aceso
  moveq r8, #1            ; IF (r8 == 0) r8 = 1
  movne r8, #0            ; ELSE r8 = 0
  b led_control           ;retorna para o laço de repetição

right_button:
  cmp r9, #0              ;Verifica se o LED direito já está aceso
  moveq r9, #1            ;IF(r9 == 0) r9 = 1
  movne r9, #0            ;ELSE r9 = 0
  b led_control           ;retorna para o laço de repetição

led_control:
  cmp r8, #0              ;IF(r8 == 0 && r9 == 0)
  cmpeq r9, #0
  moveq r0, #0            ;r0 = 0 //nenhum led

  cmp r8, #1              ;IF (r8 == 1 && r9 == 0)
  cmpeq r9, #0
  moveq r0, #LEFT_LED     ;r0 = 2 //led esquerdo

  cmp r8, #0              ;IF (r8 == 0 && r9 == 1)
  cmpeq r9, #1
  moveq r0, #RIGHT_LED    ;r0 = 1 //led direito

  cmp r8, #1              ;IF(r8 == 1 && r9 == 1)
  cmpeq r9, #1
  moveq r0, #ALL_LEDS     ;r0 = 3 //todos os leds

  swi SWI_SETLED          ;atualiza a situação dos LEDS
  b looping               ; retorna ao laço de repetição
