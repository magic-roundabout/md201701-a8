;
; MD201701
;

; Code by T.M.R/Cosine
; Music by Sack/Cosine


; Notes: this source is formatted for the Xasm cross assembler from
; https://github.com/pfusik/xasm
; Compression is handled with Exomizer 2 which can be downloaded at
; http://hem.bredband.net/magli143/exo/

; build.bat will call both to create an assembled file and then the
; crunched release version.


; Include binary data
		org $3400
		opt h-
		ins "data\neo_intro.xex"
		opt h+

		org $7c00
char_data	ins "data\charset.chr"


; Standard A8 register declarations
		icl "includes/registers.asm"


; Constants for scroller colours (to make them easier to tweak!)
split_col_0	equ $20
split_col_1	equ $f0
split_col_2	equ $e0
split_col_3	equ $d0
split_col_4	equ $c0
split_col_5	equ $b0
split_col_6	equ $a0
split_col_7	equ $90

split_col_8	equ $a0
split_col_9	equ $90
split_col_a	equ $80
split_col_b	equ $70
split_col_c	equ $60
split_col_d	equ $50
split_col_e	equ $40
split_col_f	equ $30


; Page 6 work space declarations
sync		equ $0600
cos_at_1	equ $0601
cos_at_2	equ $0602
cos_at_3	equ $0603
cos_at_4	equ $0604
buffer_pos	equ $0605
char_cnt	equ $0606
scroll_2_tmr	equ $0607


; Memory declarations
bitmap_data	equ $8000

scroll_work	equ $9000
scroll_ram_1	equ $9400
scroll_ram_2	equ $9440

translations	equ $9700
raster_buffer	equ $9800



; Display list
		org $5000
dlist		dta $70,$70,$30+$80

; Upper scroller area
		dta $47,<scroll_ram_1,>scroll_ram_1
		dta $10

; Colour bar area
dli_write_1	dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

dli_write_2	dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data
		dta $4f,<bitmap_data,>bitmap_data

; Lower scroller area
		dta $10
		dta $47,<scroll_ram_2,>scroll_ram_2

; End of display list
		dta $41,<dlist,>dlist


; Entry point
		run $5300
		org $5300

; Clear page 6
		ldx #$00
		txa
nuke_page6	sta $0600,x
		inx
		bne nuke_page6

; Clear buffers
		ldx #$00
		txa
rb_clear	sta raster_buffer+$000,x
		sta raster_buffer+$100,x
		sta raster_buffer+$200,x
		sta raster_buffer+$300,x
		sta raster_buffer+$400,x
		sta raster_buffer+$500,x
		inx
		bne rb_clear

; Set up RMT music
		lda #$00
		ldx #$00
		ldy #$40
		jsr $3400

; Set up vertical blank interrupt
		lda #$06
		ldx #>vblank
		ldy #<vblank
		jsr $e45c

; Set up display list / DLI
dl_init		lda #<dlist
		sta dlist_vector+$00
		lda #>dlist
		sta dlist_vector+$01

		lda #<dli
		sta dli_vector+$00
		lda #>dli
		sta dli_vector+$01
		lda #$c0
		sta nmi_en

; Enable overscan
		lda #$2f
		sta dma_ctrl_s

; Build sixteen lines of bitmap for the rasters
		lda #$03
		sta cos_at_1
		lda #$7c
		sta cos_at_2

		ldx #$00
bs_loop		lda #$00
		sta bitmap_data+$000,x
		lda #$11
		sta bitmap_data+$100,x
		lda #$22
		sta bitmap_data+$200,x
		lda #$33
		sta bitmap_data+$300,x
		lda #$44
		sta bitmap_data+$400,x
		lda #$55
		sta bitmap_data+$500,x
		lda #$66
		sta bitmap_data+$600,x
		lda #$77
		sta bitmap_data+$700,x
		lda #$88
		sta bitmap_data+$800,x
		lda #$99
		sta bitmap_data+$900,x
		lda #$aa
		sta bitmap_data+$a00,x
		lda #$bb
		sta bitmap_data+$b00,x
		lda #$cc
		sta bitmap_data+$c00,x
		lda #$dd
		sta bitmap_data+$d00,x
		lda #$ee
		sta bitmap_data+$e00,x
		lda #$ff
		sta bitmap_data+$f00,x
		inx
		bne bs_loop

