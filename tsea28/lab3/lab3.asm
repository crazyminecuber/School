;*******************************
;*
;* Malldokument Lab2 i Datorteknik Y (Darma)
;*
;* KPa 180212
;*     180219 Fix initGPIOE, GPIODATA def
;*     180301 Move definitions to top of file, use only english comments
;*     190213 Update definitions to use .equ/mov/movt instead of .field/ldr
;* OAn 200131 Last line in interrupt printout different from other lines 
;*
;* Lab 2: Use two ports for interrupts: Port F pin 4 and Port D pin 7
;*
;*        Port B pin 0-7 defined as outputs
;*        Port D pin 2,3,6,7 defined as inputs, pin 7 interrupt on rising edge
;*        Port E pin 0-5 defined as outputs
;*        Port F pin 0-3 defined as outputs
;*        Port F pin 4 defined as input with pull-up, pin 4 interrupt on rising edge
;*
;* Predefined subroutines
;*
;*  inituart:   Initialize uart0 to use 115200 baud, 8N1.
;*  initGPIOB:  Initialize port B
;*  initGPIOD:  Initialize port D
;*  initGPIOE:  Initialize port E
;*  initGPIOF:  Initialize port F
;*  initint:    Initialize NVIC to have GPIOF prio 5, GPIOD prio 2
;*  SKBAK:        Print "Bakgrundsprogram"
;*  SKAVH:        Print "     Avbrott hoger"
;*  SKAVV:        Print "  Avbrott vanster"
;*  DELAY:        Delay, r1=number of ms to wait
;*

    .thumb        ; Code is using Thumb mode
    .text        ; Code is put into the program memory

;*****************************************************
;*
;* Constants that are not stored in pogram memory
;*
;* Used together with offset constants defined below
;*
;*****************************************************
UART0_base   .equ    0x4000c000    ; Start adress for UART

GPIOA_base   .equ    0x40004000    ; General Purpose IO port A start adress
GPIOB_base   .equ    0x40005000    ; General Purpose IO port B start adress
GPIOC_base   .equ    0x40006000    ; General Purpose IO port C start adress
GPIOD_base   .equ    0x40007000    ; General Purpose IO port D start adress
GPIOE_base   .equ    0x40024000    ; General Purpose IO port E start adress
GPIOF_base   .equ    0x40025000    ; General Purpose IO port F start adress

GPIO_HBCTL   .equ    0x400FE06C    ; GPIO buss choise

NVIC_base    .equ    0xe000e000    ; Nested Vectored Interrupt Controller

GPIO_KEY     .equ    0x4c4f434b    ; Key value to unlock configuration registers

RCGCUART     .equ    0x400FE618    ; Enable UART port
RCGCGPIO     .equ    0x400fe608    ; Enable GPIO port

;*****************************************************
;
; Use as offset together with base-definitions above
; 
;*****************************************************
UARTDR      .equ    0x0000    ; Data register
UARTFR      .equ    0x0018    ; Flag register
UARTIBRD    .equ    0x0024    ; Baud rate control1
UARTFBRD    .equ    0x0028    ; Baud rate control2
UARTLCRH    .equ    0x002c    ;
UARTCTL     .equ    0x0030    ; Control register

GPIODATA    .equ    0x03fc    ; Data register
GPIODIR     .equ    0x0400    ; Direction select
GPIOIS      .equ    0x0404    ; interrupt sense
GPIOIBE     .equ    0x0408    ; interrupt both edges
GPIOIEV     .equ    0x040c    ; interrupt event
GPIOIM      .equ    0x0410    ; interrupt mask
GPIORIS     .equ    0x0414    ; raw interrupt status
GPIOMIS     .equ    0x0418    ; masked interrupt status
GPIOICR     .equ    0x041c    ; interrupt clear
GPIOAFSEL   .equ    0x0420    ; alternate function select
GPIODR2R    .equ    0x0500    ; 2 mA Drive select
GPIODR4R    .equ    0x0504    ; 4 mA Drive select
GPIODR8R    .equ    0x0508    ; 8 mA Drive select
GPIOODR     .equ    0x050c    ; Open drain select
GPIOPUR     .equ    0x510    ; pull-up select
GPIOPDR     .equ    0x514    ; pull-down select
GPIOSLR     .equ    0x518    ; slew rate control select
GPIODEN     .equ    0x51c    ; digital enable
GPIOLOCK    .equ    0x520    ; lock register
GPIOCR      .equ    0x524    ; commit
GPIOAMSEL   .equ    0x528    ; analog mode select
GPIOPCTL    .equ    0x52c    ; port control

