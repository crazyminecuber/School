;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Mall för lab1 i TSEA28 Datorteknik Y
;;
;; 190123 K.Palmkvist
;;

	;; Ange att koden är för thumb mode
	.thumb
	.text
	.align 2
	;; Ange att labbkoden startar här efter initiering
	.global	main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Placera programmet här

main:				; Start av programmet
	bl inituart ; intitiera serieport
	bl initGPIOB ; initiera GPIO port B
	bl initGPIOF ; initiera GPIO port F
	bl initerrorcounter
	bl activatealarm

	mov r0,#(0x20001010 & 0xffff) ;adress till rätt kod
	movt r0,#(0x20001010 >> 16)
	mov r1,#(0x01020304 & 0xffff) ; lagrar rätt kod i register
	movt r1,#(0x01020304 >> 16)
	str r1,[r0] 					; lagrar rätt kod i minnet

	mov r5,#0x0e ; lagrar antal tecken i strängen

	b labelgetkey 	; Efter all initalisering vill vi starta med getkey

	.align 4
errmsgstart:
	.string "Felaktig kod!("
	.align 2

	.align 4
errmsgend:
	.string ")",13,10
	.align 2

keypressloop:
	cmp r4,#0x0a
	bne intea
	bl activatealarm	; Kolla om man tryckt på a, aktivera i så fall larmet
						; och fortsätt med get key.
	b labelgetkey

intea:

	mov r0,#(GPIOF_GPIODATA & 0xFFFF)	; Om upplåst vill vi inte kolla om rätt kod slagits in.
	movt r0,#(GPIOF_GPIODATA >> 16)
	ldrb r0,[r0]
	and r0,r0,#0x08 						; Kolla om larm är avaktiverat
	cmp r0,#0x00
	bne intef

	cmp r4,#0x0f		; kolla om man tryck på f.
	bne intef
	bl checkcode	; Kolla om rätt kod slagits in
	b labelcheckcode


intef:

	cmp r4,#0xff
	bne intenull
	bl activatealarm	; Kolla om tiden har gått ut och lås sedan
						; Hämta ny tangent därefter
	b labelgetkey

intenull:
	bl labeladdkey	; Om inte specialtecken (A,F) lägg till i inmatad nyckel
	b labelgetkey				; Hoppa tillbaka till labelgetkey efteråt

labelcheckcode:		; hoppa sedan tillbaka till samma plats

	cmp r4,#0x01		; Om rätt kod slagits in, avaktivera alarmet
	bne felkod
	bl deactivatealarm	; och fortsätt med getkey
	b labelgetkey
	
felkod:
	bl adderrorcounter
	adr r4,errmsgstart ; läser in pekare till strängen

	bl printstring
	bl printerror

	adr r4,errmsgend ; läser in pekare till strängen

	mov r7,r5 		; Temporärt ändra sträng längden
	mov r5,#0x03
	bl printstring
	mov r5,r7
	b labelgetkey

labeladdkey:
	bl addkey ; Lägg till knapp och fortsätt i labelgetkey

labelgetkey:
	bl getkey
	b keypressloop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: 	pekare till strängen i r4
;				längd på strängen i r5
; Utargument: 	inga
;
; Funktion: 	Skriver ut strängen mha subrutinen printchar
; Förstör r0,r1,r2,r4,r5
printstring:

	add r6,r5,r4 		; Beräkna address för sista tecknet i strängen.