; Build colour translation table for the rasters
		ldx #$00
bt_loop_1	txa
		sta translations,x
		inx
		cpx #$10
		bne bt_loop_1

bt_loop_2	txa
		clc
		adc #$10
		sta translations,x
		inx
		cpx #$f0
		bne bt_loop_2

bt_loop_3	txa
		clc
		adc #$20
		sta translations,x
		inx
		bne bt_loop_3


; Initialise the upper scroller
		lda >scroll_work
		sta char_base_s

		ldx #$00
		txa
scroll_1_init	sta scroll_ram_1,x
		clc
		adc #$01
		inx
		cpx #$30
		bne scroll_1_init

		ldx #$00
		txa
scroll_1_clear	sta scroll_work+$000,x
		inx
		bne scroll_1_clear

		jsr reset_1

; Initialise the lower scroller
		ldx #$00
		txa
scroll_2_clear	sta scroll_ram_2,x
		inx
		cpx #$30
		bne scroll_2_clear

		lda #$20
		sta scroll_2_tmr

		jsr reset_2


; Main runtime loop to update the rasters
main_loop	jsr sync_wait

		lda buffer_pos
		clc
		adc #$01
		cmp #$06
		bcc *+$04
		lda #$00
		sta buffer_pos

		clc
		adc #>raster_buffer
		tax

		stx db_write_1+$02
		stx db_write_2+$02
		stx dli_render_1+$02
		stx dli_render_2+$02
		stx splitter+$02
		stx split_write+$02

		lda cos_at_1
		clc
		adc #$03
		cmp #$fb
		bcc *+$05
		clc
		adc #$0b
		sta cos_at_1

		lda cos_at_2
		clc
		adc #$02
		sta cos_at_2


		lda cos_at_3
		clc
		adc #$03
		cmp #$fb
		bcc *+$05
		clc
		adc #$0b
		sta cos_at_3

		lda cos_at_4
		clc
		adc #$01
		sta cos_at_4

; Draw in a purple bar
		ldx cos_at_1
		ldy cos_at_2
		lda bar_cosinus,x
		clc
		adc bar_cosinus,y
		clc
		adc #$02
		tay
		ldx #$00
draw_bar_1	lda shades,x
		ora #$40
db_write_1	sta raster_buffer,y
		iny
		inx
		cpx #$1f
		bne draw_bar_1

; Draw in a grey bar
		ldx cos_at_3
		ldy cos_at_4
		lda bar_cosinus,x
		clc
		adc bar_cosinus,y
		clc
		adc #$02
		tay
		ldx #$00
draw_bar_2	lda shades,x
db_write_2	sta raster_buffer,y
		iny
		inx
		cpx #$1f
		bne draw_bar_2

; Update the display list
		ldx #$00
		ldy #$00
dli_render_1	lda raster_buffer,x
		and #$0f
		ora #>bitmap_data
		sta dli_write_1+$02,y
		iny
		iny
		iny
		inx
		cpx #$50
		bne dli_render_1

		ldy #$00
dli_render_2	lda raster_buffer,x
		and #$0f
		ora #>bitmap_data
		sta dli_write_2+$02,y
		iny
		iny
		iny
		inx
		cpx #$a0
		bne dli_render_2

		jmp main_loop


; Wait for sync from the DLI
sync_wait	lda #$00
		sta sync
sw_loop		cmp sync
		beq sw_loop
		rts


; Vertical blank interrupt
vblank		lda #$00
		sta attract_timer

; Play RMT music
		jsr $3403