NVIC_EN0    .equ    0x100    ; Enable interrupt 0-31
NVIC_PRI0   .equ    0x400    ; Select priority interrupts 0-3
NVIC_PRI1   .equ    0x404    ; Select priority interrupts 4-7
NVIC_PRI7   .equ    0x41c    ; Select priority interrupts 28-31
NVIC_PRI12  .equ    0x430    ; Select priority interrupts 48-51


;*****************************************************
;
; Definitions found in "Introduktion till Darma"
; 
;*****************************************************

GPIOB_GPIODATA	.equ	0x400053fc ; dataregister port B
GPIOB_GPIODIR	.equ	0x40005400 ; riktningsregister port B
GPIOD_GPIODATA	.equ	0x40007330 ; dataregister port D
GPIOD_GPIODIR	.equ	0x40007400 ; riktningsregister port D
GPIOD_GPIOICR	.equ	0x4000741c ; rensa avbrottsrequest port D
GPIOE_GPIODATA	.equ	0x400240fc ; dataregister port E
GPIOE_GPIODIR	.equ	0x40024400 ; riktningsregister port E
GPIOF_GPIODATA	.equ	0x4002507c ; dataregister port F
GPIOF_GPIODIR	.equ	0x40025400 ; riktningsregister port F
GPIOF_GPIOICR	.equ	0x4002541c ; rensa avbrottrequest port F
	
;*****************************************************
;
; Definierade adresser
; 
;*****************************************************

TIME	.equ	0x20001000 ; Start address för tid 4byte
MUXDIGIT	.equ	0x20001100 ; 0-3 vilken siffra som muxas
	
	
;*****************************************************
;
; Texts used by SKBAK, SKAVH, SKAVV
; 
;*****************************************************
	
            .align 4    ; make sure these constants start on 4 byte boundary
SJUSEGTAB	.byte 0xfc	; '0 
		.byte 0x60	; '1
		.byte 0xda	; '2 
		.byte 0xf2	; '3 
		.byte 0x66	; '4 
		.byte 0xb6	; '5 
		.byte 0xbe	; '6 
		.byte 0xe0	; '7
		.byte 0xfe	; '8 
		.byte 0xe6	; '9 

    .global main    ; main is defined in this file
    .global intgpiod    ; intgpiod is defined in this file
    .global intgpiof    ; intgpiof is defined in this file

    .align 0x100    ; Start main at an adress ending with two zeros

;*************************************************************************
;*
;* Place your main program here
;*

main:
    bl inituart
    bl initGPIOD
    bl initGPIOF
    bl initGPIOB
    bl initGPIOE
    bl initint
    mov r0,#(MUXDIGIT & 0xffff) ; Sätt muxad siffra till 0
    movt r0,#(MUXDIGIT >> 16) 
	mov r1,#0x00
	str r1,[r0]

    mov r0,#(TIME & 0xffff)	; Sätt tid till 0
    movt r0,#(TIME >> 16) 
	mov r1,#0 ;Ladda kod för sifran 0 till r1
	str r1,[r0],#0
	mov r1,#0 ;Ladda kod för sifran 0 till r1
	str r1,[r0],#0
	mov r1,#0 ;Ladda kod för sifran 0 till r1
	str r1,[r0],#0
	mov r1,#0 ;Ladda kod för sifran 0 till r1
	str r1,[r0],#0


    mov r0,#(0x00010203 & 0xffff) 
    movt r0,#(0x00010203 >> 16) 
    mov r1,#(0x10111213 & 0xffff)
    movt r1,#(0x10111213 >> 16)
    mov r2,#(0x20212223 & 0xffff)
    movt r2,#(0x20212223 >> 16)
    mov r3,#(0x30313233 & 0xffff)
    movt r3,#(0x30313233 >> 16)
    mov r4,#(0x40414243 & 0xffff)
    movt r4,#(0x40414243 >> 16)
    mov r5,#(0x50515253 & 0xffff)
    movt r5,#(0x50515253 >> 16)
    mov r6,#(0x60616263 & 0xffff)
    movt r6,#(0x60616263 >> 16)
    mov r7,#(0x70717273 & 0xffff)
    movt r7,#(0x70717273 >> 16)
    mov r8,#(0x80818283 & 0xffff)
    movt r8,#(0x80818283 >> 16)
    mov r9,#(0x90919293 & 0xffff)
    movt r9,#(0x90919293 >> 16)
    mov r10,#(0xa0a1a2a3 & 0xffff)
    movt r10,#(0xa0a1a2a3 >> 16)
    mov r11,#(0xb0b1b2b3 & 0xffff)
    movt r11,#(0xb0b1b2b3 >> 16)
    mov r12,#(0xc0c1c2c3 & 0xffff)
    movt r12,#(0xc0c1c2c3 >> 16)


    CPSIE I ; tillåt avbrott

