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
@data: [dia][mês][ano-mil][ano-centena][ano-dezena][ano-unidade][horas][minutos][segundos]
data: .byte 31, 12, 1, 9, 9, 9, 23, 59, 50
@alarm: [Hora][Minuto][Segundo]
alarm: .byte 11, 0, 0
@month(limite de dias): [janeiro][fevereiro][maio][março][abril][junho][julho][agosto][setembro][outubro][novembro][dezembro]
month: .byte 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
@system(dados do sistema): [posição do marcador], [tempo restante de alarme], [modo do relogio], [contador do sistema], [ultimo modo], [valor digitado]
system: .byte 0, 0, 1, 0, 0, 0
@return: [retorna valores de funções]
return: .byte 0

.section .text

@r0 e r1 são X e Y da tela, não devem ser usados r0 = X e r1 = Y
@r2 é usado pela função SWI não deve ser usado
@r3 será utilizado para guardar endereços de memória
@r9 será usado como endereço de retorno de pulo para funções chamando outras funções
; é necessário dizer para onde a função deve retornar antes de chama-la
; para isso para colocar em r9 o endereço da função
@r8 será usado como armazenador interno de saltos das funções

start:
  mov r8, #0
primeiroCarregamentoDysplayHora:
  ldr r3, =system
  add r3, r3, #2
  ldrb r4, [r3]
  ldr r9, =primeiroCarregamentoDysplayTrace
  cmp r4, #1
  beq loadDysplayDate

primeiroCarregamentoDysplayTrace:
  ldr r9, =sistema
  b loadDysplayTrace

sistema:
  @aqui ficará o laço de dormir
  swi SWI_GetTicks
  mov r4, r0
  ldr r9, =sleepRepetidor
sleepRepetidor:
  swi SWI_GetTicks
  sub r0, r0, r4
  cmp r0, #1000
  bxle r9
  ldr r9, =sistema

verificaData:
  @verifica o ano bissesto
  mov r4, #0
  mov r5, #0
  ldr r3, =data
  add r3, r3, #5
  ldrb r4, [r3]
  sub r3, r3, #1
  ldrb r5, [r3]
  cmp r4, #0
  cmpeq r5, #0
  addne r6, r3, #1
  subeq r6, r3, #1
  mov r4, #0
  mov r5, #0
  mov r3, r6
  ldrb r5, [r3]
  sub r3, r3, #1
  ldrb r4, [r3]
  cmp r4, #1
  addeq r5, r5, #10
  cmp r4, #2
  addeq r5, r5, #20
  cmp r4, #3
  addeq r5, r5, #30
  cmp r4, #4
  addeq r5, r5, #40
  cmp r4, #5
  addeq r5, r5, #50
  cmp r4, #6
  addeq r5, r5, #60
  cmp r4, #7
  addeq r5, r5, #70
  cmp r4, #8
  addeq r5, r5, #80
  cmp r4, #9
  addeq r5, r5, #90

  ldr r3, =month
  add r3, r3, #1
bi:
  cmp r5, #0
  subgt r5, r5, #4
  bgt bi
  moveq r4, #29
  movlt r4, #28
  strb r4, [r3]

dateIncrement:
  @carrega o vetor data ---------------------------- AQUI INCREMENTA A DATA
  ldr r3, =data
  @carrega a 9° posição (secundo)
  add r3, r3, #8
  ldrb r4, [r3]
  @adiciona mais 1 sgundo
  add r4, r4, #1
  @compara os segundos com 60
  cmp r4, #60
  @salva os novos segundos na 9° posição do vetor
  strb r4, [r3]
  @caso seja menos de 60 segundo retorna para o start
  bxlt r9
  @caso não seja salva 0 segundos no vetor e incrementa os minutos
  mov r4, #0
  strb r4, [r3]
  sub r3, r3, #1
  ldrb r4, [r3]
  add r4, r4, #1
  @compara os minutos com 60
  cmp r4, #60
  @salva os novos minutos na °8 posição
  strb r4, [r3]
  @caso seja menos de 60 minutos vai pra start
  bxlt r9
  @caso seja 60 minutos zera eles e incrementa a hora
  mov r4, #0
  strb r4, [r3]
  sub r3, r3, #1
  ldrb r4, [r3]
  add r4, r4, #1
  @compara a hora com 24
  cmp r4, #24
  @salva a nova hora
  strb r4, [r3]
  @se for menor de 24 horas vai pro start
  bxlt r9
  @caso não seja incrementa 1 dia
  mov r4, #0
  strb r4, [r3]
  ldr r3, =data
  ldrb r4, [r3]
  add r4, r4, #1
  @carrega o mês atual
  add r3, r3, #1
  ldrb r5, [r3]
  @carrega o array de dias do mês
  ldr r3, =month
  add r3, r3, r5
  sub r3, r3, #1
  @carrega o máximo de dias do mês em r5
  ldrb r5, [r3]
  @compara o novo dia com o máximo de dias do mês
  cmp r4, r5
  @salva o novo dia
  ldr r3, =data
  strb r4, [r3]
  @se for menor ou igual que o máximo de dias do mês vai pra start
  bxle r9
  @se for maior que o máximo de dias, incrementa o mês e coloca dia 1
  mov r4, #1
  strb r4, [r3]
  add r3, r3, #1
  ldrb r4, [r3]
  add r4, r4, #1
  @compara o novo mês com 12
  cmp r4, #12
  @salva o novo mês
  strb r4, [r3]
  @se o novo mês for menor ou igual a 12 retorna pra start
  bxle r9
  @caso seja maior incrementa as unidades do ano
  mov r4, #1
  strb r4, [r3]
  ldr r3, =data
  add r3, r3, #5
  @carrega as unidades do ano
  ldrb r4, [r3]
  add r4, r4, #1
  @compara as unidades do ano com 10
  cmp r4, #10
  @salva o novo ano
  strb r4, [r3]
  @caso o novo ano seja menor que 10 vai pra start
  bxlt r9
  @caso não seja zera a unidade e incrementa as dezenas
  mov r4, #0
  strb r4, [r3]
  @carrega as dezenas do ano
  sub r3, r3, #1
  ldrb r4, [r3]
  add r4, r4, #1
  @compara as dezenas do ano com 10
  cmp r4, #10
  @salva a nova dezena do ano
  strb r4, [r3]
  @caso seja menor que 10 pula
  bxlt r9
  @caso seja maior ou igual, zera a dezena e incrementa a centena do ano
  mov r4, #0
  strb r4, [r3]
  sub r3, r3, #1
  ldrb r4, [r3]
  add r4, r4, #1
  @compara a nova centena do ano com 10
  cmp r4, #10
  @armazena a nova centena do ano
  strb r4, [r3]
  @caso seja menor que 10 pula
  bxlt r9
  @caso seja maior ou igual, zera a centena e incrementa unidade mil
  mov r4, #0
  strb r4, [r3]
  sub r3, r3, #1
  ldrb r4, [r3]
  add r4, r4, #1
  @compara a unidade mil do ano com 10
  cmp r4, #10
  @armazena a nova unidade mil do ano
  strb r4, [r3]
  @pula se for menor que 10
  bxlt r9
  @caso seja maior ou igual, zera a unidade mil do ano
  mov r4,#0
  strb r4, [r3]
  bx r9