; Exit interrupt
		jmp $e45f


; Display list interrupt
dli		pha
		txa
		pha
		tya
		pha

; Colour splitter for the upper scroller
		sta wsync
		sta wsync
		sta wsync

		nop
		nop
		bit $ea

		lda #split_col_0+$00		; scanline 02
		sta col_pfield0
		nop
		lda #split_col_1+$00
		ldx #split_col_2+$00
		ldy #split_col_3+$00
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$00
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$00
		sta col_pfield0
		bit $ea
		lda #split_col_6+$00
		sta col_pfield0
		bit $ea
		lda #split_col_7+$00
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$02		; scanline 03
		sta col_pfield0
		nop
		lda #split_col_1+$02
		ldx #split_col_2+$02
		ldy #split_col_3+$02
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$02
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$02
		sta col_pfield0
		bit $ea
		lda #split_col_6+$02
		sta col_pfield0
		bit $ea
		lda #split_col_7+$02
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$04		; scanline 04
		sta col_pfield0
		nop
		lda #split_col_1+$04
		ldx #split_col_2+$04
		ldy #split_col_3+$04
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$04
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$04
		sta col_pfield0
		bit $ea
		lda #split_col_6+$04
		sta col_pfield0
		bit $ea
		lda #split_col_7+$04
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$06		; scanline 05
		sta col_pfield0
		nop
		lda #split_col_1+$06
		ldx #split_col_2+$06
		ldy #split_col_3+$06
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$06
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$06
		sta col_pfield0
		bit $ea
		lda #split_col_6+$06
		sta col_pfield0
		bit $ea
		lda #split_col_7+$06
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$08		; scanline 06
		sta col_pfield0
		nop
		lda #split_col_1+$08
		ldx #split_col_2+$08
		ldy #split_col_3+$08
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$08
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$08
		sta col_pfield0
		bit $ea
		lda #split_col_6+$08
		sta col_pfield0
		bit $ea
		lda #split_col_7+$08
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$0a		; scanline 07
		sta col_pfield0
		nop
		lda #split_col_1+$0a
		ldx #split_col_2+$0a
		ldy #split_col_3+$0a
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$0a
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_6+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_7+$0a
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$0c		; scanline 08
		sta col_pfield0
		nop
		lda #split_col_1+$0c
		ldx #split_col_2+$0c
		ldy #split_col_3+$0c
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$0c
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_6+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_7+$0c
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$0e		; scanline 09
		sta col_pfield0
		nop
		lda #split_col_1+$0e
		ldx #split_col_2+$0e
		ldy #split_col_3+$0e
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$0e
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$0e
		sta col_pfield0
		bit $ea
		lda #split_col_6+$0e
		sta col_pfield0
		bit $ea
		lda #split_col_7+$0e
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$0c		; scanline 0a
		sta col_pfield0
		nop
		lda #split_col_1+$0c
		ldx #split_col_2+$0c
		ldy #split_col_3+$0c
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$0c
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_6+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_7+$0c
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$0a		; scanline 0b
		sta col_pfield0
		nop
		lda #split_col_1+$0a
		ldx #split_col_2+$0a
		ldy #split_col_3+$0a
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$0a
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_6+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_7+$0a
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$08		; scanline 0c
		sta col_pfield0
		nop
		lda #split_col_1+$08
		ldx #split_col_2+$08
		ldy #split_col_3+$08
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$08
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$08
		sta col_pfield0
		bit $ea
		lda #split_col_6+$08
		sta col_pfield0
		bit $ea
		lda #split_col_7+$08
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$06		; scanline 0d
		sta col_pfield0
		nop
		lda #split_col_1+$06
		ldx #split_col_2+$06
		ldy #split_col_3+$06
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$06
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$06
		sta col_pfield0
		bit $ea
		lda #split_col_6+$06
		sta col_pfield0
		bit $ea
		lda #split_col_7+$06
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$04		; scanline 0e
		sta col_pfield0
		nop
		lda #split_col_1+$04
		ldx #split_col_2+$04
		ldy #split_col_3+$04
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$04
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$04
		sta col_pfield0
		bit $ea
		lda #split_col_6+$04
		sta col_pfield0
		bit $ea
		lda #split_col_7+$04
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_0+$02		; scanline 0f
		sta col_pfield0
		nop
		lda #split_col_1+$02
		ldx #split_col_2+$02
		ldy #split_col_3+$02
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_4+$02
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_5+$02
		sta col_pfield0
		bit $ea
		lda #split_col_6+$02
		sta col_pfield0
		bit $ea
		lda #split_col_7+$02
		sta col_pfield0

		nop
		nop

		lda #$00
		sta col_pfield0

