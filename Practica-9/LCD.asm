;**********************************************************************
;   ;https://www.youtube.com/watch?v=I8V1T-iVbUE		      *
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F887. This file contains the basic code               *
;   building blocks to build upon.                                    *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F887.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions



; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V



;***** VARIABLE DEFINITIONS
Vlazo1 equ 0x30
Vlazo2 equ 0x31 


;**********************************************************************
	ORG     0             ; processor reset vector
  	GOTO   MAIN              ; go to beginning of program
	ORG	5
	

MAIN;configuración de puertos B y D como salida
	CLRF	PORTB
	CLRF	PORTD
	BSF	STATUS,RP0
	BCF	STATUS,RP1
	CLRF	TRISD
	CLRF	TRISB
	BCF	STATUS,RP0
	
INICIO
	CALL	LCD_Configurar	;configuramos el lcd
	CALL	ARRIBA		;escribimos en la parte de arriba
	CALL	LCD_Configurar2	;configuramos la linea de abajo
	CALL	ABAJO		;escribimos en la linea de abajo
	CALL	DELAY
	CALL	DELAY
	CALL	DELAY
	GOTO	INICIO		;repetimos
	
ARRIBA ;mensaje lcd arriba
	MOVLW	'S'
	MOVWF	PORTB
	CALL	Envia
	MOVLW	'I'
	MOVWF	PORTB
	CALL	Envia
	MOVLW	'S'
	MOVWF	PORTB
	CALL	Envia
	MOVLW	'T'
	MOVWF	PORTB
	CALL	Envia
	MOVLW	'E'
	MOVWF	PORTB
	CALL	Envia
	MOVLW	'M'
	MOVWF	PORTB
	CALL	Envia
	MOVLW	'A'
	MOVWF	PORTB
	CALL	Envia
	MOVLW	'S'
	MOVWF	PORTB
	CALL	Envia
	RETURN
	
ABAJO ;mensaje lcd abajo
	MOVLW 'E'
	MOVWF PORTB
	CALL Envia
	MOVLW 's'
	MOVWF PORTB
	CALL Envia
	MOVLW 't'
	MOVWF PORTB
	CALL Envia
	MOVLW 'e'
	MOVWF PORTB
	CALL Envia
	MOVLW 'b'
	MOVWF PORTB
	CALL Envia
	MOVLW 'A'
	MOVWF PORTB
	CALL Envia
	MOVLW 'n'
	MOVWF PORTB
	CALL Envia
	MOVLW '-'
	MOVWF PORTB
	CALL Envia
	MOVLW 'J'
	MOVWF PORTB
	CALL Envia
	MOVLW 'o'
	MOVWF PORTB
	CALL Envia
	MOVLW 'e'
	MOVWF PORTB
	CALL Envia
	MOVLW 'l'
	MOVWF PORTB
	CALL Envia
	MOVLW '-'
	MOVWF PORTB
	CALL Envia
	MOVLW 'M'
	MOVWF PORTB
	CALL Envia
	MOVLW 'a'
	MOVWF PORTB
	CALL Envia
	MOVLW 'r'
	MOVWF PORTB
	CALL Envia
	MOVLW 't'
	MOVWF PORTB
	CALL Envia
	MOVLW 'i'
	MOVWF PORTB
	CALL Envia
	MOVLW 'n'
	MOVWF PORTB
	CALL Envia
	RETURN
	
	
LCD_Configurar
	BCF	PORTD,0      ; RS=0 MODO INSTRUCCION
	MOVLW	0x01         ; El comando 0x01 limpia la pantalla en el LCD
	MOVWF	PORTB
	CALL	LCD_Comando  ; Se da de alta el comando
	MOVLW	0x0C	     ; Selecciona la primera l?nea
	MOVWF	PORTB
	CALL	LCD_Comando  ; Se da de alta el comando
	MOVLW	0x3C	     ; Se configura el cursor
	MOVWF	PORTB
	CALL	LCD_Comando  ; Se da de alta el comando
	BSF	PORTD, 0     ; Rs=1 MODO DATO
	RETURN

LCD_Comando
	BSF PORTD,1     ; Pone la ENABLE en 1
	CALL DELAY      ; Tiempo de espera
	CALL DELAY
	BCF PORTD, 1    ; ENABLE=0    
	CALL DELAY
	RETURN     

Envia;ENVIAMOS UN DATO
	BSF PORTD,0	    ; RS=1 MODO DATO
	CALL LCD_Comando    ; Se da de alta el comando
	RETURN
	
LCD_Configurar2;CONFIGURACION DE LA LINEA 2 DEL LCD
	BCF	PORTD, 0    ; RS=0 MODO INSTRUCCION
	MOVLW	0xc0        ; Selecciona linea 2 pantalla en el LCD
	MOVWF	PORTB
	CALL	LCD_Comando    ; Se da de alta el comando
	RETURN
    ; Subrutina de retardo
DELAY           
	MOVLW .255
	MOVWF Vlazo2 
	
Lazo
	MOVLW .255
	MOVWF Vlazo1
Lazo2
	DECFSZ Vlazo1,1
	GOTO Lazo2
	DECFSZ Vlazo2,1
	GOTO Lazo
	RETURN
	

    END
	