printloop:
	ldrb r0,[r4],#0x01	; Läs in tecken som byte från minnet till r0 och öka
						; värdet på r4 med 1.
	push {lr}			; spara lr på stacken
	bl printchar 		; Skriv ut tecken på terminalen
	pop {lr} 			; hämta lr från stack
	cmp r4,r6			; Kolla om sista tecknet skrivits ut (observera index)
	bne printloop
	bx lr



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Inga
; Utargument: Inga
;
; Funktion: Tänder grön lysdiod (bit 3 = 1, bit 2 = 0, bit 1 = 0)
; Förstör r1 och r0
deactivatealarm:
	mov r1,#(GPIOF_GPIODATA & 0xFFFF)	; lagrar address till led i r1
	movt r1,#(GPIOF_GPIODATA >> 16)
	mov r0,#0x08						; sätter fyra sista bitarna 1000
	strb r0,[r1]							; skriver till led
	push {lr}
	bl initerrorcounter 				; Återställ antal felaktiga försök
	pop {lr}
	bx lr


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Inga
; Utargument: Inga
;
; Funktion: Tänder röd lysdiod (bit 3 = 0, bit 2 = 0, bit 1 = 1)
; Förstör r1 och r0
; Obs! Hamnar automatisk i getkey!
activatealarm:
	mov r1,#(GPIOF_GPIODATA & 0xFFFF)	; lagrar address till led i r1
	movt r1,#(GPIOF_GPIODATA >> 16)
	mov r0,#0x02						; sätter fyra sista bitarna 0010
	strb r0,[r1]							; skriver till led
	push {lr}
	bl clearinput 						; nollställer koden.
	pop {lr}
	bx lr							; invänta knapptryckning

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Inga
; Utargument: Tryckt knappt returneras i r4
; Förstör r4, r1,r2 r3, r6
getkey:
	mov r3,#0x00 	; initiera till 0, skall användas för att räkna antal loopar
	;mov r6,#(0x01312d00 & 0xFFFF)	; 20 000 000 loopar för att dröja fem sekunder.
	;movt r6,#(0x01312d00 >> 16)
	mov r6, #(0x00612d00 & 0xFFFF)	; Några antal loopar skall inte ta riktigt 13 sekunder.
	movt r6,#(0x00612d00 >> 16)
	mov r1,#(GPIOB_GPIODATA & 0xFFFF)
	movt r1,#(GPIOB_GPIODATA >> 16)

notpressedloop:
	add r3,r3,#0x01
	cmp r6,r3
	beq timeout	; Loopa upp till 20 000 000 gånger, lås sedan.
						; Detta görs också medans man slår in koden så att
						; man inte kan slå in havla koden och sedan gå där ifrån.
	
	ldrb r2,[r1]
	ands r2,r2,#0x10
	beq notpressedloop ; Loopa tills knapp trycks in

pressedloop:
	ldrb r2,[r1]
	ands r2,r2,#0x10
	bne pressedloop ; Loopa tills knappen har släppts

	ldrb r4,[r1]	; ladda input till r4
	and r4,r4,#0x0f ; Nollställ översta fyra bitarna

	bx lr

timeout:
	mov r4,#0x00ff
	bx lr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Vald tangent i r4
; Utargument: Inga
;
; Funktion: Flyttar innehållet på 0x20001000-0x20001002 framåt en byte
; till 0x20001001-0x20001003. Lagrar sedan innehållet i r4 på
; adress 0x20001000.
; Förstör r0,r1,r2,r3
addkey:
	mov r0,#(0x20001000 & 0xffff)
	movt r0,#(0x20001000 >> 16)
	
	mov r1,#(0x20001001 & 0xffff)
	movt r1,#(0x20001001 >> 16)

	mov r2,#(0x20001002 & 0xffff)
	movt r2,#(0x20001002 >> 16)

	mov r3,#(0x20001003 & 0xffff)
	movt r3,#(0x20001003 >> 16)

	ldrb r6,[r2]
	strb r6,[r3]
	ldrb r6,[r1]
	strb r6,[r2]
	ldrb r6,[r0]
	strb r6,[r1]
	strb r4,[r0]

	bx lr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Inga
; Utargument: Inga
;
; Funktion: Sätter innehållet på 0x20001000-0x20001003 till 0xFF
; Förstör r0
clearinput:
	mov r0,#(0xffffffff & 0xffff)
	movt r0,#(0xffffffff >> 16)

	mov r2,#(0x20001000 & 0xffff)
	movt r2,#(0x20001000 >> 16)
	str r0,[r2]	
	bx lr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Inga
