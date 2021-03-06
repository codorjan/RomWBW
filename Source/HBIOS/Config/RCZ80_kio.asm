;
;==================================================================================================
;   RC2014 Z80 STANDARD CONFIGURATION W/ KIO
;==================================================================================================
;
; THE COMPLETE SET OF DEFAULT CONFIGURATION SETTINGS FOR THIS PLATFORM ARE FOUND IN THE
; CFG_<PLT>.ASM INCLUDED FILE WHICH IS FOUND IN THE PARENT DIRECTORY.  THIS FILE CONTAINS
; COMMON CONFIGURATION SETTINGS THAT OVERRIDE THE DEFAULTS.  IT IS INTENDED THAT YOU MAKE
; YOUR CUSTOMIZATIONS IN THIS FILE AND JUST INHERIT ALL OTHER SETTINGS FROM THE DEFAULTS.
; EVEN BETTER, YOU CAN MAKE A COPY OF THIS FILE WITH A NAME LIKE <PLT>_XXX.ASM AND SPECIFY
; YOUR FILE IN THE BUILD PROCESS.
;
; THE SETTINGS BELOW ARE THE SETTINGS THAT ARE MOST COMMONLY MODIFIED FOR THIS PLATFORM.
; MANY OF THEM ARE EQUAL TO THE SETTINGS IN THE INCLUDED FILE, SO THEY DON'T REALLY DO
; ANYTHING AS IS.  THEY ARE LISTED HERE TO MAKE IT EASY FOR YOU TO ADJUST THE MOST COMMON
; SETTINGS.
;
; N.B., SINCE THE SETTINGS BELOW ARE REDEFINING VALUES ALREADY SET IN THE INCLUDED FILE,
; TASM INSISTS THAT YOU USE THE .SET OPERATOR AND NOT THE .EQU OPERATOR BELOW. ATTEMPTING
; TO REDEFINE A VALUE WITH .EQU BELOW WILL CAUSE TASM ERRORS!
;
; PLEASE REFER TO THE CUSTOM BUILD INSTRUCTIONS (README.TXT) IN THE SOURCE DIRECTORY (TWO
; DIRECTORIES ABOVE THIS ONE).
;
#DEFINE		PLATFORM_NAME	"RC2014 (KIO)"
;
#include "Config/RCZ80_std.asm"
;
INTMODE		.SET	2		; INTERRUPTS: 0=NONE, 1=MODE 1, 2=MODE 2
;
KIOENABLE	.SET	TRUE		; ENABLE ZILOG KIO SUPPORT
;
CTCENABLE	.SET	TRUE		; ENABLE ZILOG CTC SUPPORT
CTCBASE		.SET	KIOBASE+$04	; CTC BASE I/O ADDRESS
;
ACIAENABLE	.SET	FALSE		; ACIA: ENABLE MOTOROLA 6850 ACIA DRIVER (ACIA.ASM)
;
SIOENABLE	.SET	TRUE		; SIO: ENABLE ZILOG SIO SERIAL DRIVER (SIO.ASM)
SIOCNT		.SET	1		; SIO: NUMBER OF CHIPS TO DETECT (1-2), 2 CHANNELS PER CHIP
SIO0MODE	.SET	SIOMODE_EZZ80	; SIO 0: CHIP TYPE: SIOMODE_[RC|SMB|ZP|EZZ80]
SIO0BASE	.SET	KIOBASE+$08	; SIO 0: REGISTERS BASE ADR
SIO0CTCC	.SET	0		; SIO 0: CTC CHANNEL CLOCK SCALER, (0-3), -1 FOR NONE
SIO0ACLK	.SET	1843200		; SIO 0A: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0BCLK	.SET	1843200		; SIO 0B: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
