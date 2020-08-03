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
;    Author: Martìn Màrquez Cervantes, Joel David, Esteban Lira       *
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
w_temp		EQU	0x7D		; variable used for context saving
status_temp	EQU	0x7E		; variable used for context saving
pclath_temp	EQU	0x7F		; variable used for context saving
	
CBLOCK 0X20 ; Dirección de memoria para las variables
T1, T2, T3 ; Variables usadas en retardo
W_RES, STATUS_RES ; Variables usadas en interrupción
CONT, PUNTERO, HABILITA
ENDC ; Fin de bloque de librerías


;**********************************************************************
	ORG     0x000             ; processor reset vector
	    GOTO CONFIGURAR ; Ir a la etiqueta configurar
	ORG 0X04 ; Directiva de interrupción
	    GOTO INTERRUPCION ; Ir a la etiqueta configurar
	
	CONFIGURAR ; Configuración de puertos
	   CLRW ; Limpiar a W
	   BSF STATUS, RP0 ; RP0=1 del registro STATUS
	   MOVLW 0X00 ; Cargar el valor a W
	   MOVWF TRISB ; Mover lo de W a TRISB
	   MOVLW 0XF0 ; Cargar el valor a W
	   MOVWF TRISA ; Mover lo de W a TRISA
	   BCF STATUS, RP0 ; RP0=0 del registro STATUS
	   CLRF PORTA ; Limpia PORTA
	   CLRF PORTB ; Limpia PORTB
	   BSF HABILITA, 3 ; Poner el bit 0 de la variable PTA en 0
	   
	CONFI_TMR0 ; Configuración del TMR0 (Interrupción)
	    MOVLW B'10100000' ; Asignación de valores a las banderas del registro
	    
	;INTCON
	    MOVWF INTCON
	    BSF STATUS, RP0
	    MOVLW B'10000010' ; Asignación de valores a las banderas del registro
	    
	;OPTION_REG
	    MOVWF OPTION_REG
	    BCF STATUS, RP0 ; Limpiar el bit RP0 de STATUS
	    CLRF CONT ; Limpiar el contador
	    CLRF PUNTERO ; Limpiar el puntero
	    
	INICIO ; Inicio del programa principal
	    CALL RETARDO ; Llama a la subrutina RETARDO
	    INCF PUNTERO, 1 ; Incrementa la variable UNIDAD
	    MOVF PUNTERO, 0 ; Mueve el valor de UNIDAD a W
	    SUBLW 0X19 ; Le resta el valor de 10 a W
	    BTFSS STATUS, Z ; Testea la bandera Z
	    GOTO INICIO
	    CLRF PUNTERO ; Inicialización de la variable CONT
	    GOTO INICIO ; Salto en caso de que el bit testeado es igual a 1
	    
	;********RUTINAS**********
	
	INTERRUPCION ; Etiqueta para la interrupción
	    MOVWF W_RES ; Mueve lo de W en la variable W_RES
	    SWAPF STATUS, W ; Intercambia lo de STATUS y lo guarda en W
	    MOVWF STATUS_RES ; Mueve lo de W en la variable STATUS_RES
	    MOVF CONT, 0 ; Mueve lo de la variable CONT en W
	    SUBLW 0X04 ; Resta 4 a W
	    BTFSS STATUS, Z ; Testea la bandera Z
	    GOTO CICLO
	    CLRF CONT ; Salto en caso de que el bit testeado es igual a 1
	    CLRF HABILITA ; Limpia la variable PTA
	    BSF HABILITA, 3 ; Pone el bit 0 de la variable PTA en 0
	    
	CICLO ; Etiqueta para ciclo
	    MOVF CONT,0 ; Mueve lo de la variable CONT en W
	    ADDWF PUNTERO, 0 ; Suma el valor de 30 a W CALL
	    GOTO TABLA ; Llama a la subrutina tabla
	    MOVWF PORTB ; Mueve lo de W al registro PORTB
	    MOVF HABILITA, 0 ; Mueve lo de la variable PTA a W
	    MOVWF PORTA
	    INCF CONT, 1 ; Incrementa CONT y lo guarda en si mismo
	    RRF HABILITA, F ; Multiplica lo de W por 2
	    SWAPF STATUS_RES, W
	    MOVWF STATUS ; Mueve lo de W a STATUS
	    SWAPF W_RES, W_RES ; Intercambia lo de la variable W_RES
	    SWAPF W_RES, W
	    BCF INTCON, T0IF ; Limpia el bit T0IF del registro INTCON
	    RETFIE ; Return de la interrupción
	    
	TABLA ; Tabla del 0 al 9
	    ADDWF PCL, 1 ; Suma PCL <- W+PCL
	    RETLW B'11111111' ; _
	    RETLW B'11111111' ; _
	    RETLW B'11111111' ; _
	    RETLW B'00001110' ; F
	    RETLW B'00000110' ; E
	    RETLW B'11000111' ; L
	    RETLW B'11001111' ; I
	    RETLW B'01000110' ; C
	    RETLW B'00000110' ; E
	    RETLW B'00010010' ; S
	    RETLW B'11111111' ; _
	    RETLW B'00001110' ; F
	    RETLW B'11001111' ; I
	    RETLW B'00000110' ; E
	    RETLW B'00010010' ; S
	    RETLW B'00000111' ; T
	    RETLW B'00001000' ; A
	    RETLW B'00010010' ; S
	    RETLW B'11111111' ; _
	    RETLW B'01000110' ; C
	    RETLW B'00001001' ; H
	    RETLW B'11001111' ; I
	    RETLW B'01000110' ; C
	    RETLW B'00001000' ; A
	    RETLW B'00010010' ; S
	    RETLW B'11111111' ; _
	    RETLW B'11111111' ; _
	    RETLW B'11111111' ; _
	    
	RETARDO ; Etiqueta para el retardo
	    MOVLW D'4' ; Retraso de 1 milisegundo
	    MOVWF T1 ; Mueve a la variable T1
	LOOP1
	    MOVLW D'155' ; Carga el valor en decimal de 40 ciclos
	    MOVWF T2 ; Lo mueve a la variable T2
	LOOP2
	    MOVLW D'207' ; Carga el valor en decimal de 30 ciclos
	    MOVWF T3 ; Lo mueve a la variable T3
	LOOP3
	    DECFSZ T3, 1 ; Decrementa el registro y salta si es cero
	    GOTO LOOP3 ; Lo envía al loop3
	    DECFSZ T2, 1 ; Decrementa el registro y salta si es cero
	    GOTO LOOP2 ; Si no lo envía al loop2
	    DECFSZ T1, 1 ; Decrementa si es cero salta
	    GOTO LOOP1 ; Si no lo envía al loop1
	    RETURN ; Repite la instrucción
       END