loadDysplayDate:
  @coloca X e Y em 0
  mov r0, #0
  mov r1, #0
  @carrega o inicio do vetor de data
  ldr r3, =data
  @carrega a primeira posição do vetor (DIA)
  ldrb r4, [r3], #1
  @desenha a primeira posição do vetor (DIA)
  cmp r4, #10
  movge r2,r4
  swige SWI_DRAW_INT
  addge r0, r0, #2
  movlt r2, #0
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  movlt r2, r4
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  @desenha o traço
  mov r2, #'-'
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  @carrega a 2° posição do vetor (mês)
  ldrb r4, [r3], #1
  @desenha a 2° posição do vetor (mês)
  cmp r4, #10
  movge r2,r4
  swige SWI_DRAW_INT
  addge r0, r0, #2
  movlt r2, #0
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  movlt r2, r4
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  @desenha o traço
  mov r2, #'-'
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  @carrega a 3° posição do vetor (ANO casa dos mil)
  ldrb r2, [r3], #1
  @desenha a 3° posição do vetor (ano casa dos mil)
  swi SWI_DRAW_INT
  add r0, r0, #1
  @carrega a 4° posição do vetor (ano casa das centenas)
  ldrb r2, [r3], #1
  @desenha a 4° posição do vetor (ano casa das centans)
  swi SWI_DRAW_INT
  add r0, r0, #1
  @carrega a 5° posição do vetor (ano casa das dezenas)
  ldrb r2, [r3], #1
  @desenha a 5° posição do vetor (ano casa das dezenas)
  swi SWI_DRAW_INT
  add r0, r0, #1
  @carrega a 6° posição do vetor (ano casa das unidades)
  ldrb r2, [r3], #1
  @desenha a 6° posição do vetor (ano casa das unidades)
  swi SWI_DRAW_INT
  add r0, r0, #2
  @carrega a 7° posição do vetor (horas)
  ldrb r4, [r3], #1
  @desenha a 7° posição do vetor (horas)
  cmp r4, #10
  movge r2,r4
  swige SWI_DRAW_INT
  addge r0, r0, #2
  movlt r2, #0
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  movlt r2, r4
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  @desenha o traço
  mov r2, #':'
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  @carrega a 8° posição do vetor (horas)
  ldrb r4, [r3], #1
  @desenha a 8° posição do vetor (horas)
  cmp r4, #10
  movge r2,r4
  swige SWI_DRAW_INT
  addge r0, r0, #2
  movlt r2, #0
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  movlt r2, r4
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  @desenha o traço
  mov r2, #':'
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  @carrega a 9° posição do vetor (segundos)
  ldrb r4, [r3]
  @desenha a 9° posição do vetor (segundos)
  cmp r4, #10
  movge r2,r4
  swige SWI_DRAW_INT
  addge r0, r0, #2
  movlt r2, #0
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  movlt r2, r4
  swilt SWI_DRAW_INT
  addlt r0, r0, #1
  bx r9

goTo:
  bx r9

loadDysplayTrace:
  @aqui irá posicionar o traço alterador
  mov r0, #0
  mov r1, #1
  mov r5, #0
  ldr r3, =system
  ldrb r4, [r3]
  mov r8, r9
  ldr r9, =loadDysplayTraceRepetidor
loadDysplayTraceRepetidor:
  cmp r5, #16
  @r8 carrega o retorno correto
  moveq r9, r8
  beq goTo
  cmp r5, r4
  add r5, r5, #1
  movne r2, #' '
  moveq r2, #'_'
  swi SWI_DRAW_CHAR
  add r0, r0, #1
  bx r9
