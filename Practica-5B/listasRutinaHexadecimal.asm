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
count		EQU	0x20	;Utilizaremos tres variables para usarlo como contador
cont		EQU	0x21
aux		EQU	0X22

;contador	EQU	0x30
;**********************************************************************
	ORG     0x000             ; processor reset vector
	
	BSF 	STATUS, RP1		;CAMBIO DE BANCO A 3	    00   1    01   2    10   3     11    4
	BSF 	STATUS, RP0		;CAMBIO DE BANCO A 3
	BANKSEL OPTION_REG
	MOVLW b'11000110' ;Configuración del modulo TMR0 para la velocidad
	MOVWF OPTION_REG ;Preescaler = 128 
	;Configuramos el puerto D y C como salida
	BCF STATUS, RP1
	CLRF TRISD
	CLRF TRISC
	BCF STATUS, RP0
	CLRF PORTD
	CLRF PORTC
	CLRF aux;Limpiamos dos contadores
	CLRF count	
imprime; nuestro programa entra a la rutina y llama a tabla nos regresa 2 bytes
	MOVF	count,0
	CALL	tablaB;un byte de la tabla B
	MOVWF	PORTC
	
	MOVF	aux,0
	CALL	tablaD;otro byte de la tabla D
	MOVWF	PORTD
	
	;Cuando regrese los dos bytes mandamos un retardo
	CALL 	_retardo
	INCF	count,1;incrementamos los contadores por separado a las tablas para que 
	INCF	aux,1;nos regrese el siguiente byte
	GOTO 	imprime
	

	
tablaB;a b e i j m n o r s t Para los primeros ocho segmentos de display hexadecimal (Los de afuera)
	addwf PCL,F;
	;DT b'01110000',b'11111100',b'10011110',b'00011100',b'11110010',b'11101110',b'00001010',b'01100010',b'01100000',b'00101110',b'10011110',
	;b'10110110',b'01100010',b'10011110',b'00111110',b'11101110',b'00101110',b'01110000'
	retlw b'00000000';abcdefg0
	retlw b'11000110';J
	retlw b'01111000'
	retlw b'01001000'
	retlw b'00001000'
	retlw b'00110011';M
	retlw b'10000011'
	retlw b'10000011'
	retlw b'11000000'
	retlw b'11001100'
	retlw b'00110011'
	retlw b'01001000';E
	retlw b'01011000'
	retlw b'11000000'
	retlw b'01001000'
	retlw b'11111100'
	retlw b'10000011'
	retlw b'00110011'
	call limpiar
	
tablaD;a b e i j m n o r s t  Para los ultimos ocho segmentos (Los de adentro)
	addwf PCL,F;
	;DT b'01110000',b'11111100',b'10011110',b'00011100',b'11110010',b'11101110',b'00001010',b'01100010',b'01100000',b'00101110',b'10011110',
	;b'10110110',b'01100010',b'10011110',b'00111110',b'11101110',b'00101110',b'01110000'
	retlw b'00000000';abcdefg0
	retlw b'01000010';J
	retlw b'01000010'
	retlw b'01001010'
	retlw b'01000010'
	retlw b'10100000';M
	retlw b'01010010'
	retlw b'11010001'
	retlw b'01000010'
	retlw b'01000010'
	retlw b'10000001'
	retlw b'01001010';E
	retlw b'01001000'
	retlw b'01000010'
	retlw b'01001010'
	retlw b'01001010'
	retlw b'01010010';
	retlw b'10000001'
	call limpiaraux
	
limpiar ; limpiamos el contador de la tabla B
	clrf	count
	movlw	d'0'
	MOVF	count,0
	return
	
limpiaraux;LImpiamos el contador de la tabla D para que no nos genere un byte basura al repetir
	clrf	aux
	movlw	d'0'
	MOVF	aux,0
	return

;las rutinas de retardo nos ayudan a configurar los tiempos de instrucción y vizualizar mejor la salida
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
