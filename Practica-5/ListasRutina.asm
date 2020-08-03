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
count		EQU	0x20	;Utilizamos estas tres variables como contadores
cont		EQU	0x21
aux		EQU	0X22

;contador	EQU	0x30
;**********************************************************************
	ORG     0x000             ; processor reset vector
	
	BSF 	STATUS, RP1		;CAMBIO DE BANCO A 3
	BSF 	STATUS, RP0		;CAMBIO DE BANCO A 3
	BANKSEL OPTION_REG
	MOVLW b'11000110' ;Configuración del modulo TMR0 para la velocidad del cambio de letras
	MOVWF OPTION_REG ;Preescaler = 128
	;Cambiamos de banco y limpiamos puerto B para habilitar salida
	BSF STATUS, RP0
	CLRF TRISB
	BCF STATUS, RP0
	CLRF PORTB
	CLRF aux;limpiamos dos contadores
	CLRF count	
imprime	;Entramos al programa y la rutina imprime llamara a la tabla que regresara ocho bits y despues llamamos a la rutina retardo
	MOVF	count,0
	CALL	tabla
	MOVWF	PORTB
	CALL 	_retardo
	INCF	count,1
	GOTO 	imprime
	


tabla;a b e i j m n o r s t  La tabla contiene las letras de los integrantes para imprimir en 7 segmentos
	addwf PCL,F;
	;DT b'01110000',b'11111100',b'10011110',b'00011100',b'11110010',b'11101110',b'00001010',b'01100010',b'01100000',b'00101110',b'10011110',
	;b'10110110',b'01100010',b'10011110',b'00111110',b'11101110',b'00101110',b'01110000'
	retlw b'00000000'
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
	retlw b'11101110';
	retlw b'00101110'
	call limpiar
	
	
limpiar;Esta rutina nos servira para eliminar un bit basura que se genera al repetir la tabla
	clrf	count; limpiamos el contador
	movlw	d'0';asignamos cero a w
	MOVF	count,0
	return
	
_retardo ;T = 4 * Tosc * Valor de TMR0 * Preescaler
        MOVLW d'35' ;Cargar el valor de CONTA para 0.5 segundo (VALOR A MODIFICAR SI SE QUIERE MAYOR RETARDO)
        MOVWF cont
_espera1
        CLRF INTCON ;Deshabilitar interrupciones
        MOVLW d'100' ;Cargar el valor de TMR0 para 122 cuentas
        MOVWF TMR0 
_espera
        btfss INTCON,T0IF ;Esperar desborde del TMR0
        GOTO _espera
        DECFSZ cont ;Decrementar el registro CONTA hasta cero
        GOTO _espera1
        RETURN ;retorno de call

	END
	;Compilar pk2cmd -p -m -f//home/mar/MPLABXProjects/Practica5.X/dist/default/production/Practica5.X.production.hex