; Utargument: Returnerar 1 i r4 om koden var korrekt, annars 0 i r4
; förstör r1,r0, r4
checkcode:
	mov r4,#0x00		; Sätt r4 till 0 som standard	

	mov r2,#(0x20001000 & 0xffff)
	movt r2,#(0x20001000 >> 16)

	mov r3,#(0x20001010 & 0xffff)
	movt r3,#(0x20001010 >> 16)

	ldr r0,[r2] ; Ladd angiven nyckel
	ldr r1,[r3]	 ; Ladda korrekt nyckel
	cmp r0,r1 			; Jämför om lika
	bne checkexit		; avsluta om ej lika
	mov r4,#0x01 		; sätt r4 till 1 om lika
checkexit:
	bx lr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Inga
; Utargument: Inga
; förstör r1,r0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
adderrorcounter:
	mov r0,#(ERROR_COUNTER & 0xffff) ; Laddar första addressen till ERROR_COUNTER
	movt r0,#(ERROR_COUNTER >> 16)

errorcounterloop:
	ldrb r1,[r0]		; Lagrar värdet på den givna adderessen i r0
	cmp r1,#0xff	; Kollar om siffran är oinitierad
	beq unitiated	 

	add r1,r1,#0x01 ; Annars öka värdet på siffran med 1
	cmp r1,#0x3a
	beq carry		; Om blivit större än 9, kör carry subrutin

	strb r1,[r0]

	bx lr

carry:	
	mov r1, #0x30 	; Ändra tillbaka till 0
	strb r1,[r0]		; lagra siffran 0 på addressen
	add r0,r0,#0x01 	; Öka addressen med 1 (kolla på nästa siffra)
	b errorcounterloop ; Göra samma för nästa siffra

unitiated:
	mov r1,#0x31 	; Sätt siffran till 1 och avsluta
	strb r1,[r0]
	bx lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,


; sätter alla addresser från ERROR_COUNTER till ERROR_STRING till ottilåtna 0xff
initerrorcounter:
	mov r0,#(ERROR_COUNTER & 0xffff) ; Laddar första addressen till ERROR_COUNTER
	movt r0,#(ERROR_COUNTER >> 16)
	mov r3,#(ERROR_STRING & 0xffff) 
	movt r3,#(ERROR_STRING >> 16) ; laddar adressen för senare jämförelse.
	mov r1,#0xff ; sätter r1 till ottillåtet tecken
zeroloop:
	strb r1,[r0],#0x01 ; nollställer adress 0x20001020-0x200010ff
	cmp r3,r0 
	bne zeroloop 	;Hoppar om vi fyllt alla platser upp till ERROR_STRING
					; annars avsluta

	bx lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inargument: Inga
; Utargument: Inga
; Printar ut antal felaktiga försök att öppna låset
printerror:
	mov r3,#(ERROR_COUNTER & 0xffff) ; Laddar första addressen till ERROR_COUNTER
	movt r3,#(ERROR_COUNTER >> 16)
	push {lr}
	bl rekursivprint
	pop {lr}
	bx lr

rekursivprint:
	ldrb r0,[r3]
	cmp r0,#0xff
	beq rekursivexit
	push {lr,r3}
	add r3,r3,#0x01
	bl rekursivprint
	pop {lr,r3}
	ldrb r0,[r3]
	push {lr}
	bl printchar
	pop {lr}


rekursivexit:
	bx lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;
;;; Allt här efter ska inte ändras
;;;
;;; Rutiner för initiering
;;; Se labmanual för vilka namn som ska användas
;;;

	.align 4

;; 	Initiering av seriekommunikation
;;	Förstör r0, r1

