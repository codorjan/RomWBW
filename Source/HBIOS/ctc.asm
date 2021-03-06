;___CTC________________________________________________________________________________________________________________
;
; Z80 CTC
;
;   DISPLAY CONFIGURATION DETAILS
;______________________________________________________________________________________________________________________
;
; ONLY IM2 IMPLEMENTED BELOW.  I DON'T SEE ANY REASONABLE WAY TO
; IMPLEMENT AN IM1 TIMER BECAUSE THE CTC PROVIDES NO WAY TO
; DETERMINE IF IT WAS THE CAUSE OF AN INTERRUPT OR A WAY TO
; DETERMINE WHICH CHANNEL CAUSED AN INTERRUPT.
;
#IF (INTMODE != 2)
	.ECHO	"*** ERROR: CTC REQUIRES INTMODE 2!!!\n"
	!!!	; FORCE AN ASSEMBLY ERROR
#ENDIF
;
; CONFIGURATION
;
#IF (CTCMODE == CTCMODE_ZP)
CTCPC		.EQU	CTCC		; PRESCALE CHANNEL
CTCPCC		.EQU	0		; PRESCALE CHANNEL CONSTANT
CTCTC		.EQU	CTCD		; TIMER CHANNEL
CTCTCC		.EQU	48		; TIMER CHANNEL CONSTANT
CTCTIVT		.EQU	INT_CTC0D	; TIMER CHANNEL IVT ENTRY
#ENDIF
;
#IF (CTCMODE == CTCMODE_Z2)
CTCPC		.EQU	CTCA		; PRESCALE CHANNEL
CTCPCC		.EQU	0		; PRESCALE CHANNEL CONSTANT
CTCTC		.EQU	CTCB		; TIMER CHANNEL
CTCTCC		.EQU	72		; TIMER CHANNEL CONSTANT
CTCTIVT		.EQU	INT_CTC0B	; TIMER CHANNEL IVT ENTRY
#ENDIF
;
#IF (CTCMODE == CTCMODE_EZ)
CTCPC		.EQU	CTCC		; PRESCALE CHANNEL
CTCPCC		.EQU	0		; PRESCALE CHANNEL CONSTANT
CTCTC		.EQU	CTCD		; TIMER CHANNEL
CTCTCC		.EQU	72		; TIMER CHANNEL CONSTANT
CTCTIVT		.EQU	INT_CTC0D	; TIMER CHANNEL IVT ENTRY
#ENDIF
;
#IF (CTCMODE == CTCMODE_RC)
CTCPC		.EQU	CTCC		; PRESCALE CHANNEL
CTCPCC		.EQU	0		; PRESCALE CHANNEL CONSTANT
CTCTC		.EQU	CTCD		; TIMER CHANNEL
CTCTCC		.EQU	144		; TIMER CHANNEL CONSTANT
CTCTIVT		.EQU	INT_CTC0D	; TIMER CHANNEL IVT ENTRY
#ENDIF
;
;
;
CTC_PREINIT:
	; SETUP TIMER INTERRUPT IVT SLOT
	LD	HL,HB_TIMINT		; TIMER INT HANDLER ADR
	LD	(IVT(CTCTIVT)),HL	; IVT ENTRY FOR TIMER CHANNEL
;
	; CTC USES 4 CONSECUTIVE VECTOR POSITIONS, ONE FOR
	; EACH CHANNEL.  BELOW WE SET THE BASE VECTOR TO THE
	; START OF THE IVT, SO THE FIRST FOUR ENTIRES OF THE
	; IVT CORRESPOND TO CTC CHANNELS A-D
	LD	A,0
	OUT	(CTCBASE),A		; SETUP CTC BASE INT VECTOR
;
	; IN ORDER TO DIVIDE THE CTC INPUT CLOCK DOWN TO THE
	; DESIRED 50 HZ PERIODIC INTERRUPT, WE NEED TO CONFIGURE ONE
	; CTC CHANNEL AS A PRESCALER AND ANOTHER AS THE ACTUAL
	; TIMER INTERRUPT.  THE PRESCALE CHANNEL OUTPUT MUST BE WIRED
	; TO THE TIMER CHANNEL TRIGGER INPUT VIA HARDWARE.
	LD	A,%01010111		; PRESCALE CHANNEL CONTROL WORD VALUE
		;  |||||||+-- 1=CONTROL WORD FLAG
		;  ||||||+--- 1=SOFTWARE RESET
		;  |||||+---- 1=TIME CONSTANT FOLLOWS
		;  ||||+----- 0=AUTO TRIGGER WHEN TIME CONST LOADED
		;  |||+------ 1=RISING EDGE TRIGGER
		;  ||+------- 0=PRESCALER OF 16 (NOT USED)
		;  |+-------- 1=COUNTER MODE
		;  +--------- 0=NO INTERRUPTS
	OUT	(CTCPC),A		; SETUP PRESCALE CHANNEL
	LD	A,CTCPCC		; PRESCALE CHANNEL CONSTANT
	OUT	(CTCPC),A		; SET PRESCALE CONSTANT
	;
	LD	A,%11010111		; TIMER CHANNEL CONTROL WORD VALUE
		;  |||||||+-- 1=CONTROL WORD FLAG
		;  ||||||+--- 1=SOFTWARE RESET
		;  |||||+---- 1=TIME CONSTANT FOLLOWS
		;  ||||+----- 0=AUTO TRIGGER WHEN TIME CONST LOADED
		;  |||+------ 1=RISING EDGE TRIGGER
		;  ||+------- 0=PRESCALER OF 16 (NOT USED)
		;  |+-------- 1=COUNTER MODE
		;  +--------- 1=ENABLE INTERRUPTS
	OUT	(CTCTC),A		; SETUP TIMER CHANNEL
	LD	A,CTCTCC		; TIMER CHANNEL CONSTANT
	OUT	(CTCTC),A		; SET TIMER CONSTANT
;
	XOR	A
	RET
;
;
;
CTC_INIT:				; MINIMAL INIT
CTC_PRTCFG:
	; ANNOUNCE PORT
	CALL	NEWLINE			; FORMATTING
	PRTS("CTC: MODE=$")		; FORMATTING
#IF (CTCMODE == CTCMODE_ZP)
	PRTS("ZP$")
#ENDIF
#IF (CTCMODE == CTCMODE_Z2)
	PRTS("Z2$")
#ENDIF
#IF (CTCMODE == CTCMODE_EZ)
	PRTS("EZ$")
#ENDIF
#IF (CTCMODE == CTCMODE_RC)
	PRTS("RC$")
#ENDIF
	PRTS(" IO=0x$")			; FORMATTING
	LD	A,CTCBASE		; GET BASE PORT
	CALL	PRTHEXBYTE		; PRINT BASE PORT
;
	XOR	A
	RET
