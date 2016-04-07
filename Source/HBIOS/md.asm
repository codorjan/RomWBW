;
;==================================================================================================
;   MD DISK DRIVER (MEMORY DISK)
;==================================================================================================
;
MD_UNITCNT	.EQU	2
;
;
;
MD_INIT:
	CALL	NEWLINE			; FORMATTING
	PRTS("MD: UNITS=2 $")
	PRTS("ROMDISK=$")
	LD	HL,ROMSIZE - 128
	CALL	PRTDEC
	PRTS("KB RAMDISK=$")
	LD	HL,RAMSIZE - 128
	CALL	PRTDEC
	PRTS("KB$")
;
; SETUP THE DISPATCH TABLE ENTRIES
;
	LD	B,$01		; PHYSICAL UNIT=1 (RAM)
	LD	C,DIODEV_MD	; DEVICE TYPE
	LD	DE,MD_RAMDAT	; UNIT 1 DATA BLOB ADDRESS
	CALL	DIO_ADDENT	; ADD ENTRY
	LD	B,$00		; PHYSICAL UNIT=0 (ROM)
	LD	C,DIODEV_MD	; DEVICE TYPE
	LD	DE,MD_ROMDAT	; UNIT 0 DATA BLOB ADDRESS
	CALL	DIO_ADDENT	; ADD ENTRY
;
	XOR	A		; INIT SUCCEEDED
	RET			; RETURN
;
;
;
MD_ROMDAT:	; ROM UNIT DATA BLOB
	.DB	0		; UNIT NUMBER IS 0
;
MD_RAMDAT:	; RAM UNIT DATA BLOB
	.DB	0		; UNIT NUMBER IS 1
;
;
;
MD_DISPATCH:
	; VERIFY AND SAVE THE TARGET DEVICE/UNIT LOCALLY IN DRIVER
	LD	A,C			; DEVICE/UNIT FROM C
	AND	$0F			; ISOLATE UNIT NUM
	CP	MD_UNITCNT
	CALL	NC,PANIC		; PANIC IF TOO HIGH
	LD	(MD_UNIT),A		; SAVE IT
;
	; DISPATCH ACCORDING TO DISK SUB-FUNCTION
	LD	A,B		; GET REQUESTED FUNCTION
	AND	$0F		; ISOLATE SUB-FUNCTION
	JP	Z,MD_STATUS	; SUB-FUNC 0: STATUS
	DEC	A
	JP	Z,MD_RESET	; SUB-FUNC 1: RESET
	DEC	A
	JP	Z,MD_SEEK	; SUB-FUNC 2: SEEK
	DEC	A
	JP	Z,MD_READ	; SUB-FUNC 3: READ SECTORS
	DEC	A
	JP	Z,MD_WRITE	; SUB-FUNC 4: WRITE SECTORS
	DEC	A
	JP	Z,MD_VERIFY	; SUB-FUNC 5: VERIFY SECTORS
	DEC	A
	JP	Z,MD_FORMAT	; SUB-FUNC 6: FORMAT TRACK
	DEC	A
	JP	Z,MD_DEVICE	; SUB-FUNC 7: DEVICE REPORT
	DEC	A
	JP	Z,MD_MEDIA	; SUB-FUNC 8: MEDIA REPORT
	DEC	A
	JP	Z,MD_DEFMED	; SUB-FUNC 9: DEFINE MEDIA
	DEC	A
	JP	Z,MD_CAP	; SUB-FUNC 10: REPORT CAPACITY
	DEC	A
	JP	Z,MD_GEOM	; SUB-FUNC 11: REPORT GEOMETRY
;
MD_VERIFY:
MD_FORMAT:
MD_DEFMED:
	CALL	PANIC		; INVALID SUB-FUNCTION
;
;
;
MD_STATUS:
	XOR	A		; ALWAYS OK
	RET
;
;
;
MD_RESET:
	XOR	A		; ALWAYS OK
	RET
;
;
;
MD_CAP:
	LD	A,C		; DEVICE/UNIT IS IN C
	AND	$0F		; ISOLATE UNIT NUM
	JR	Z,MD_CAP0	; UNIT 0
	DEC	A		; TRY UNIT 1
	JR	Z,MD_CAP1	; UNIT 1
	CALL	PANIC		; PANIC ON INVALID UNIT
MD_CAP0:
	LD	A,(HCB + HCB_ROMBANKS)	; POINT TO ROM BANK COUNT
	JR	MD_CAP2
MD_CAP1:
	LD	A,(HCB + HCB_RAMBANKS)	; POINT TO RAM BANK COUNT
MD_CAP2:
	SUB	4		; SUBTRACT OUT RESERVED BANKS
	LD	H,A		; H := # BANKS
	LD	E,64		; # 512 BYTE BLOCKS / BANK
	CALL	MULT8		; HL := TOTAL # 512 BYTE BLOCKS
	LD	DE,0		; NEVER EXCEEDS 64K, ZERO HIGH WORD
	XOR	A
	RET