; Enable GTIA
		lda #$40
		sta priority
		sta wsync

; Colour splitter for the bitmapped bars
		ldx #$00
splitter	ldy raster_buffer,x
		sta wsync
		tya
		and #$f0
		sta col_bgnd
		lda translations,y
split_write	sta raster_buffer,x
		inx
		cpx #$a0
		bne splitter

; Turn off GTIA
		lda #$00
		sta wsync
		sta col_bgnd
		sta priority

; Colour splitter for the lower scroller
		sta wsync
		sta wsync
		lda #>char_data
		sta char_base
		sta wsync
		sta wsync

		nop
		nop
		bit $ea

		lda #split_col_8+$00		; scanline 02
		sta col_pfield0
		nop
		lda #split_col_9+$00
		ldx #split_col_a+$00
		ldy #split_col_b+$00
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$00
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$00
		sta col_pfield0
		bit $ea
		lda #split_col_e+$00
		sta col_pfield0
		bit $ea
		lda #split_col_f+$00
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$02		; scanline 03
		sta col_pfield0
		nop
		lda #split_col_9+$02
		ldx #split_col_a+$02
		ldy #split_col_b+$02
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$02
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$02
		sta col_pfield0
		bit $ea
		lda #split_col_e+$02
		sta col_pfield0
		bit $ea
		lda #split_col_f+$02
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$04		; scanline 04
		sta col_pfield0
		nop
		lda #split_col_9+$04
		ldx #split_col_a+$04
		ldy #split_col_b+$04
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$04
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$04
		sta col_pfield0
		bit $ea
		lda #split_col_e+$04
		sta col_pfield0
		bit $ea
		lda #split_col_f+$04
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$06		; scanline 05
		sta col_pfield0
		nop
		lda #split_col_9+$06
		ldx #split_col_a+$06
		ldy #split_col_b+$06
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$06
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$06
		sta col_pfield0
		bit $ea
		lda #split_col_e+$06
		sta col_pfield0
		bit $ea
		lda #split_col_f+$06
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$08		; scanline 06
		sta col_pfield0
		nop
		lda #split_col_9+$08
		ldx #split_col_a+$08
		ldy #split_col_b+$08
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$08
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$08
		sta col_pfield0
		bit $ea
		lda #split_col_e+$08
		sta col_pfield0
		bit $ea
		lda #split_col_f+$08
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$0a		; scanline 07
		sta col_pfield0
		nop
		lda #split_col_9+$0a
		ldx #split_col_a+$0a
		ldy #split_col_b+$0a
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$0a
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_e+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_f+$0a
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$0c		; scanline 08
		sta col_pfield0
		nop
		lda #split_col_9+$0c
		ldx #split_col_a+$0c
		ldy #split_col_b+$0c
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$0c
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_e+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_f+$0c
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$0e		; scanline 09
		sta col_pfield0
		nop
		lda #split_col_9+$0e
		ldx #split_col_a+$0e
		ldy #split_col_b+$0e
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$0e
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$0e
		sta col_pfield0
		bit $ea
		lda #split_col_e+$0e
		sta col_pfield0
		bit $ea
		lda #split_col_f+$0e
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$0c		; scanline 0a
		sta col_pfield0
		nop
		lda #split_col_9+$0c
		ldx #split_col_a+$0c
		ldy #split_col_b+$0c
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$0c
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_e+$0c
		sta col_pfield0
		bit $ea
		lda #split_col_f+$0c
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$0a		; scanline 0b
		sta col_pfield0
		nop
		lda #split_col_9+$0a
		ldx #split_col_a+$0a
		ldy #split_col_b+$0a
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$0a
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_e+$0a
		sta col_pfield0
		bit $ea
		lda #split_col_f+$0a
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$08		; scanline 0c
		sta col_pfield0
		nop
		lda #split_col_9+$08
		ldx #split_col_a+$08
		ldy #split_col_b+$08
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$08
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$08
		sta col_pfield0
		bit $ea
		lda #split_col_e+$08
		sta col_pfield0
		bit $ea
		lda #split_col_f+$08
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$06		; scanline 0d
		sta col_pfield0
		nop
		lda #split_col_9+$06
		ldx #split_col_a+$06
		ldy #split_col_b+$06
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$06
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$06
		sta col_pfield0
		bit $ea
		lda #split_col_e+$06
		sta col_pfield0
		bit $ea
		lda #split_col_f+$06
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$04		; scanline 0e
		sta col_pfield0
		nop
		lda #split_col_9+$04
		ldx #split_col_a+$04
		ldy #split_col_b+$04
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$04
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$04
		sta col_pfield0
		bit $ea
		lda #split_col_e+$04
		sta col_pfield0
		bit $ea
		lda #split_col_f+$04
		sta col_pfield0

		nop
		nop
		nop
		nop
		nop

		lda #split_col_8+$02		; scanline 0f
		sta col_pfield0
		nop
		lda #split_col_9+$02
		ldx #split_col_a+$02
		ldy #split_col_b+$02
		nop
		sta col_pfield0
		nop
		stx col_pfield0
		lda #split_col_c+$02
		sty col_pfield0
		bit $ea
		sta col_pfield0
		bit $ea
		lda #split_col_d+$02
		sta col_pfield0
		bit $ea
		lda #split_col_e+$02
		sta col_pfield0
		bit $ea
		lda #split_col_f+$02
		sta col_pfield0

		nop
		nop

		lda #$00
		sta col_pfield0