infinitenone:
	wfi
    b infinitenone
    
    .align 0x100    ; Place interrupt routine for GPIO port D
                    ; at an adress that ends with two zeros
;**********************************************
;*
;* Place your interrupt routine for GPIO port D here (MUX-interrupt)
;*
intgpiod:

    CPSID I ; tillåt inte avbrott
 	mov r0, #0x80			; Återställ avbrott
	mov r1, #(GPIOD_GPIOICR & 0xffff)
	movt r1, #(GPIOD_GPIOICR >> 16)
	str r0,[r1]
	
	mov r0, #(TIME & 0xffff)	;Address för första address på tid
	movt r0, #(TIME >> 16)

	mov r12, #(MUXDIGIT & 0xffff)
	movt r12, #(MUXDIGIT >> 16)
	ldrb r1,[r12]	; Sifferposition
	
	ldrb r0,[r0,r1]	;Siffervärde (Ej kodat)
	adr r2,SJUSEGTAB
	ldrb r0,[r2,r0] ;Ladda kodning för siffran


	mov r2, #(GPIOE_GPIODATA & 0xffff)
	movt r2, #(GPIOE_GPIODATA >> 16)
	strb r1,[r2]		; Skriv ut vilken sifferpostion som muxas

	mov r2, #(GPIOB_GPIODATA & 0xffff)
	movt r2, #(GPIOB_GPIODATA >> 16)
	strb r0,[r2]		; Skriv ut vilken siffra som muxas
	
	add r1,#1 
	cmp r1,#4
	bne gpiodexit
	mov r1,#0	
gpiodexit:
 	strb r1,[r12]
    CPSIE I ; tillåt avbrott
	bx lr

                    ; Here is the interrupt routine triggered by port D



    .align 0x100    ; Place interrupt routine for GPIO port F at an adress that ends with two zeros