;
;
;
MD_GEOM:
	; RAM/ROM DISKS ALLOW CHS STYLE ACCESS BY EMULATING
	; A DISK DEVICE WITH 1 HEAD AND 16 SECTORS / TRACK.
	CALL	MD_CAP		; HL := CAPACITY IN BLOCKS
	LD	D,1 | $80	; HEADS / CYL := 1 BY DEFINITION, SET LBA CAPABILITY BIT
	LD	E,16		; SECTORS / TRACK := 16 BY DEFINTION
	LD	B,4		; PREPARE TO DIVIDE BY 16
MD_GEOM1:
	SRL	H		; SHIFT H
	RR	L		; SHIFT L
	DJNZ	MD_GEOM1	; DO 4 BITS TO DIVIDE BY 16
	XOR	A		; SIGNAL SUCCESS
	RET			; DONE
;
;
;
MD_DEVICE:
	LD	D,DIODEV_MD	; D := DEVICE TYPE
	LD	E,C		; E := PHYSICAL UNIT
	LD	A,C		; PHYSICAL UNIT TO A
	OR	A		; SET FLAGS
	LD	C,%00100000	; ASSUME ROM DISK ATTRIBUTES
	JR	Z,MD_DEVICE1	; IF ZERO, IT IS ROM DISK, DONE
	LD	C,%00101000	; USE RAM DISK ATTRIBUTES
MD_DEVICE1:
	XOR	A		; SIGNAL SUCCESS
	RET
;
;
;
MD_MEDIA:
	LD	A,MID_MDROM	; SET MEDIA TYPE TO ROM
	ADD	A,C		; ADJUST BASED ON DEVICE
	LD	E,A		; RESULTANT MEDIA IT TO E
	LD	D,0		; D:0=0 MEANS NO MEDIA CHANGE
	XOR	A		; SIGNAL SUCCESS
	RET
;
;
;
MD_SEEK:
	BIT	7,D		; CHECK FOR LBA FLAG
	CALL	Z,HB_CHS2LBA	; CLEAR MEANS CHS, CONVERT TO LBA
	RES	7,D		; CLEAR FLAG REGARDLESS (DOES NO HARM IF ALREADY LBA)
	LD	BC,HSTLBA	; POINT TO LBA STORAGE
	CALL	ST32		; SAVE LBA ADDRESS
	XOR	A		; SIGNAL SUCCESS
	RET			; AND RETURN
;
;
;
MD_READ:
	LD	(MD_DSKBUF),HL	; SAVE DISK BUFFER ADDRESS
	CALL	MD_IOSETUP	; SETUP FOR MEMORY COPY
#IF (MDTRACE >= 2)
	LD	(MD_SRC),HL
	LD	(MD_DST),DE
	LD	(MD_LEN),BC
#ENDIF
	PUSH	BC
	LD	C,A		; SOURCE BANK
	LD	B,BID_BIOS	; DESTINATION BANK IS RAM BANK 1 (HBIOS)
#IF (MDTRACE >= 2)
	LD	(MD_SRCBNK),BC
	CALL	MD_PRT
#ENDIF
	LD	A,C		; GET SOURCE BANK
	LD	(HB_SRCBNK),A	; SET IT
	LD	A,B		; GET DESTINATION BANK
	LD	(HB_DSTBNK),A	; SET IT
	POP	BC
	CALL	BNKCPY		; DO THE INTERBANK COPY
	XOR	A
	RET
;
;
;
MD_WRITE:
	LD	(MD_DSKBUF),HL	; SAVE DISK BUFFER ADDRESS
	LD	A,C		; DEVICE/UNIT IS IN C
	AND	$0F		; ISOLATE UNIT NUM
	LD	A,1		; PREPARE TO RETURN FALSE
	RET	Z		; RETURN ERROR IF ROM UNIT

	CALL	MD_IOSETUP	; SETUP FOR MEMORY COPY
	EX	DE,HL		; SWAP SRC/DEST FOR WRITE
#IF (MDTRACE >= 2)
	LD	(MD_SRC),HL
	LD	(MD_DST),DE
	LD	(MD_LEN),BC
#ENDIF
	PUSH	BC
	LD	C,BID_BIOS	; SOURCE BANK IS RAM BANK 1 (HBIOS)
	LD	B,A		; DESTINATION BANK
#IF (MDTRACE >= 2)
	LD	(MD_SRCBNK),BC
	CALL	MD_PRT
#ENDIF
	LD	A,C		; GET SOURCE BANK
	LD	(HB_SRCBNK),A	; SET IT
	LD	A,B		; GET DESTINATION BANK
	LD	(HB_DSTBNK),A	; SET IT
	POP	BC
	CALL	BNKCPY		; DO THE INTERBANK COPY
	XOR	A
	RET