; Update the upper scroller
		ldx #$01
mover_1		asl scroll_work+$0c0,x
;		rol scroll_work+$0b8,x
		rol scroll_work+$0b0,x
		rol scroll_work+$0a8,x
		rol scroll_work+$0a0,x
		rol scroll_work+$098,x
		rol scroll_work+$090,x
		rol scroll_work+$088,x
		rol scroll_work+$080,x
		rol scroll_work+$078,x
		rol scroll_work+$070,x
		rol scroll_work+$068,x
		rol scroll_work+$060,x
		rol scroll_work+$058,x
		rol scroll_work+$050,x
		rol scroll_work+$048,x
		rol scroll_work+$040,x
		rol scroll_work+$038,x
		rol scroll_work+$030,x
		rol scroll_work+$028,x
		rol scroll_work+$020,x
		rol scroll_work+$018,x
		rol scroll_work+$010,x
		rol scroll_work+$008,x
;		rol scroll_work+$000,x
		inx
		cpx #$08
		bne mover_1

; Check if we're fetching a new character
		ldx char_cnt
		inx
		cpx #$08
		bne cc_xb

mread_1		lda scroll_text_1
		cmp #$ff
		bne okay_1
		jsr reset_1
		jmp mread_1

okay_1		sta def_copy+$01
		lda #$00
		asl def_copy+$01
		rol @
		asl def_copy+$01
		rol @
		asl def_copy+$01
		rol @
		clc
		adc >char_data
		sta def_copy+$02

; Grab the character definition
		ldx #$01