inituart:
	mov r1,#(RCGCUART & 0xffff)		; Koppla in serieport
	movt r1,#(RCGCUART >> 16)
	mov r0,#0x01
	str r0,[r1]

	mov r1,#(RCGCGPIO & 0xffff)
	movt r1,#(RCGCGPIO >> 16)
	ldr r0,[r1]
	orr r0,r0,#0x01
	str r0,[r1]		; Koppla in GPIO port A

	nop			; vänta lite
	nop
	nop

	mov r1,#(GPIOA_GPIOAFSEL & 0xffff)
	movt r1,#(GPIOA_GPIOAFSEL >> 16)
	mov r0,#0x03
	str r0,[r1]		; pinnar PA0 och PA1 som serieport

	mov r1,#(GPIOA_GPIODEN & 0xffff)
	movt r1,#(GPIOA_GPIODEN >> 16)
	mov r0,#0x03
	str r0,[r1]		; Digital I/O på PA0 och PA1

	mov r1,#(UART0_UARTIBRD & 0xffff)
	movt r1,#(UART0_UARTIBRD >> 16)
	mov r0,#0x08
	str r0,[r1]             ; Sätt hastighet till 115200 baud

	mov r1,#(UART0_UARTFBRD & 0xffff)
	movt r1,#(UART0_UARTFBRD >> 16)
	mov r0,#44
	str r0,[r1]		; Andra värdet för att få 115200 baud

	mov r1,#(UART0_UARTLCRH & 0xffff)
	movt r1,#(UART0_UARTLCRH >> 16)
	mov r0,#0x60
	str r0,[r1]		; 8 bit, 1 stop bit, ingen paritet, ingen FIFO

	mov r1,#(UART0_UARTCTL & 0xffff)
	movt r1,#(UART0_UARTCTL >> 16)
	mov r0,#0x0301
	str r0,[r1]		; Börja använda serieport

	bx  lr

; Definitioner för registeradresser (32-bitars konstanter)
GPIOHBCTL	.equ	0x400FE06C
RCGCUART	.equ	0x400FE618
RCGCGPIO	.equ	0x400fe608
UART0_UARTIBRD	.equ	0x4000c024
UART0_UARTFBRD	.equ	0x4000c028
UART0_UARTLCRH	.equ	0x4000c02c
UART0_UARTCTL	.equ	0x4000c030
UART0_UARTFR	.equ	0x4000c018
UART0_UARTDR	.equ	0x4000c000
GPIOA_GPIOAFSEL	.equ	0x40004420
GPIOA_GPIODEN	.equ	0x4000451c
GPIOB_GPIODATA	.equ	0x400053fc
GPIOB_GPIODIR	.equ	0x40005400
GPIOB_GPIOAFSEL	.equ	0x40005420
GPIOB_GPIOPUR	.equ	0x40005510
GPIOB_GPIODEN	.equ	0x4000551c
GPIOB_GPIOAMSEL	.equ	0x40005528
GPIOB_GPIOPCTL	.equ	0x4000552c
GPIOF_GPIODATA	.equ	0x4002507c
GPIOF_GPIODIR	.equ	0x40025400
GPIOF_GPIOAFSEL	.equ	0x40025420
GPIOF_GPIODEN	.equ	0x4002551c
GPIOF_GPIOLOCK	.equ	0x40025520
GPIOKEY		.equ	0x4c4f434b
GPIOF_GPIOPUR	.equ	0x40025510
GPIOF_GPIOCR	.equ	0x40025524
GPIOF_GPIOAMSEL	.equ	0x40025528
GPIOF_GPIOPCTL	.equ	0x4002552c

;egna adresser
ERROR_COUNTER	.equ	0x20001020
ERROR_STRING	.equ	0x20001100