;***********************************************
;*
;* Place your interrupt routine for GPIO port F here (
;*
intgpiof:
    CPSID I ; tillåt inte avbrott
	mov r0, #0x10			; Äterställ avbrott
	mov r1, #(GPIOF_GPIOICR & 0xffff)
	movt r1, #(GPIOF_GPIOICR >> 16)
	str r0,[r1]	

	push {r4,r5,r6,r7}
	mov r0, #(TIME & 0xffff)
	movt r0, #(TIME >> 16)
	ldrb r4,[r0],#1
	ldrb r5,[r0],#1
	ldrb r6,[r0],#1
	ldrb r7,[r0]

	add r4,r4,#1
	cmp r4,#10	;Kollar om sista sekundsiffran blev för stor
	bne exitgpiof
	mov r4,#0
	add r5,#1
	cmp r5,#6	;Kollar om först sekundsiffran blev för stor
	bne exitgpiof

	mov r5,#0
	add r6,r6,#1
	cmp r6,#10	;Kollar om sista minutsifran blev för stor
	bne exitgpiof
	mov r6,#0
	add r7,#1
	cmp r7,#6	;Kollar om först minutsifran blev för stor
	bne exitgpiof
	mov r7,#0

exitgpiof:

	mov r0, #(TIME & 0xffff)
	movt r0, #(TIME >> 16)
	strb r4,[r0],#1
	strb r5,[r0],#1
	strb r6,[r0],#1
	strb r7,[r0]

	pop {r4,r5,r6,r7}

    CPSIE I ; tillåt avbrott
	bx lr              ; Here is the interrupt routine triggered by port F




    .align 0x100    ; Next routine is started at an adress in the program memory that ends with two zeros
;*******************************************************************************************************
;*
;* Subrutines. Nothing of this needs to be changed in the lab.
;*

    .align 2

;* inituart: Initialize serial communiation (enable UART0, set baudrate 115200, 8N1 format)
inituart:
    mov  r1,#(RCGCUART & 0xffff)
    movt r1,#(RCGCUART >> 16)
    ldr  r0,[r1]
    orr  r0,#0x01
    str  r0,[r1]

;   activate  GPIO Port A
    mov  r1,#(RCGCGPIO & 0xffff)
    movt r1,#(RCGCGPIO >> 16)
    ldr  r0,[r1]
    orr  r0,#0x01
    str  r0,[r1]

    nop
    nop
    nop

;   Connect pin 0 and 1 on GPIO port A to the UART function (default for UART0)
;   Allow alt function and enable digital I/O on  port A pin 0 and 1
    mov  r1,#(GPIOA_base & 0xffff)
    movt r1,#(GPIOA_base >> 16)
    ldr  r0,[r1,#GPIOAFSEL]
    orr  r0,#0x03
    str  r0,[r1,#GPIOAFSEL]

    ldr  r0,[r1,#GPIODEN]
    orr  r0,#0x03
    str  r0,[r1,#GPIODEN]

;   Set clockfrequency on the uart, calculated as BRD = 16 MHz / (16 * 115200) = 8.680556
;    => BRDI = 8, BRDF=0.6805556, DIVFRAC=(0.6805556*64+0.5)=44 
;      Final settting of uart clock:
;         8 in UARTIBRD (bit 15 to 0 in UARTIBRD)
    mov  r1,#(UART0_base & 0xffff)
    movt r1,#(UART0_base >> 16)
    mov  r0,#0x08
    str  r0,[r1,#UARTIBRD]

;        44 in UARTFBRD (bit 5 to 0 in UARTFBRD)
    mov  r0,#44
    str  r0,[r1,#UARTFBRD]

;   initialize 8 bit, no FIFO buffert, 1 stop bit, no paritety bit (0x60 to bit 7 to 0 in UARTLCRH)
    mov  r0,#0x60
    str  r0,[r1,#UARTLCRH]

;   activate uart (0 to bits 15 and 14, 0 to bit 11, 0x6 to bits 9 to 7, 0x01 to bits 5 downto 0 in UARTCTL)

    mov  r0,#0x0301
    str  r0,[r1,#UARTCTL]

    bx   lr

    .align 0x10

; initGPIOB, set GPIO port B pin 7 downto 0 as outputs
; destroys r0, r1
initGPIOB:
    mov  r1,#(RCGCGPIO & 0xffff)
    movt r1,#(RCGCGPIO >> 16)
    ldr  r0,[r1]
    orr  r0,#0x02    ; Activate GPIO port B
    str  r0,[r1]
    nop              ; 5 clock cycles before the port can be used
    nop
    nop

    mov  r1,#(GPIO_HBCTL & 0xffff)    ; Select bus for GPIOB
    movt r1,#(GPIO_HBCTL >> 16)
    ldr  r0,[r1]
    bic  r0,#0x02       ; Select apb bus for GPIOB (reset bit 1)
    str  r0,[r1]

    mov  r1,#(GPIOB_base & 0xffff)
    movt r1,#(GPIOB_base >> 16)
    mov  r0,#0xff    ; all pins are outputs
    str  r0,[r1,#GPIODIR]

    mov  r0,#0        ; all pins connects to the GPIO port
    str  r0,[r1,#GPIOAFSEL]

    mov  r0,#0x00    ; disable analog function
    str  r0,[r1,#GPIOAMSEL]

    mov  r0,#0x00    ; Use port B as GPIO without special functions
    str  r0,[r1,#GPIOPCTL]

    mov  r0,#0x00    ; No pullup pins on port B
    str  r0,[r1,#GPIOPUR]

    mov  r0,#0xff    ; all pins are digital I/O
    str  r0,[r1,#GPIODEN]

    bx   lr


; initGPIOD, set pins 2,3,6,7 as inputs
; destroy r0, r1
initGPIOD:
    mov  r1,#(RCGCGPIO & 0xffff)
    movt r1,#(RCGCGPIO >> 16)
    ldr  r0,[r1]
    orr  r0,#0x08    ; aktivera GPIO port D clocking
    str  r0,[r1]
    nop              ; 5 clock cycles before the port can be used
    nop
    nop

    mov  r1,#(GPIO_HBCTL & 0xffff)    ; do not use ahb for GPIOD
    movt r1,#(GPIO_HBCTL >> 16)
    ldr  r0,[r1]
    bic  r0,#0x08       ; use apb bus for GPIOD
    str  r0,[r1]

    mov  r1,#(GPIOD_base & 0xffff)
    movt r1,#(GPIOD_base >> 16)
    mov  r0,#(GPIO_KEY & 0xffff)
    movt r0,#(GPIO_KEY >> 16)
    str  r0,[r1,#GPIOLOCK]        ; unlock port D configuration register

    mov  r0,#0xcc    ; Allow the 4 pins in the port to be configured
    str  r0,[r1,#GPIOCR]

    mov  r0,#0x0        ; all are inputs
    str  r0,[r1,#GPIODIR]

    mov  r0,#0        ; all pins are GPIO pins
    str  r0,[r1,#GPIOAFSEL]

    mov  r0,#0x00    ; disable analog function
    str  r0,[r1,#GPIOAMSEL]

    mov  r0,#0x00    ; Use port D as GPIO without special functions
    str  r0,[r1,#GPIOPCTL]

    mov  r0,#0x00    ; No pullup on port D
    str  r0,[r1,#GPIOPUR]

    mov  r0,#0xff    ; all pins are digital I/O
    str  r0,[r1,#GPIODEN]

    bx    lr

; initGPIOE, set pins bit 0-5 as outputs
; destroys r0, r1
initGPIOE:
    mov  r1,#(RCGCGPIO & 0xffff)
    movt r1,#(RCGCGPIO >> 16)
    ldr  r0,[r1]
    orr  r0,#0x10    ; activate GPIO port E
    str  r0,[r1]
    nop              ; 5 clock cycles before the port can be used
    nop
    nop

    mov  r1,#(GPIO_HBCTL & 0xffff)    ; Do not use ahb (high performance bus) for GPIOE
    movt r1,#(GPIO_HBCTL >> 16)
    ldr  r0,[r1]
    bic  r0,#0x10       ; use apb bus for GPIOE
    str  r0,[r1]

    mov  r1,#(GPIOE_base & 0xffff)
    movt r1,#(GPIOE_base >> 16)
    mov  r0,#0x3f        ; all pins are outputs
    str  r0,[r1,#GPIODIR]

    mov  r0,#0        ; all port bits used as GPIO
    str  r0,[r1,#GPIOAFSEL]

    mov  r0,#0x00    ; disable analog functionality
    str  r0,[r1,#GPIOAMSEL]

    mov  r0,#0x00    ; use port E as GPIO without special funtionality
    str  r0,[r1,#GPIOPCTL]

    mov  r0,#0x00    ; No pullup on port E
    str  r0,[r1,#GPIOPUR]

    mov  r0,#0x3f    ; all pins are digital I/O
    str  r0,[r1,#GPIODEN]

    bx   lr


; initGPIOF, set pin 0-3 as outputs, pin 4 as input with pullup
; destroys r0, r1

initGPIOF:
    mov  r1,#(RCGCGPIO & 0xffff)
    movt r1,#(RCGCGPIO >> 16)
    ldr  r0,[r1]
    orr  r0,#0x20    ; activate GPIO port F
    str  r0,[r1]
    nop              ; 5 clock cycles before the port can be used
    nop
    nop

    mov  r1,#(GPIO_HBCTL & 0xffff)    ; Choose bus type for GPIOF
    movt r1,#(GPIO_HBCTL >> 16)
    ldr  r0,[r1]
    bic  r0,#0x20    ; Select GPIOF port connected to the apb bus
    str  r0,[r1]

    mov  r1,#(GPIOF_base & 0xffff)
    movt r1,#(GPIOF_base >> 16)
    mov  r0,#(GPIO_KEY & 0xffff)
    movt r0,#(GPIO_KEY >> 16)
    str  r0,[r1,#GPIOLOCK]        ; unlock port F configuration registers

    mov  r0,#0x1f    ; allow all 5 pins to be configured
    str  r0,[r1,#GPIOCR]

    mov  r0,#0x00    ; disable analog function
    str  r0,[r1,#GPIOAMSEL]

    mov  r0,#0x00    ; use port F as GPIO
    str  r0,[r1,#GPIOPCTL]

    mov  r0,#0x0f    ; use bit 0-3 as outputs (do NOT press the black buttons on Darma!)
    str  r0,[r1,#GPIODIR]

    mov  r0,#0        ; all pins is used by GPIO
    str  r0,[r1,#GPIOAFSEL]

    mov  r0,#0x10    ; weak pull-up for pin 4
    str  r0,[r1,#GPIOPUR]

    mov  r0,#0xff    ; all pins are digitala I/O
    str  r0,[r1,#GPIODEN]

    bx   lr


; initint, initialize interrupt management
; destroys r0,r1
; Enable interrupts from pin 7 port D and pin 4 port F
initint:
    ; disable interrupts while configuring
    cpsid    i

    ; Generate interrupt from port D, GPIO port D is interrupt nr 3 (vector 19)
    ; positiv edge, high priority interrupt

    ; Generete interrupt from port F, GPIO port F is interrupt nr 30 (vector 46)
    ; positiv edge, low priority interrupt

    ; GPIO port F setup
    ; interrupt activated by input signal edge
    mov  r1,#(GPIOF_base & 0xffff)
    movt r1,#(GPIOF_base >> 16)
    mov  r0,#0x00    ; edge detection
    str  r0,[r1,#GPIOIS]

    ; clear interrupts (unnecessary)
    mov  r0,#0xff    ; clear interrupts
    str  r0,[r1,#GPIOICR]

    ; Enable positive edge (ignore falling edge)
    mov  r0,#0x00    ; Use IEV to control
    str  r0,[r1,#GPIOIBE]

    mov  r0,#0x10    ; rising edge
    str  r0,[r1,#GPIOIEV]

    ; clear interrupt
    mov  r0,#0xff    ; clear interrupts
    str  r0,[r1,#GPIOICR]

    ; enable interrupts from bit 4
    mov  r0,#0x10    ; Send interrupt to controller
    str  r0,[r1,#GPIOIM]

    ; NVIC setup to handle GPIO port F generated interrupt requests
    ; NVIC_priority interrupt 30
    mov  r1,#(NVIC_base & 0xffff)
    movt r1,#(NVIC_base >> 16)
    ldr  r0,[r1,#NVIC_PRI7]        ; Set priority 5
    mvn  r2,#0x00e00000    ; clear bits 23 downto 21
    and  r0,r2
    orr  r0,#0x00a00000
    str  r0,[r1,#NVIC_PRI7]

    ; NVIC_enable allow interrupt nr 30 (port F)
    ldr  r0,[r1,#NVIC_EN0]
    orr  r0,#0x40000000
    str  r0,[r1,#NVIC_EN0]

    ; GPIO Port D setup
    ; interrupt generated by positive edge
    mov  r1,#(GPIOD_base & 0xffff)
    movt r1,#(GPIOD_base >> 16)
    mov  r0,#0x00    ; edge detection
    str  r0,[r1,#GPIOIS]

    ; clear interrupts (unnecessary)
    mov  r0,#0xff    ; clear interrupts
    str  r0,[r1,#GPIOICR]

    ; ignorera fallande flank
    mov  r0,#0x00    ; Use IEV to control
    str  r0,[r1,#GPIOIBE]

    ; stigande flank edge
    mov  r0,#0xcc    ; rising edge
    str  r0,[r1,#GPIOIEV]

    ;clear interrupts
    mov  r0,#0xff    ; clear interrupts
    str  r0,[r1,#GPIOICR]

    ; enable interrupts from bit 7
    mov  r0,#0x80    ; Send interrupt to controller
    str  r0,[r1,#GPIOIM]

    ; NVIC management of interrupts from GPIOport D
    ; NVIC_priority interrupt setup
    mov  r1,#(NVIC_base & 0xffff)
    movt r1,#(NVIC_base >> 16)
    ldr  r0,[r1,#NVIC_PRI0]        ; Set priority 2
    bic  r0,r0,#0xe0000000        ; clear bits 31-29
    orr  r0,r0,#0x40000000
    str  r0,[r1,#NVIC_PRI0]

    ; NVIC_enable port D interrupt
    ldr  r0,[r1,#NVIC_EN0]
    orr  r0,#0x00000008            ; enable interrupt nr 3
    str  r0,[r1,#NVIC_EN0]

    ; enable interrupts
    cpsie i

    bx   lr