def_copy	lda char_data,x
;		eor #$ff
		sta scroll_work+$0c0,x
		inx
		cpx #$08
		bne def_copy

		inc mread_1+$01
		bne *+$05
		inc mread_1+$02

		ldx #$00
cc_xb		stx char_cnt

; Update the lower scroller if need be
		ldx scroll_2_tmr
		cpx #$18
		bcs scroll_2_skip

		ldx #$00
mover_2		lda scroll_ram_2+$01,x
		sta scroll_ram_2+$00,x
		inx
		cpx #$17
		bne mover_2

mread_2		lda scroll_text_2
		cmp #$ff
		bne okay_2
		jsr reset_2
		jmp mread_2

okay_2		sta scroll_ram_2+$17

		inc mread_2+$01
		bne *+$05
		inc mread_2+$02

scroll_2_skip	inc scroll_2_tmr


; Set the runtime sync for the bar update code
		lda #$01
		sta sync

; Bail the DLI
		pla
		tay
		pla
		tax
		pla
		rti


; Self mod reset for the scrollers
reset_1		lda <scroll_text_1
		sta mread_1+$01
		lda >scroll_text_1
		sta mread_1+$02

		rts

reset_2		lda <scroll_text_2
		sta mread_2+$01
		lda >scroll_text_2
		sta mread_2+$02

		rts


; Shade data for the moving bars
shades		dta $00,$01,$02,$03,$04,$05,$06,$07
		dta $08,$09,$0a,$0b,$0c,$0d,$0e,$0f
		dta $0e,$0d,$0c,$0b,$0a,$09,$08,$07
		dta $06,$05,$04,$03,$02,$01,$00

; Cosine table for the moving bars
bar_cosinus	dta $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
		dta $3f,$3f,$3f,$3e,$3e,$3e,$3e,$3d
		dta $3d,$3d,$3c,$3c,$3c,$3b,$3b,$3b
		dta $3a,$3a,$39,$39,$38,$38,$37,$37
		dta $36,$36,$35,$34,$34,$33,$33,$32
		dta $31,$31,$30,$2f,$2f,$2e,$2d,$2c
		dta $2c,$2b,$2a,$29,$29,$28,$27,$26
		dta $26,$25,$24,$23,$23,$22,$21,$20

		dta $1f,$1f,$1e,$1d,$1c,$1c,$1b,$1a
		dta $19,$18,$18,$17,$16,$15,$15,$14
		dta $13,$12,$12,$11,$10,$10,$0f,$0e
		dta $0e,$0d,$0c,$0c,$0b,$0b,$0a,$09
		dta $09,$08,$08,$07,$07,$06,$06,$05
		dta $05,$04,$04,$04,$03,$03,$03,$02
		dta $02,$02,$01,$01,$01,$01,$00,$00
		dta $00,$00,$00,$00,$00,$00,$00,$00

		dta $00,$00,$00,$00,$00,$00,$00,$00
		dta $00,$00,$00,$01,$01,$01,$01,$02
		dta $02,$02,$03,$03,$03,$04,$04,$05
		dta $05,$05,$06,$06,$07,$07,$08,$08
		dta $09,$0a,$0a,$0b,$0b,$0c,$0d,$0d
		dta $0e,$0f,$0f,$10,$11,$11,$12,$13
		dta $13,$14,$15,$16,$16,$17,$18,$19
		dta $19,$1a,$1b,$1c,$1d,$1d,$1e,$1f

		dta $20,$20,$21,$22,$23,$24,$24,$25
		dta $26,$27,$27,$28,$29,$2a,$2a,$2b
		dta $2c,$2d,$2d,$2e,$2f,$2f,$30,$31
		dta $31,$32,$33,$33,$34,$35,$35,$36
		dta $36,$37,$37,$38,$38,$39,$39,$3a
		dta $3a,$3b,$3b,$3b,$3c,$3c,$3d,$3d
		dta $3d,$3d,$3e,$3e,$3e,$3e,$3f,$3f
		dta $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f

