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
;    Filename: PRACT_2.asm                                            *
;    Date: 24-Febrero-2020                                            *
;    File Version: 1                                                  *
;                                                                     *
;    Authores:  Joel David, Razek Lira, Mares Márquez      *
;    Company: CU UAEM Zumpango                                        *
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
;w_temp		EQU	0x7D		; variable used for context saving
;status_temp	EQU	0x7E		; variable used for context saving
;pclath_temp	EQU	0x7F		; variable used for context saving

CBLOCK	0x20
	N1
	N2
	N3
	ENDC

;**********************************************************************

ORG     0x000             ; processor reset vector
		nop
  		goto    INICIO    ; go to beginning of program
	
;CODIGO********************************************************
INICIO
	bsf		 STATUS,RP0			;ACCESO AL BANCO 1
	bcf	 	 STATUS,RP1
	movlw		 b'11111111'    ;CONFIGURO PORTA COMO ENTRADAS
	movwf		 TRISA
	movlw		 b'11100000'	
	movwf		 TRISE		;configurando PORTE como entrada
	clrf		 TRISB			;CONFIGURO PORTB COMO SALIDA
	bsf		 STATUS,RP1			;ACCESO AL BANCO 3
	clrf		 ANSEL			;CONFIGURACION DE SALIDAS DIGITALES
	clrf		 ANSELH			;CONFIGURACION DE ENTRADAS DIGITALES
	bcf		 STATUS,RP0			;ACCESO AL BANCO 0
	bcf		 STATUS,RP1
PRINCIPAL
	movf		 PORTA,W        ;CARGO A W = PORTA
	;movf		 PORTE,N3
	
	movwf		 N1
	movwf		 N2
	movwf		 N3
	movlw		 b'00001111'
    swapf		 N2,1
	andwf		 N1,1
	andwf		 N2,1
	movf		 N2,W
	addwf		 PORTE,W
	addwf		 N1,W
	movwf		 PORTB			;MOSTRAMOS POR EL PORTB LO QUE SE CARGO EN W 
	goto		 PRINCIPAL      
	END 						;directive 'end of program' 						;directive 'end of program'