;
;==================================================================================================
;   ROMWBW 2.X CONFIGURATION DEFAULTS FOR SBC
;==================================================================================================
;
; THIS FILE CONTAINS THE FULL SET OF DEFAULT CONFIGURATION SETTINGS FOR THE PLATFORM
; INDICATED ABOVE. THIS FILE SHOULD *NOT* NORMALLY BE CHANGED.	INSTEAD, YOU SHOULD
; OVERRIDE ANY SETTINGS YOU WANT USING A CONFIGURATION FILE IN THE CONFIG DIRECTORY
; UNDER THIS DIRECTORY.
;
; THIS FILE CAN BE CONSIDERED A REFERENCE THAT LISTS ALL POSSIBLE CONFIGURATION SETTINGS
; FOR THE PLATFORM.
;
#DEFINE PLATFORM_NAME "SBC"
;
PLATFORM	.EQU	PLT_SBC		; PLT_[SBC|ZETA|ZETA2|N8|MK4|UNA|RCZ80|RCZ180|EZZ80|SCZ180|DYNO]
CPUFAM		.EQU	CPU_Z80		; CPU FAMILY: CPU_[Z80|Z180]
BIOS		.EQU	BIOS_WBW	; HARDWARE BIOS: BIOS_[WBW|UNA]
BATCOND		.EQU	FALSE		; ENABLE LOW BATTERY WARNING MESSAGE
HBIOS_MUTEX	.EQU	FALSE		; ENABLE REENTRANT CALLS TO HBIOS (ADDS OVERHEAD)
USELZSA2	.EQU	TRUE		; ENABLE FONT COMPRESSION
TICKFREQ	.EQU	50		; DESIRED PERIODIC TIMER INTERRUPT FREQUENCY (HZ)
;
BOOT_TIMEOUT	.EQU	-1		; AUTO BOOT TIMEOUT IN SECONDS, -1 TO DISABLE, 0 FOR IMMEDIATE
;
CPUOSC		.EQU	8000000		; CPU OSC FREQ IN MHZ
INTMODE		.EQU	0		; INTERRUPTS: 0=NONE, 1=MODE 1, 2=MODE 2
DEFSERCFG	.EQU	SER_38400_8N1	; DEFAULT SERIAL LINE CONFIG (SEE STD.ASM)
;
RAMSIZE		.EQU	512		; SIZE OF RAM IN KB (MUST MATCH YOUR HARDWARE!!!)
MEMMGR		.EQU	MM_SBC		; MEMORY MANAGER: MM_[SBC|Z2|N8|Z180]
MPCL_RAM	.EQU	$78		; SBC MEM MGR RAM PAGE SELECT REG (WRITE ONLY)
MPCL_ROM	.EQU	$7C		; SBC MEM MGR ROM PAGE SELECT REG (WRITE ONLY)
;
RTCIO		.EQU	$70		; RTC LATCH REGISTER ADR
PPIBASE		.EQU	$60		; PRIMARY PARALLEL PORT REGISTERS BASE ADR
;
KIOENABLE	.EQU	FALSE		; ENABLE ZILOG KIO SUPPORT
KIOBASE		.EQU	$80		; KIO BASE I/O ADDRESS
;
CTCENABLE	.EQU	FALSE		; ENABLE ZILOG CTC SUPPORT
CTCDEBUG	.EQU	FALSE		; ENABLE CTC DRIVER DEBUG OUTPUT
CTCBASE		.EQU	$B0		; CTC BASE I/O ADDRESS
CTCTIMER	.EQU	TRUE		; ENABLE CTC PERIODIC TIMER
CTCMODE		.EQU	CTCMODE_CTR	; CTC MODE: CTCMODE_[NONE|CTR|TIM16|TIM256]
CTCPRECH	.EQU	2		; PRESCALE CHANNEL (0-3)
CTCTIMCH	.EQU	3		; TIMER CHANNEL (0-3)
CTCOSC		.EQU	614400		; CTC CLOCK FREQUENCY
;
DIAGENABLE	.EQU	FALSE		; ENABLES OUTPUT TO 8 BIT LED DIAGNOSTIC PORT
DIAGPORT	.EQU	$00		; DIAGNOSTIC PORT ADDRESS
DIAGDISKIO	.EQU	TRUE		; ENABLES DISK I/O ACTIVITY ON DIAGNOSTIC LEDS
;
LEDENABLE	.EQU	FALSE		; ENABLES STATUS LED (SINGLE LED)
LEDPORT		.EQU	$0E		; STATUS LED PORT ADDRESS
LEDDISKIO	.EQU	TRUE		; ENABLES DISK I/O ACTIVITY ON STATUS LED
;
DSKYENABLE	.EQU	FALSE		; ENABLES DSKY (DO NOT COMBINE WITH PPIDE)
;
CRTACT		.EQU	FALSE		; ACTIVATE CRT (VDU,CVDU,PROPIO,ETC) AT STARTUP
VDAEMU		.EQU	EMUTYP_ANSI	; VDA EMULATION: EMUTYP_[TTY|ANSI]
ANSITRACE	.EQU	1		; ANSI DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPKTRACE	.EQU	1		; PPK DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
KBDTRACE	.EQU	1		; KBD DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPKKBLOUT	.EQU	KBD_US		; PPK KEYBOARD LANGUAGE: KBD_[US|DE]
KBDKBLOUT	.EQU	KBD_US		; KBD KEYBOARD LANGUAGE: KBD_[US|DE]
;
DSRTCENABLE	.EQU	TRUE		; DSRTC: ENABLE DS-1302 CLOCK DRIVER (DSRTC.ASM)
DSRTCMODE	.EQU	DSRTCMODE_STD	; DSRTC: OPERATING MODE: DSRTC_[STD|MFPIC]
DSRTCCHG	.EQU	FALSE		; DSRTC: FORCE BATTERY CHARGE ON (USE WITH CAUTION!!!)
;
BQRTCENABLE	.EQU	FALSE		; BQRTC: ENABLE BQ4845 CLOCK DRIVER (BQRTC.ASM)
BQRTC_BASE	.EQU	$50		; BQRTC: I/O BASE ADDRESS
;
INTRTCENABLE	.EQU	FALSE		; ENABLE PERIODIC INTERRUPT CLOCK DRIVER (INTRTC.ASM)
;
HTIMENABLE	.EQU	FALSE		; ENABLE SIMH TIMER SUPPORT
SIMRTCENABLE	.EQU	FALSE		; ENABLE SIMH CLOCK DRIVER (SIMRTC.ASM)
;
UARTENABLE	.EQU	TRUE		; UART: ENABLE 8250/16550-LIKE SERIAL DRIVER (UART.ASM)
UARTOSC		.EQU	1843200		; UART: OSC FREQUENCY IN MHZ
UARTCFG		.EQU	DEFSERCFG	; UART: LINE CONFIG FOR UART PORTS
UARTCASSPD	.EQU	SER_300_8N1	; UART: ECB CASSETTE UART DEFAULT SPEED
UARTSBC		.EQU	TRUE		; UART: AUTO-DETECT SBC/ZETA ONBOARD UART
UARTCAS		.EQU	TRUE		; UART: AUTO-DETECT ECB CASSETTE UART
UARTMFP		.EQU	TRUE		; UART: AUTO-DETECT MF/PIC UART
UART4		.EQU	TRUE		; UART: AUTO-DETECT 4UART UART
UARTRC		.EQU	FALSE		; UART: AUTO-DETECT RC UART
;
ASCIENABLE	.EQU	FALSE		; ASCI: ENABLE Z180 ASCI SERIAL DRIVER (ASCI.ASM)
;
ACIAENABLE	.EQU	FALSE		; ACIA: ENABLE MOTOROLA 6850 ACIA DRIVER (ACIA.ASM)
;
SIOENABLE	.EQU	TRUE		; SIO: ENABLE ZILOG SIO SERIAL DRIVER (SIO.ASM)
SIODEBUG	.EQU	FALSE		; SIO: ENABLE DEBUG OUTPUT
SIOCNT		.EQU	1		; SIO: NUMBER OF CHIPS TO DETECT (1-2), 2 CHANNELS PER CHIP
SIO0MODE	.EQU	SIOMODE_ZP	; SIO 0: CHIP TYPE: SIOMODE_[STD|RC|SMB|ZP]
SIO0BASE	.EQU	$B0		; SIO 0: REGISTERS BASE ADR
SIO0ACLK	.EQU	(4915200/8)	; SIO 0A: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0ACFG	.EQU	DEFSERCFG	; SIO 0A: SERIAL LINE CONFIG
SIO0ACTCC	.EQU	-1		; SIO 0A: CTC CHANNEL 0=A, 1=B, 2=C, 3=D, -1 FOR NONE
SIO0BCLK	.EQU	(4915200/8)	; SIO 0B: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0BCFG	.EQU	DEFSERCFG	; SIO 0B: SERIAL LINE CONFIG
SIO0BCTCC	.EQU	-1		; SIO 0B: CTC CHANNEL 0=A, 1=B, 2=C, 3=D, -1 FOR NONE
;
XIOCFG		.EQU	DEFSERCFG	; XIO: SERIAL LINE CONFIG
;
VDUENABLE	.EQU	FALSE		; VDU: ENABLE VDU VIDEO/KBD DRIVER (VDU.ASM)
VDUSIZ		.EQU	V80X25		; VDU: DISPLAY FORMAT [V80X24|V80X25|V80X30]
CVDUENABLE	.EQU	FALSE		; CVDU: ENABLE CVDU VIDEO/KBD DRIVER (CVDU.ASM)
NECENABLE	.EQU	FALSE		; NEC: ENABLE NEC UPD7220 VIDEO/KBD DRIVER (NEC.ASM)
TMSENABLE	.EQU	FALSE		; TMS: ENABLE TMS9918 VIDEO/KBD DRIVER (TMS.ASM)
TMSMODE		.EQU	TMSMODE_SCG	; TMS: DRIVER MODE: TMSMODE_[SCG/N8]
TMSTIMENABLE	.EQU	FALSE		; TMS: ENABLE TIMER INTERRUPTS (REQUIRES IM1)
VGAENABLE	.EQU	FALSE		; VGA: ENABLE VGA VIDEO/KBD DRIVER (VGA.ASM)
VGASIZ		.EQU	V80X25		; VGA: DISPLAY FORMAT [V80X25|V80X30|V80X43]
;
MDENABLE	.EQU	TRUE		; MD: ENABLE MEMORY (ROM/RAM) DISK DRIVER (MD.ASM)
MDTRACE		.EQU	1		; MD: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
;
FDENABLE	.EQU	FALSE		; FD: ENABLE FLOPPY DISK DRIVER (FD.ASM)
FDMODE		.EQU	FDMODE_DIO3	; FD: DRIVER MODE: FDMODE_[DIO|ZETA|ZETA2|DIDE|N8|DIO3|RCSMC|RCWDC|DYNO|EPWDC]
FDCNT		.EQU	2		; FD: NUMBER OF FLOPPY DRIVES ON THE INTERFACE (1-2)
FDTRACE		.EQU	1		; FD: TRACE LEVEL (0=NO,1=FATAL,2=ERRORS,3=ALL)
FDMEDIA		.EQU	FDM144		; FD: DEFAULT MEDIA FORMAT FDM[720|144|360|120|111]
FDMEDIAALT	.EQU	FDM720		; FD: ALTERNATE MEDIA FORMAT FDM[720|144|360|120|111]
FDMAUTO		.EQU	TRUE		; FD: AUTO SELECT DEFAULT/ALTERNATE MEDIA FORMATS
;
RFENABLE	.EQU	FALSE		; RF: ENABLE RAM FLOPPY DRIVER
RFCNT		.EQU	1		; RF: NUMBER OF RAM FLOPPY UNITS (1-4)
;
IDEENABLE	.EQU	FALSE		; IDE: ENABLE IDE DISK DRIVER (IDE.ASM)
IDETRACE	.EQU	1		; IDE: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
IDECNT		.EQU	1		; IDE: NUMBER OF IDE INTERFACES TO DETECT (1-3), 2 DRIVES EACH
IDE0MODE	.EQU	IDEMODE_DIO	; IDE 0: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC]
IDE0BASE	.EQU	$20		; IDE 0: IO BASE ADDRESS
IDE0DATLO	.EQU	$20		; IDE 0: DATA LO PORT FOR 16-BIT I/O
IDE0DATHI	.EQU	$28		; IDE 0: DATA HI PORT FOR 16-BIT I/O
IDE0A8BIT	.EQU	FALSE		; IDE 0A (MASTER): 8 BIT XFER
IDE0B8BIT	.EQU	FALSE		; IDE 0B (MASTER): 8 BIT XFER
IDE1MODE	.EQU	IDEMODE_NONE	; IDE 1: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC]
IDE1BASE	.EQU	$00		; IDE 1: IO BASE ADDRESS
IDE1DATLO	.EQU	$00		; IDE 1: DATA LO PORT FOR 16-BIT I/O
IDE1DATHI	.EQU	$00		; IDE 1: DATA HI PORT FOR 16-BIT I/O
IDE1A8BIT	.EQU	TRUE		; IDE 1A (MASTER): 8 BIT XFER
IDE1B8BIT	.EQU	TRUE		; IDE 1B (MASTER): 8 BIT XFER
IDE2MODE	.EQU	IDEMODE_NONE	; IDE 2: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC]
IDE2BASE	.EQU	$00		; IDE 2: IO BASE ADDRESS
IDE2DATLO	.EQU	$00		; IDE 2: DATA LO PORT FOR 16-BIT I/O
IDE2DATHI	.EQU	$00		; IDE 2: DATA HI PORT FOR 16-BIT I/O
IDE2A8BIT	.EQU	TRUE		; IDE 2A (MASTER): 8 BIT XFER
IDE2B8BIT	.EQU	TRUE		; IDE 2B (MASTER): 8 BIT XFER
;
PPIDEENABLE	.EQU	FALSE		; PPIDE: ENABLE PARALLEL PORT IDE DISK DRIVER (PPIDE.ASM)
PPIDETRACE	.EQU	1		; PPIDE: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPIDECNT	.EQU	1		; PPIDE: NUMBER OF PPI CHIPS TO DETECT (1-3), 2 DRIVES PER CHIP
PPIDE0BASE	.EQU	$60		; PPIDE 0: PPI REGISTERS BASE ADR
PPIDE0A8BIT	.EQU	FALSE		; PPIDE 0A (MASTER): 8 BIT XFER
PPIDE0B8BIT	.EQU	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
PPIDE1BASE	.EQU	$20		; PPIDE 1: PPI REGISTERS BASE ADR
PPIDE1A8BIT	.EQU	FALSE		; PPIDE 1A (MASTER): 8 BIT XFER
PPIDE1B8BIT	.EQU	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
PPIDE2BASE	.EQU	$44		; PPIDE 2: PPI REGISTERS BASE ADR
PPIDE2A8BIT	.EQU	FALSE		; PPIDE 2A (MASTER): 8 BIT XFER
PPIDE2B8BIT	.EQU	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
;
SDENABLE	.EQU	FALSE		; SD: ENABLE SD CARD DISK DRIVER (SD.ASM)
SDMODE		.EQU	SDMODE_JUHA	; SD: DRIVER MODE: SDMODE_[JUHA|N8|CSIO|PPI|UART|DSD|MK4|SC|MT]
SDCNT		.EQU	1		; SD: NUMBER OF SD CARD DEVICES (1-2), FOR DSD & SC ONLY
SDTRACE		.EQU	1		; SD: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
SDCSIOFAST	.EQU	FALSE		; SD: ENABLE TABLE-DRIVEN BIT INVERTER IN CSIO MODE
;
PRPENABLE	.EQU	FALSE		; PRP: ENABLE ECB PROPELLER IO BOARD DRIVER (PRP.ASM)
PRPSDENABLE	.EQU	TRUE		; PRP: ENABLE PROPIO DRIVER SD CARD SUPPORT
PRPSDTRACE	.EQU	1		; PRP: SD CARD TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PRPCONENABLE	.EQU	TRUE		; PRP: ENABLE PROPIO DRIVER VIDEO/KBD SUPPORT
;
PPPENABLE	.EQU	FALSE		; PPP: ENABLE ZETA PARALLEL PORT PROPELLER BOARD DRIVER (PPP.ASM)
;
HDSKENABLE	.EQU	FALSE		; HDSK: ENABLE SIMH HDSK DISK DRIVER (HDSK.ASM)
HDSKTRACE	.EQU	1		; HDSK: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
;
PIO_4P		.EQU	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR ECB 4P BOARD
PIO4BASE	.EQU	$90		; PIO: PIO REGISTERS BASE ADR FOR ECB 4P BOARD
PIO_ZP		.EQU	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR ECB ZILOG PERIPHERALS BOARD (PIO.ASM)
PIOZBASE	.EQU	$88		; PIO: PIO REGISTERS BASE ADR FOR ECB ZP BOARD
PPI_SBC		.EQU	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR 8255 CHIP
;
UFENABLE	.EQU	FALSE		; UF: ENABLE ECB USB FIFO DRIVER (UF.ASM)
UFBASE		.EQU	$0C		; UF: REGISTERS BASE ADR
;
AUDIOTRACE	.EQU	FALSE		; ENABLE TRACING TO CONSOLE OF SOUND DRIVER
SN76489ENABLE	.EQU	FALSE		; SN76489 SOUND DRIVER
SN7CLK		.EQU	CPUOSC / 4	; DEFAULT TO CPUOSC / 4

AY38910ENABLE	.EQU	FALSE		; AY: AY-3-8910 / YM2149 SOUND DRIVER
AY_CLK		.EQU	CPUOSC / 4	; DEFAULT TO CPUOSC / 4
AYMODE		.EQU	AYMODE_SCG	; AY: DRIVER MODE: AYMODE_[SCG/N8/RCZ80/RCZ180]
SPKENABLE	.EQU	FALSE		; SPK: ENABLE RTC LATCH IOBIT SOUND DRIVER (SPK.ASM)
