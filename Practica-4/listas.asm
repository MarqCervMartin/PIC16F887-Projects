;**********************************************************************
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
;    Date:  9 Marzo del 2020					      *
;    File Version: V1                                                 *
;                                                                     *
;    Author: Martìn Màrquez Cervantes, Joel David, Esteban Lira       *
;    Company: CU UAEM Zumpango	                                      *
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
w_temp		EQU	0x7D		; variable used for context saving
status_temp	EQU	0x7E		; variable used for context saving
pclath_temp	EQU	0x7F		; variable used for context saving
TIEMPO		EQU	0X20

;**********************************************************************
	ORG     0x000             ; processor reset vector

	bsf STATUS, RP0
	MOVLW 0xFF
	MOVWF TRISA ;configuro puerto a como entrada
	MOVLW 0x00
	MOVWF TRISB ;configuro puerto b como salida
	BSF STATUS,RP1;cambio al banco_03
	CLRF ANSEL;configuro el puerto A como digital
	CLRF ANSELH;configuro el puerto B como digital
	BCF STATUS,RP0;cambio al banco_0
	BCF STATUS,RP1	
  	;goto    main              ; go to beginning of program




main
; remaining code goes here
	movf PORTA,W
	andlw b'00001111'   ;mascara para multiplicar y obtener los valores 
	call tabla
	movwf PORTB
	goto main

tabla;a b e i j m n o r s t
	addwf PCL,F
	;DT b'11101110',b'11101110',etc
	retlw b'01110000';abcdefg0
	retlw b'11111100'
	retlw b'10011110'
	retlw b'00011100'
	retlw b'11110010'
	retlw b'11101110'
	retlw b'00001010'
	retlw b'01100010'
	retlw b'01100000'
	retlw b'00101110'
	retlw b'10011110'
	
	retlw b'10110110'
	retlw b'01100010'
	retlw b'10011110'
	retlw b'00111110'
	retlw b'11101110'
	
;retardo
;	movlw d'255';cargo el numero maximo de 8 bits para retardo
;	movwf TIEMPO; tiempo <- w <-255
;dec	decfsz TIEMPO;decremento y si es == cero, si no es salta una linea
;	RETURN
;	goto dec
	

END