; Text for the upper scroller
scroll_text_1	dta d"IT'S THE FIRST DAY OF 2017 AND TIME FOR YET "
		dta d"ANOTHER FLURRY OF RASTER BARS FROM THE "
		dta d"DEPTHS OF COSINE'S BIT BUCKET!   WELCOME "
		dta d"GIRLS AND BOYS TO..."
		dta d"    "

		dta d"-=- MD201701 -=-"
		dta d"    "

		dta d"WE'VE GOT TWO VERTICALLY SPLIT SCROLLERS AND "
		dta d"SOME COLOURFUL ""INFINITE RASTERS"" TO "
		dta d"WATCH..."
		dta d"    "

		dta d"ELEVENTH HOUR PROTOTYPE WRANGLING BY T.M.R, "
		dta d"WITH MUSIC PROVIDED BY SACK!"
		dta d"    "

		dta d"I DO LIKE THE NEW YEARS DISK, IT'S A GREAT "
		dta d"OPPORTUNITY FOR ME TO LOOK THROUGH ALL THE "
		dta d"PROTOTYPES I'VE GOT SQUIRRELED AWAY TO SEE "
		dta d"IF A COUPLE CAN BE CRAMMED TOGETHER FOR A "
		dta d"ONE-PARTER!"
		dta d"    "

		dta d"AS ALWAYS, THINGS ARE NOT AS THEY INITIALLY "
		dta d"APPEAR; THIS SCROLLER IS CHARACTER-BASED BUT "
		dta d"THE MOVEMENT IS HANDLED IN SOFTWARE (IT'S A "
		dta d"ROL SCROLLER) TO AVOID DEALING WITH THE TIMING "
		dta d"ISSUES I GOT WHEN ALTERING THE HARDWARE SCROLL "
		dta d"REGISTER WHILST THESE SPLITS WERE HAPPENING."
		dta d"    "

		dta d"I'M ALSO SKIPPING THE TOP PIXEL LINE, BUT EACH "
		dta d"VISIBLE SCANLINE AFTER THAT HAS EIGHT COLOUR "
		dta d"SPLITS WHICH WERE ALL TIMED TO THE SAME WIDTH "
		dta d"BECAUSE THAT SEEMED LIKE A ""FUN IDEA"" AT "
		dta d"THE TIME!"
		dta d"    "

		dta d"THE MOVING COLOUR BARS ARE A LITTLE MORE "
		dta d"COMPLEX THAN THEY SEEM TOO, BECAUSE EACH "
		dta d"SCANLINE SEES A HUE VALUE WRITTEN TO THE "
		dta d"BACKGROUND COLOUR BUT THE LUMINANCE IS "
		dta d"PROVIDED BY ONE OF SIXTEEN LINES OF BITMAP "
		dta d"DATA VIA THE DISPLAY LIST SO I CAN USE ANY "
		dta d"COLOUR IN THE PALETTE."
		dta d"    "

		dta d"THERE ARE ALSO SIX BUFFERS IN PLAY AND THE "
		dta d"COLOURS ARE UPDATED EACH TIME A BUFFER IS "
		dta d"DISPLAYED TO MAKE THINGS LOOK BUSIER..."
		dta d"    "

		dta d"I HAVE BEEN PONDERING FOR A FEW DAYS ABOUT "
		dta d"THIS BEING THE START OF ""SEASON TWO"" FOR "
		dta d"COSINE'S MONTHLY DEMO SERIES;  I'VE FOUND "
		dta d"THAT THE IDEA OF KNOCKING OUT A SMALL "
		dta d"ONE-FILER EACH MONTH IS FUN TO BEGIN WITH "
		dta d"BUT IT'S REMARKABLY EASY TO GET BOGGED DOWN "
		dta d"BY THINGS AND THE IDEAS WELL RAN DRY LAST "
		dta d"YEAR SO I HAD TO TAKE A BREAK..."
		dta d"    "

		dta d"THE ""PLAN"" (I'VE JUST REALISED THAT I USE "
		dta d"THAT WORD FAR TOO OFTEN AND ALMOST ALWAYS "
		dta d"SARCASTICALLY) THIS TIME AROUND IS TO GET "
		dta d"AHEAD OF THE CURVE AND HAVE SOME RELEASES "
		dta d"IN RESERVE FOR THOSE MONTHS NEAR THE END "
		dta d"OF THE YEAR WHERE THINGS GET ON TOP OF ME, "
		dta d"BUT I'M MAKING NO SOLID PROMISES THIS EARLY "
		dta d"IN THE GAME!"
		dta d"    "

		dta d"EITHER WAY, I HOPE EVERYONE HAS BEEN "
		dta d"ENJOYING THE PRETTY COLOURS AND SACK'S "
		dta d"MUSIC BECAUSE THE TEXT HAS JUST BEEN "
		dta d"MEMORY-FILLING WAFFLE AND I'M PRETTY MUCH "
		dta d"DONE NOW!"
		dta d"    "

		dta d"WHY NOT VISIT THE COSINE WEBSITE OVER AT "
		dta d"HTTP://COSINE.ORG.UK/ IF YOU WANT MORE OF "
		dta d"THE SAME (ESPECIALLY IF YOU ENJOY RASTER "
		dta d"BARS AND HASTILY WRITTEN SCROLLTEXTS) AND "
		dta d"THIS HAS BEEN T.M.R OF COSINE SIGNING OFF "
		dta d"ON 2017-01-01 - HAPPY NEW YEAR AND ALL "
		dta d"THAT GUBBINS... .. .  ."
		dta d"            "

		dta $ff		; end of text marker