;; Initiering av port F
;; Förstör r0, r1, r2
initGPIOF:
	mov r1,#(RCGCGPIO & 0xffff)
	movt r1,#(RCGCGPIO >> 16)
	ldr r0,[r1]
	orr r0,r0,#0x20		; Koppla in GPIO port F
	str r0,[r1]
	nop 			; Vänta lite
	nop
	nop

	mov r1,#(GPIOHBCTL & 0xffff)	; Använd apb för GPIO
	movt r1,#(GPIOHBCTL >> 16)
	ldr r0,[r1]
	mvn r2,#0x2f		; bit 5-0 = 0, övriga = 1
	and r0,r0,r2
	str r0,[r1]

	mov r1,#(GPIOF_GPIOLOCK & 0xffff)
	movt r1,#(GPIOF_GPIOLOCK >> 16)
	mov r0,#(GPIOKEY & 0xffff)
	movt r0,#(GPIOKEY >> 16)
	str r0,[r1]		; Lås upp port F konfigurationsregister

	mov r1,#(GPIOF_GPIOCR & 0xffff)
	movt r1,#(GPIOF_GPIOCR >> 16)
	mov r0,#0x1f		; tillåt konfigurering av alla bitar i porten
	str r0,[r1]

	mov r1,#(GPIOF_GPIOAMSEL & 0xffff)
	movt r1,#(GPIOF_GPIOAMSEL >> 16)
	mov r0,#0x00		; Koppla bort analog funktion
	str r0,[r1]

	mov r1,#(GPIOF_GPIOPCTL & 0xffff)
	movt r1,#(GPIOF_GPIOPCTL >> 16)
	mov r0,#0x00		; använd port F som GPIO
	str r0,[r1]

	mov r1,#(GPIOF_GPIODIR & 0xffff)
	movt r1,#(GPIOF_GPIODIR >> 16)
	mov r0,#0x0e		; styr LED (3 bits), andra bitar är ingångar
	str r0,[r1]

	mov r1,#(GPIOF_GPIOAFSEL & 0xffff)
	movt r1,#(GPIOF_GPIOAFSEL >> 16)
	mov r0,#0		; alla portens bitar är GPIO
	str r0,[r1]

	mov r1,#(GPIOF_GPIOPUR & 0xffff)
	movt r1,#(GPIOF_GPIOPUR >> 16)
	mov r0,#0x11		; svag pull-up för tryckknapparna
	str r0,[r1]

	mov r1,#(GPIOF_GPIODEN & 0xffff)
	movt r1,#(GPIOF_GPIODEN >> 16)
	mov r0,#0xff		; alla pinnar som digital I/O
	str r0,[r1]

	bx lr


;; Initiering av port B
;; Förstör r0, r1
initGPIOB:
	mov r1,#(RCGCGPIO & 0xffff)
	movt r1,#(RCGCGPIO >> 16)
	ldr r0,[r1]
	orr r0,r0,#0x02		; koppla in GPIO port B
	str r0,[r1]
	nop			; vänta lite
	nop
	nop

	mov r1,#(GPIOB_GPIODIR & 0xffff)
	movt r1,#(GPIOB_GPIODIR >> 16)
	mov r0,#0x0		; alla bitar är ingångar
	str r0,[r1]

	mov r1,#(GPIOB_GPIOAFSEL & 0xffff)
	movt r1,#(GPIOB_GPIOAFSEL >> 16)
	mov r0,#0		; alla portens bitar är GPIO
	str r0,[r1]

	mov r1,#(GPIOB_GPIOAMSEL & 0xffff)
	movt r1,#(GPIOB_GPIOAMSEL >> 16)
	mov r0,#0x00		; använd inte analoga funktioner
	str r0,[r1]

	mov r1,#(GPIOB_GPIOPCTL & 0xffff)
	movt r1,#(GPIOB_GPIOPCTL >> 16)
	mov r0,#0x00		; använd inga specialfunktioner på port B
	str r0,[r1]

	mov r1,#(GPIOB_GPIOPUR & 0xffff)
	movt r1,#(GPIOB_GPIOPUR >> 16)
	mov r0,#0x00		; ingen pullup på port B
	str r0,[r1]

	mov r1,#(GPIOB_GPIODEN & 0xffff)
	movt r1,#(GPIOB_GPIODEN >> 16)
	mov r0,#0xff		; alla pinnar är digital I/O
	str r0,[r1]

	bx lr


;; Utskrift av ett tecken på serieport
;; r0 innehåller tecken att skriva ut (1 byte)
;; returnerar först när tecken skickats
;; förstör r0, r1 och r2
printchar:
	mov r1,#(UART0_UARTFR & 0xffff)	; peka på serieportens statusregister
	movt r1,#(UART0_UARTFR >> 16)
loop1:
	ldr r2,[r1]			; hämta statusflaggor
	ands r2,r2,#0x20		; kan ytterligare tecken skickas?
	bne loop1			; nej, försök igen
	mov r1,#(UART0_UARTDR & 0xffff)	; ja, peka på serieportens dataregister
	movt r1,#(UART0_UARTDR >> 16)
	str r0,[r1]			; skicka tecken
	bx lr




