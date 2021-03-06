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
;w_temp		EQU	0x7D		; variable used for context saving
;status_temp	EQU	0x7E		; variable used for context saving
;pclath_temp	EQU	0x7F		; variable used for context saving


;**********************************************************************
	ORG     0x000             ; processor reset vector
	bsf STATUS, RP0
	MOVLW 0xFF
	MOVWF TRISA
	MOVLW 0x00
	MOVWF TRISB
	BSF STATUS,RP1
	CLRF ANSEL
	CLRF ANSELH
	BCF STATUS,RP0
	BCF STATUS,RP1	


main
	
inicio	
    movlw .153
    iorlw .48
    xorwf PORTA,w
    movwf PORTB
    goto inicio
; remaining code goes here




; example of preloading EEPROM locations

	ORG	0x2100
	DE	5, 4, 3, 2, 1

	END                       ; directive 'end of program'