; Text for the lower scroller
scroll_text_2	dta d"  GREETINGS GO OUT TO:  "
		dta d"    ABSENCE    ABYSS    "
		dta d"      ARKANIX LABS      "
		dta d"   ARTSTATE   ATE BIT   "
		dta d"   ATLANTIS   BOOZE D   "
		dta d"  CAMELOT     CENSOR D  "
		dta d"  CHORUS  CHROME  CNCD  "
		dta d"  CPU  CRESCENT  CREST  "
		dta d"     COVERT  BITOPS     "
		dta d"     DEFENCE  FORCE     "
		dta d"   DEKADENCE   DESIRE   "
		dta d"      DAC   DMAGIC      "
		dta d"        DUALCREW        "
		dta d"      EXCLUSIVE ON      "
		dta d"   FAIRLIGHT     F4CG   "
		dta d"     FIRE    FLAT 3     "
		dta d"  FOCUS   FRENCH TOUCH  "
		dta d"  FSP  GENESIS PROJECT  "
		dta d"  GHEYMAID INC  HITMEN  "
		dta d"      HOKUTO FORCE      "
		dta d"  LOD   LEVEL 64   MON  "
		dta d"   MAYDAY    MEANTEAM   "
		dta d"   METALVOTZE  NONAME   "
		dta d"  NOSTALGIA     NUANCE  "
		dta d"   OFFENCE  ONSLAUGHT   "
		dta d"  ORB   OXYRON   PADUA  "
		dta d"   PERFORMERS   PLUSH   "
		dta d"    PPCS   PSYTRONIK    "
		dta d"  REPTILIA    RESOURCE  "
		dta d"     RGCD    SECURE     "
		dta d"    SHAPE     SIDE B    "
		dta d"   SINGULAR     SLASH   "
		dta d"       SLIPSTREAM       "
		dta d"   SUCCESS AND T.R.C.   "
		dta d"  STYLE   SUICYCO IND.  "
		dta d"   TAQUART    TEMPEST   "
		dta d"  TEK    TRIAD    TRSI  "
		dta d"  VIRUZ   VISION   WOW  "
		dta d"     WRATH    XENON     "
		dta d"   ANYBODY WE FORGOT!   "
		dta d"                        "

		dta $ff		; end of text marker