;
; SETUP FOR MEMORY COPY
;   A=BANK SELECT
;   BC=COPY SIZE
;   DE=DESTINATION
;   HL=SOURCE
;
; ASSUMES A "READ" OPERATION.  HL AND DE CAN BE SWAPPED
; AFTERWARDS TO ACHIEVE A WRITE OPERATION
;
; ON INPUT, WE HAVE LBA ADDRESSING IN HSTLBAHI:HSTLBALO
; BUT WE NEVER HAVE MORE THAN $FFFF BLOCKS IN A RAM/ROM DISK,
; SO THE HIGH WORD (HSTLBAHI) IS IGNORED
;
; EACH RAM/ROM BANK IS 32K BY DEFINITION AND EACH SECTOR IS 512
; BYTES BY DEFINITION.  SO, EACH RAM/ROM BANK CONTAINS 64 SECTORS
; (32,768 / 512 = 64).  THEREFORE, YOU CAN THINK OF LBA AS
; 00000BBB:BBOOOOOO IS WHERE THE 'B' BITS REPRESENT THE BANK NUMBER
; AND THE 'O' BITS REPRESENT THE SECTOR NUMBER WITHIN THE BANK.
;
; TO EXTRACT THE BANK NUMBER, WE CAN LEFT SHIFT TWICE TO GIVE US:
; 000BBBBB:OOOOOOOO.  FROM THIS WE CAN EXTRACT THE MSB
; TO USE AS THE BANK NUMBER.  NOTE THAT THE "RAW" BANK NUMBER MUST THEN
; BE OFFSET TO THE START OF THE ROM/RAM BANKS.
; ALSO NOTE THAT THE HIGH BIT OF THE BANK NUMBER REPRESENTS "RAM" SO THIS
; BIT MUST ALSO BE SET ACCORDING TO THE UNIT BEING ADDRESSED.
;
; TO GET THE BYTE OFFSET, WE THEN RIGHT SHIFT THE LSB BY 1 TO GIVE US:
; 0OOOOOOO AND EXTRACT THE LSB TO REPRESENT THE MSB OF
; THE BYTE OFFSET.  THE LSB OF THE BYTE OFFSET IS ALWAYS 0 SINCE WE ARE
; DEALING WITH 512 BYTE BOUNDARIES.
;
MD_IOSETUP:
	LD	HL,(HSTLBALO)		; HL := LOW WORD OF LBA
	; ALIGN BITS TO EXTRACT BANK NUMBER FROM H
	SLA	L			; LEFT SHIFT ONE BIT
	RL	H			;   FULL WORD
	SLA	L			; LEFT SHIFT ONE BIT
	RL	H			;   FULL WORD
	LD	C,H			; BANK NUMBER FROM H TO C
	; GET BANK NUM TO A AND SET FLAG Z=ROM, NZ=RAM
	LD	A,(MD_UNIT)		; DEVICE/UNIT TO A
	AND	$01			; ISOLATE LOW BIT, SET ZF
	LD	A,C			; BANK VALUE INTO A
	PUSH	AF			; SAVE IT FOR NOW
	; ADJUST L TO HAVE MSB OF OFFSET
	SRL	L			; ADJUST L TO BE MSB OF BYTE OFFSET
	LD	H,L			; MOVE MSB TO H WHERE IT BELONGS
	LD	L,0			;   AND ZERO L SO HL IS NOW BYTE OFFSET
	; LOAD DESTINATION AND COUNT
	LD	DE,(MD_DSKBUF)		; DMA ADDRESS IS DESTINATION
	LD	BC,512			; ALWAYS COPY ONE SECTOR
	; FINISH UP
	POP	AF			; GET BANK AND FLAGS BACK
	JR	Z,MD_IOSETUP2		; DO ROM DRIVE, ELSE FALL THRU FOR RAM DRIVE
;
MD_IOSETUP1:	; RAM
	ADD	A,BID_RAMD0
	RET
;
MD_IOSETUP2:	; ROM
	ADD	A,BID_ROMD0
	RET
;
;
;
MD_PRT:
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL

	CALL	NEWLINE

	LD	DE,MDSTR_PREFIX	
	CALL	WRITESTR
	
	CALL	PC_SPACE
	LD	DE,MDSTR_SRC
	CALL	WRITESTR
	LD	A,(MD_SRCBNK)
	CALL	PRTHEXBYTE
	CALL	PC_COLON
	LD	BC,(MD_SRC)
	CALL	PRTHEXWORD
	
	CALL	PC_SPACE
	LD	DE,MDSTR_DST
	CALL	WRITESTR
	LD	A,(MD_DSTBNK)
	CALL	PRTHEXBYTE
	CALL	PC_COLON
	LD	BC,(MD_DST)
	CALL	PRTHEXWORD
	
	CALL	PC_SPACE
	LD	DE,MDSTR_LEN
	CALL	WRITESTR
	LD	BC,(MD_LEN)
	CALL	PRTHEXWORD
	
	POP	HL
	POP	DE
	POP	BC
	POP	AF

	RET
;
;
;
MD_UNIT		.DB	0
MD_DSKBUF	.DW	0
;
MD_SRCBNK	.DB	0
MD_DSTBNK	.DB	0
MD_SRC		.DW	0
MD_DST		.DW	0
MD_LEN		.DW	0
;
MDSTR_PREFIX	.TEXT	"MD:$"
MDSTR_SRC	.TEXT	"SRC=$"
MDSTR_DST	.TEXT	"DEST=$"
MDSTR_LEN	.TEXT	"LEN=$"