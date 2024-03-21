
_interrupt:

;MyGeiger_NT.mbas,477 :: 		sub procedure interrupt()             ' Interrupt Settings
;MyGeiger_NT.mbas,479 :: 		if (TMR0IF_bit = 1) then
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L__interrupt2
;MyGeiger_NT.mbas,480 :: 		LATA.5  = 0                        ' turn off podkachka
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,481 :: 		T0CON = %01001000
	MOVLW       72
	MOVWF       T0CON+0 
;MyGeiger_NT.mbas,482 :: 		TMR0IF_bit = 0
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
L__interrupt2:
;MyGeiger_NT.mbas,485 :: 		if (TMR3IF_bit = 1) then
	BTFSS       TMR3IF_bit+0, BitPos(TMR3IF_bit+0) 
	GOTO        L__interrupt5
;MyGeiger_NT.mbas,486 :: 		if (buzzer_counter = 4) then
	MOVF        _buzzer_counter+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt8
;MyGeiger_NT.mbas,487 :: 		LATB.3 = 0
	BCF         LATB+0, 3 
;MyGeiger_NT.mbas,488 :: 		buzzer_counter = 0
	CLRF        _buzzer_counter+0 
;MyGeiger_NT.mbas,489 :: 		buzzer_started = 0
	BCF         _buzzer_started+0, BitPos(_buzzer_started+0) 
;MyGeiger_NT.mbas,490 :: 		TMR3ON_bit = 0
	BCF         TMR3ON_bit+0, BitPos(TMR3ON_bit+0) 
	GOTO        L__interrupt9
;MyGeiger_NT.mbas,491 :: 		else
L__interrupt8:
;MyGeiger_NT.mbas,492 :: 		if buzzer_started = 1 then
	BTFSS       _buzzer_started+0, BitPos(_buzzer_started+0) 
	GOTO        L__interrupt11
;MyGeiger_NT.mbas,493 :: 		LATB.3 = not LATB.3
	BTG         LATB+0, 3 
L__interrupt11:
;MyGeiger_NT.mbas,495 :: 		inc (buzzer_counter)
	INCF        _buzzer_counter+0, 1 
;MyGeiger_NT.mbas,496 :: 		end if
L__interrupt9:
;MyGeiger_NT.mbas,497 :: 		TMR3H = 0xFF
	MOVLW       255
	MOVWF       TMR3H+0 
;MyGeiger_NT.mbas,498 :: 		TMR3L = 0x91                       'd2
	MOVLW       145
	MOVWF       TMR3L+0 
;MyGeiger_NT.mbas,500 :: 		TMR3IF_bit = 0
	BCF         TMR3IF_bit+0, BitPos(TMR3IF_bit+0) 
L__interrupt5:
;MyGeiger_NT.mbas,505 :: 		if (TMR1IF_bit = 1) then             ' Test Timer1 interrupt flag
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L__interrupt14
;MyGeiger_NT.mbas,507 :: 		if(b_count = 4) then               ' let check buttons every 250 ms
	MOVF        _b_count+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt17
;MyGeiger_NT.mbas,508 :: 		b_count = 0
	CLRF        _b_count+0 
;MyGeiger_NT.mbas,509 :: 		button_check = 1
	BSF         _button_check+0, BitPos(_button_check+0) 
	GOTO        L__interrupt18
;MyGeiger_NT.mbas,510 :: 		else
L__interrupt17:
;MyGeiger_NT.mbas,511 :: 		inc(b_count)
	INCF        _b_count+0, 1 
;MyGeiger_NT.mbas,512 :: 		end if
L__interrupt18:
;MyGeiger_NT.mbas,514 :: 		if(sek_counter = 19) then          ' secund is over timer
	MOVF        _sek_counter+0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt20
;MyGeiger_NT.mbas,515 :: 		sek_counter = 0
	CLRF        _sek_counter+0 
;MyGeiger_NT.mbas,516 :: 		sek_cnt = cnt_s
	MOVF        _cnt_s+0, 0 
	MOVWF       _sek_cnt+0 
	MOVF        _cnt_s+1, 0 
	MOVWF       _sek_cnt+1 
;MyGeiger_NT.mbas,517 :: 		cnt_s = 0
	CLRF        _cnt_s+0 
	CLRF        _cnt_s+1 
;MyGeiger_NT.mbas,518 :: 		sek_over = 1
	BSF         _sek_over+0, BitPos(_sek_over+0) 
	GOTO        L__interrupt21
;MyGeiger_NT.mbas,519 :: 		else
L__interrupt20:
;MyGeiger_NT.mbas,520 :: 		inc(sek_counter)
	INCF        _sek_counter+0, 1 
;MyGeiger_NT.mbas,521 :: 		end if
L__interrupt21:
;MyGeiger_NT.mbas,523 :: 		if(timer_cnt = m_period) then      ' When time elapsed    m_period
	MOVF        _timer_cnt+0, 0 
	XORWF       _m_period+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt23
;MyGeiger_NT.mbas,524 :: 		counts = cnt                     ' Store result in counts
	MOVF        _cnt+0, 0 
	MOVWF       _counts+0 
	MOVF        _cnt+1, 0 
	MOVWF       _counts+1 
;MyGeiger_NT.mbas,525 :: 		cnt = 0                          ' Reset counter
	CLRF        _cnt+0 
	CLRF        _cnt+1 
;MyGeiger_NT.mbas,526 :: 		timer_cnt = 0                    ' Reset timer_cnt
	CLRF        _timer_cnt+0 
;MyGeiger_NT.mbas,527 :: 		cpm_read_done = 1                ' Set flag = 1
	BSF         _cpm_read_done+0, BitPos(_cpm_read_done+0) 
	GOTO        L__interrupt24
;MyGeiger_NT.mbas,528 :: 		else
L__interrupt23:
;MyGeiger_NT.mbas,529 :: 		inc(timer_cnt)                   ' Increment timer_cnt if not elapsed 10 second
	INCF        _timer_cnt+0, 1 
;MyGeiger_NT.mbas,530 :: 		end if
L__interrupt24:
;MyGeiger_NT.mbas,532 :: 		TMR1H = 0xE7                       ' First write higher byte to TMR1 0xCF2C
	MOVLW       231
	MOVWF       TMR1H+0 
;MyGeiger_NT.mbas,533 :: 		TMR1L = 0x96                       ' Write lower byte to TMR1
	MOVLW       150
	MOVWF       TMR1L+0 
;MyGeiger_NT.mbas,536 :: 		TMR1IF_bit = 0                     ' Clear Timer1 interrupt flag
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
L__interrupt14:
;MyGeiger_NT.mbas,539 :: 		if(INT0F_bit) then                   ' Test RB0/INT interrupt flag
	BTFSS       INT0F_bit+0, BitPos(INT0F_bit+0) 
	GOTO        L__interrupt26
;MyGeiger_NT.mbas,540 :: 		cnt = cnt + 1                      ' Count interrupts on RB0/INT pin
	INFSNZ      _cnt+0, 1 
	INCF        _cnt+1, 1 
;MyGeiger_NT.mbas,541 :: 		cnt_s = cnt_s + 1
	INFSNZ      _cnt_s+0, 1 
	INCF        _cnt_s+1, 1 
;MyGeiger_NT.mbas,542 :: 		if probe = 0x00 then
	MOVF        _probe+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt29
;MyGeiger_NT.mbas,543 :: 		LATA.5  = 1                        ' Turn on podka4ka
	BSF         LATA+0, 5 
;MyGeiger_NT.mbas,545 :: 		TMR0L   = timer_byte               ' set timer
	MOVF        _timer_byte+0, 0 
	MOVWF       TMR0L+0 
;MyGeiger_NT.mbas,546 :: 		T0CON = %11001000                  ' start timer
	MOVLW       200
	MOVWF       T0CON+0 
L__interrupt29:
;MyGeiger_NT.mbas,549 :: 		if sound = 1 then
	BTFSS       _sound+0, BitPos(_sound+0) 
	GOTO        L__interrupt32
;MyGeiger_NT.mbas,550 :: 		buzzer_started = 1
	BSF         _buzzer_started+0, BitPos(_buzzer_started+0) 
;MyGeiger_NT.mbas,551 :: 		buzzer_counter = 0
	CLRF        _buzzer_counter+0 
;MyGeiger_NT.mbas,552 :: 		LATB.3 = 1
	BSF         LATB+0, 3 
;MyGeiger_NT.mbas,553 :: 		TMR3H = 0xFF
	MOVLW       255
	MOVWF       TMR3H+0 
;MyGeiger_NT.mbas,554 :: 		TMR3L = 0x91
	MOVLW       145
	MOVWF       TMR3L+0 
;MyGeiger_NT.mbas,555 :: 		TMR3ON_bit = 1
	BSF         TMR3ON_bit+0, BitPos(TMR3ON_bit+0) 
L__interrupt32:
;MyGeiger_NT.mbas,557 :: 		INT0F_bit = 0                      ' Clear RB0/INT interrupt flag
	BCF         INT0F_bit+0, BitPos(INT0F_bit+0) 
L__interrupt26:
;MyGeiger_NT.mbas,561 :: 		end sub
L_end_interrupt:
L__interrupt805:
	RETFIE      1
; end of _interrupt

_InitLCD:

;MyGeiger_NT.mbas,566 :: 		sub procedure InitLCD()
;MyGeiger_NT.mbas,567 :: 		rreset = 1
	BSF         PORTC+0, 7 
;MyGeiger_NT.mbas,568 :: 		ddata  = 0
	BCF         PORTC+0, 6 
;MyGeiger_NT.mbas,569 :: 		Soft_SPI_Write (RESETD)
	MOVLW       226
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,570 :: 		delay_us(2000)
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L__InitLCD35:
	DECFSZ      R13, 1, 1
	BRA         L__InitLCD35
	DECFSZ      R12, 1, 1
	BRA         L__InitLCD35
	NOP
	NOP
;MyGeiger_NT.mbas,571 :: 		rreset = 0
	BCF         PORTC+0, 7 
;MyGeiger_NT.mbas,572 :: 		delay_us(2000)
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L__InitLCD36:
	DECFSZ      R13, 1, 1
	BRA         L__InitLCD36
	DECFSZ      R12, 1, 1
	BRA         L__InitLCD36
	NOP
	NOP
;MyGeiger_NT.mbas,573 :: 		rreset = 1
	BSF         PORTC+0, 7 
;MyGeiger_NT.mbas,574 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__InitLCD37:
	DECFSZ      R13, 1, 1
	BRA         L__InitLCD37
	DECFSZ      R12, 1, 1
	BRA         L__InitLCD37
	NOP
	NOP
;MyGeiger_NT.mbas,575 :: 		Soft_SPI_Write (CLEAR_ADC)
	MOVLW       160
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,576 :: 		Soft_SPI_Write (CLEAR_BIAS)
	MOVLW       162
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,577 :: 		Soft_SPI_Write (%00101111)              ' power control
	MOVLW       47
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,578 :: 		Soft_SPI_Write (%00100100)              ' LCD contrast level 4
	MOVLW       36
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,581 :: 		Soft_SPI_Write (SET_SHL)
	MOVLW       200
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,582 :: 		Soft_SPI_Write (0x40)                   ' initial dispaly line  COM0
	MOVLW       64
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,583 :: 		Soft_SPI_Write (DISPLAY_ON)
	MOVLW       175
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,585 :: 		end sub
L_end_InitLCD:
	RETURN      0
; end of _InitLCD

_ClearLCD:

;MyGeiger_NT.mbas,588 :: 		dim cl, cnn as byte
;MyGeiger_NT.mbas,589 :: 		for cl = 176 to 183 step 1            ' clear whole display   183 176
	MOVLW       176
	MOVWF       ClearLCD_cl+0 
L__ClearLCD40:
;MyGeiger_NT.mbas,590 :: 		ddata = 0
	BCF         PORTC+0, 6 
;MyGeiger_NT.mbas,591 :: 		Soft_SPI_Write(cl)             ' set page from 0 to 7
	MOVF        ClearLCD_cl+0, 0 
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,592 :: 		Soft_SPI_Write(%00010000)     ' set column on 0 column position
	MOVLW       16
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,593 :: 		Soft_SPI_Write(%00000000)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,594 :: 		ddata = 1
	BSF         PORTC+0, 6 
;MyGeiger_NT.mbas,595 :: 		for cnn = 0 to 127            ' write zero array
	CLRF        ClearLCD_cnn+0 
L__ClearLCD45:
;MyGeiger_NT.mbas,596 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,597 :: 		next cnn
	MOVF        ClearLCD_cnn+0, 0 
	XORLW       127
	BTFSC       STATUS+0, 2 
	GOTO        L__ClearLCD48
	INCF        ClearLCD_cnn+0, 1 
	GOTO        L__ClearLCD45
L__ClearLCD48:
;MyGeiger_NT.mbas,598 :: 		next cl
	MOVF        ClearLCD_cl+0, 0 
	XORLW       183
	BTFSC       STATUS+0, 2 
	GOTO        L__ClearLCD43
	INCF        ClearLCD_cl+0, 1 
	GOTO        L__ClearLCD40
L__ClearLCD43:
;MyGeiger_NT.mbas,599 :: 		end sub
L_end_ClearLCD:
	RETURN      0
; end of _ClearLCD

_PositionLCD:

;MyGeiger_NT.mbas,602 :: 		dim position_low, position_high, temp_x as byte
;MyGeiger_NT.mbas,604 :: 		position_high = %00010000 OR x>>4
	MOVF        FARG_PositionLCD_x+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       16
	IORWF       R0, 0 
	MOVWF       PositionLCD_position_high+0 
;MyGeiger_NT.mbas,605 :: 		position_low  = %00000000 OR temp_x<<4
	MOVF        FARG_PositionLCD_x+0, 0 
	MOVWF       PositionLCD_position_low+0 
	RLCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 0 
	RLCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 0 
	RLCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 0 
	RLCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 0 
;MyGeiger_NT.mbas,606 :: 		position_low  = %00000000 OR position_low>>4
	RRCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 7 
	RRCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 7 
	RRCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 7 
	RRCF        PositionLCD_position_low+0, 1 
	BCF         PositionLCD_position_low+0, 7 
;MyGeiger_NT.mbas,607 :: 		ddata = 0
	BCF         PORTC+0, 6 
;MyGeiger_NT.mbas,609 :: 		case 7
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD53
;MyGeiger_NT.mbas,610 :: 		Soft_SPI_Write(183)
	MOVLW       183
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD53:
;MyGeiger_NT.mbas,611 :: 		case 6
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD56
;MyGeiger_NT.mbas,612 :: 		Soft_SPI_Write(182)
	MOVLW       182
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD56:
;MyGeiger_NT.mbas,613 :: 		case 5
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD59
;MyGeiger_NT.mbas,614 :: 		Soft_SPI_Write(181)
	MOVLW       181
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD59:
;MyGeiger_NT.mbas,615 :: 		case 4
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD62
;MyGeiger_NT.mbas,616 :: 		Soft_SPI_Write(180)
	MOVLW       180
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD62:
;MyGeiger_NT.mbas,617 :: 		case 3
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD65
;MyGeiger_NT.mbas,618 :: 		Soft_SPI_Write(179)
	MOVLW       179
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD65:
;MyGeiger_NT.mbas,619 :: 		case 2
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD68
;MyGeiger_NT.mbas,620 :: 		Soft_SPI_Write(178)
	MOVLW       178
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD68:
;MyGeiger_NT.mbas,621 :: 		case 1
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD71
;MyGeiger_NT.mbas,622 :: 		Soft_SPI_Write(177)
	MOVLW       177
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD71:
;MyGeiger_NT.mbas,623 :: 		case 0
	MOVF        FARG_PositionLCD_y+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__PositionLCD74
;MyGeiger_NT.mbas,624 :: 		Soft_SPI_Write(176)
	MOVLW       176
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
	GOTO        L__PositionLCD50
L__PositionLCD74:
L__PositionLCD50:
;MyGeiger_NT.mbas,626 :: 		Soft_SPI_Write(position_high)
	MOVF        PositionLCD_position_high+0, 0 
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,627 :: 		Soft_SPI_Write(position_low)
	MOVF        PositionLCD_position_low+0, 0 
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,628 :: 		ddata = 1
	BSF         PORTC+0, 6 
;MyGeiger_NT.mbas,629 :: 		end sub
L_end_PositionLCD:
	RETURN      0
; end of _PositionLCD

_Chr_LCD:

;MyGeiger_NT.mbas,632 :: 		Dim l, m as Byte
;MyGeiger_NT.mbas,633 :: 		ddata = 1
	BSF         PORTC+0, 6 
;MyGeiger_NT.mbas,634 :: 		For l = 1 to 5
	MOVLW       1
	MOVWF       Chr_LCD_l+0 
L__Chr_LCD77:
;MyGeiger_NT.mbas,635 :: 		m = (symlcd - 32)
	MOVLW       32
	SUBWF       FARG_Chr_LCD_symlcd+0, 0 
	MOVWF       R0 
;MyGeiger_NT.mbas,636 :: 		m = m * 5
	MOVLW       5
	MULWF       R0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
;MyGeiger_NT.mbas,637 :: 		m = m + l
	MOVF        Chr_LCD_l+0, 0 
	ADDWF       R0, 1 
;MyGeiger_NT.mbas,638 :: 		m = m - 1
	DECF        R0, 1 
;MyGeiger_NT.mbas,639 :: 		Soft_SPI_Write(fontlookup1[m])
	MOVLW       _fontlookup1+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_fontlookup1+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_fontlookup1+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,640 :: 		Next l
	MOVF        Chr_LCD_l+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L__Chr_LCD80
	INCF        Chr_LCD_l+0, 1 
	GOTO        L__Chr_LCD77
L__Chr_LCD80:
;MyGeiger_NT.mbas,641 :: 		Soft_SPI_Write(0x00)          ' Space between characters
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,643 :: 		end sub
L_end_Chr_LCD:
	RETURN      0
; end of _Chr_LCD

_Text_LCD:

;MyGeiger_NT.mbas,646 :: 		Dim v as byte
;MyGeiger_NT.mbas,648 :: 		PositionLCD(x,y)
	MOVF        FARG_Text_LCD_x+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_Text_LCD_y+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,649 :: 		For v = 0 to length(sentance)-1
	CLRF        Text_LCD_v+0 
L__Text_LCD82:
	MOVF        FARG_Text_LCD_sentance+0, 0 
	MOVWF       FARG_Length_Text+0 
	MOVF        FARG_Text_LCD_sentance+1, 0 
	MOVWF       FARG_Length_Text+1 
	CALL        _Length+0, 0
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       FLOC__Text_LCD+0 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       FLOC__Text_LCD+1 
	MOVLW       0
	SUBWF       FLOC__Text_LCD+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Text_LCD811
	MOVF        Text_LCD_v+0, 0 
	SUBWF       FLOC__Text_LCD+0, 0 
L__Text_LCD811:
	BTFSS       STATUS+0, 0 
	GOTO        L__Text_LCD86
;MyGeiger_NT.mbas,650 :: 		Chr_LCD(sentance[v])
	MOVF        Text_LCD_v+0, 0 
	ADDWF       FARG_Text_LCD_sentance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Text_LCD_sentance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,651 :: 		Next v
	MOVLW       0
	XORWF       FLOC__Text_LCD+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Text_LCD812
	MOVF        FLOC__Text_LCD+0, 0 
	XORWF       Text_LCD_v+0, 0 
L__Text_LCD812:
	BTFSC       STATUS+0, 2 
	GOTO        L__Text_LCD86
	INCF        Text_LCD_v+0, 1 
	GOTO        L__Text_LCD82
L__Text_LCD86:
;MyGeiger_NT.mbas,652 :: 		End Sub
L_end_Text_LCD:
	RETURN      0
; end of _Text_LCD

_Char_LCD:

;MyGeiger_NT.mbas,656 :: 		dim character as integer
;MyGeiger_NT.mbas,657 :: 		ddata = 1
	BSF         PORTC+0, 6 
;MyGeiger_NT.mbas,658 :: 		for index =1 to 5
	MOVLW       1
	MOVWF       Char_LCD_index+0 
	MOVLW       0
	MOVWF       Char_LCD_index+1 
L__Char_LCD89:
;MyGeiger_NT.mbas,659 :: 		character = bykva - 0x20
	MOVLW       32
	SUBWF       FARG_Char_LCD_bykva+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
;MyGeiger_NT.mbas,660 :: 		character = character * 5
	MOVLW       5
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
;MyGeiger_NT.mbas,661 :: 		character = character + index
	MOVF        Char_LCD_index+0, 0 
	ADDWF       R0, 1 
	MOVF        Char_LCD_index+1, 0 
	ADDWFC      R1, 1 
;MyGeiger_NT.mbas,662 :: 		character = character - 1
	MOVLW       1
	SUBWF       R0, 1 
	MOVLW       0
	SUBWFB      R1, 1 
;MyGeiger_NT.mbas,663 :: 		Soft_SPI_Write(table[character])
	MOVLW       _table+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_table+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_table+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,665 :: 		next index
	MOVLW       0
	XORWF       Char_LCD_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Char_LCD814
	MOVLW       5
	XORWF       Char_LCD_index+0, 0 
L__Char_LCD814:
	BTFSC       STATUS+0, 2 
	GOTO        L__Char_LCD92
	INFSNZ      Char_LCD_index+0, 1 
	INCF        Char_LCD_index+1, 1 
	GOTO        L__Char_LCD89
L__Char_LCD92:
;MyGeiger_NT.mbas,666 :: 		end sub
L_end_Char_LCD:
	RETURN      0
; end of _Char_LCD

_MyText_LCD:

;MyGeiger_NT.mbas,669 :: 		Dim v as byte
;MyGeiger_NT.mbas,671 :: 		PositionLCD(x,y)
	MOVF        FARG_MyText_LCD_x+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_MyText_LCD_y+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,672 :: 		For v = 0 to length(sentance)-1
	CLRF        MyText_LCD_v+0 
L__MyText_LCD94:
	MOVF        FARG_MyText_LCD_sentance+0, 0 
	MOVWF       FARG_Length_Text+0 
	MOVF        FARG_MyText_LCD_sentance+1, 0 
	MOVWF       FARG_Length_Text+1 
	CALL        _Length+0, 0
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       FLOC__MyText_LCD+0 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       FLOC__MyText_LCD+1 
	MOVLW       0
	SUBWF       FLOC__MyText_LCD+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__MyText_LCD816
	MOVF        MyText_LCD_v+0, 0 
	SUBWF       FLOC__MyText_LCD+0, 0 
L__MyText_LCD816:
	BTFSS       STATUS+0, 0 
	GOTO        L__MyText_LCD98
;MyGeiger_NT.mbas,673 :: 		Char_LCD(sentance[v])
	MOVF        MyText_LCD_v+0, 0 
	ADDWF       FARG_MyText_LCD_sentance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_MyText_LCD_sentance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,674 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,675 :: 		Next v
	MOVLW       0
	XORWF       FLOC__MyText_LCD+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__MyText_LCD817
	MOVF        FLOC__MyText_LCD+0, 0 
	XORWF       MyText_LCD_v+0, 0 
L__MyText_LCD817:
	BTFSC       STATUS+0, 2 
	GOTO        L__MyText_LCD98
	INCF        MyText_LCD_v+0, 1 
	GOTO        L__MyText_LCD94
L__MyText_LCD98:
;MyGeiger_NT.mbas,676 :: 		End Sub
L_end_MyText_LCD:
	RETURN      0
; end of _MyText_LCD

_LCD_Chr_Big:

;MyGeiger_NT.mbas,679 :: 		dim hh as byte
;MyGeiger_NT.mbas,681 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,682 :: 		py = py + 1
	INCF        FARG_LCD_Chr_Big_py+0, 1 
;MyGeiger_NT.mbas,683 :: 		digit = 48+digit
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	ADDLW       48
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
;MyGeiger_NT.mbas,684 :: 		ddata = 1
	BSF         PORTC+0, 6 
;MyGeiger_NT.mbas,685 :: 		if digit = "0" then
	MOVF        R1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big101
;MyGeiger_NT.mbas,686 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big104:
;MyGeiger_NT.mbas,687 :: 		Soft_SPI_Write (Zero[hh])
	MOVLW       _Zero+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Zero+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Zero+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,688 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big107
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big104
L__LCD_Chr_Big107:
;MyGeiger_NT.mbas,689 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,690 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big109:
;MyGeiger_NT.mbas,691 :: 		Soft_SPI_Write (Zero[hh])
	MOVLW       _Zero+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Zero+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Zero+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,692 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big112
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big109
L__LCD_Chr_Big112:
L__LCD_Chr_Big101:
;MyGeiger_NT.mbas,695 :: 		if digit = "1" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big114
;MyGeiger_NT.mbas,696 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big117:
;MyGeiger_NT.mbas,697 :: 		Soft_SPI_Write (One[hh])
	MOVLW       _One+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_One+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_One+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,698 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big120
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big117
L__LCD_Chr_Big120:
;MyGeiger_NT.mbas,699 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,700 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big122:
;MyGeiger_NT.mbas,701 :: 		Soft_SPI_Write (One[hh])
	MOVLW       _One+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_One+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_One+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,702 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big125
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big122
L__LCD_Chr_Big125:
L__LCD_Chr_Big114:
;MyGeiger_NT.mbas,705 :: 		if digit = "2" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big127
;MyGeiger_NT.mbas,706 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big130:
;MyGeiger_NT.mbas,707 :: 		Soft_SPI_Write (Two[hh])
	MOVLW       _Two+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Two+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Two+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,708 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big133
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big130
L__LCD_Chr_Big133:
;MyGeiger_NT.mbas,709 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,710 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big135:
;MyGeiger_NT.mbas,711 :: 		Soft_SPI_Write (Two[hh])
	MOVLW       _Two+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Two+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Two+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,712 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big138
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big135
L__LCD_Chr_Big138:
L__LCD_Chr_Big127:
;MyGeiger_NT.mbas,715 :: 		if digit = "3" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big140
;MyGeiger_NT.mbas,716 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big143:
;MyGeiger_NT.mbas,717 :: 		Soft_SPI_Write (Thre[hh])
	MOVLW       _Thre+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Thre+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Thre+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,718 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big146
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big143
L__LCD_Chr_Big146:
;MyGeiger_NT.mbas,719 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,720 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big148:
;MyGeiger_NT.mbas,721 :: 		Soft_SPI_Write (Thre[hh])
	MOVLW       _Thre+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Thre+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Thre+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,722 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big151
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big148
L__LCD_Chr_Big151:
L__LCD_Chr_Big140:
;MyGeiger_NT.mbas,725 :: 		if digit = "4" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big153
;MyGeiger_NT.mbas,726 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big156:
;MyGeiger_NT.mbas,727 :: 		Soft_SPI_Write (Four[hh])
	MOVLW       _Four+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Four+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Four+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,728 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big159
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big156
L__LCD_Chr_Big159:
;MyGeiger_NT.mbas,729 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,730 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big161:
;MyGeiger_NT.mbas,731 :: 		Soft_SPI_Write (Four[hh])
	MOVLW       _Four+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Four+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Four+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,732 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big164
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big161
L__LCD_Chr_Big164:
L__LCD_Chr_Big153:
;MyGeiger_NT.mbas,735 :: 		if digit = "5" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big166
;MyGeiger_NT.mbas,736 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big169:
;MyGeiger_NT.mbas,737 :: 		Soft_SPI_Write (Five[hh])
	MOVLW       _Five+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Five+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Five+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,738 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big172
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big169
L__LCD_Chr_Big172:
;MyGeiger_NT.mbas,739 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,740 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big174:
;MyGeiger_NT.mbas,741 :: 		Soft_SPI_Write (Five[hh])
	MOVLW       _Five+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Five+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Five+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,742 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big177
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big174
L__LCD_Chr_Big177:
L__LCD_Chr_Big166:
;MyGeiger_NT.mbas,745 :: 		if digit = "6" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       54
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big179
;MyGeiger_NT.mbas,746 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big182:
;MyGeiger_NT.mbas,747 :: 		Soft_SPI_Write (Six[hh])
	MOVLW       _Six+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Six+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Six+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,748 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big185
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big182
L__LCD_Chr_Big185:
;MyGeiger_NT.mbas,749 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,750 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big187:
;MyGeiger_NT.mbas,751 :: 		Soft_SPI_Write (Six[hh])
	MOVLW       _Six+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Six+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Six+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,752 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big190
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big187
L__LCD_Chr_Big190:
L__LCD_Chr_Big179:
;MyGeiger_NT.mbas,755 :: 		if digit = "7" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       55
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big192
;MyGeiger_NT.mbas,756 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big195:
;MyGeiger_NT.mbas,757 :: 		Soft_SPI_Write (Seven[hh])
	MOVLW       _Seven+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Seven+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Seven+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,758 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big198
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big195
L__LCD_Chr_Big198:
;MyGeiger_NT.mbas,759 :: 		PositionLCD(px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,760 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big200:
;MyGeiger_NT.mbas,761 :: 		Soft_SPI_Write (Seven[hh])
	MOVLW       _Seven+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Seven+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Seven+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,762 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big203
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big200
L__LCD_Chr_Big203:
L__LCD_Chr_Big192:
;MyGeiger_NT.mbas,765 :: 		if digit = "8" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       56
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big205
;MyGeiger_NT.mbas,766 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big208:
;MyGeiger_NT.mbas,767 :: 		Soft_SPI_Write (Eight[hh])
	MOVLW       _Eight+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Eight+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Eight+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,768 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big211
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big208
L__LCD_Chr_Big211:
;MyGeiger_NT.mbas,769 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,770 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big213:
;MyGeiger_NT.mbas,771 :: 		Soft_SPI_Write (Eight[hh])
	MOVLW       _Eight+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Eight+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Eight+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,772 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big216
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big213
L__LCD_Chr_Big216:
L__LCD_Chr_Big205:
;MyGeiger_NT.mbas,775 :: 		if digit = "9" then
	MOVF        FARG_LCD_Chr_Big_digit+0, 0 
	XORLW       57
	BTFSS       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big218
;MyGeiger_NT.mbas,776 :: 		for hh = 0 to 11
	CLRF        LCD_Chr_Big_hh+0 
L__LCD_Chr_Big221:
;MyGeiger_NT.mbas,777 :: 		Soft_SPI_Write (Nine[hh])
	MOVLW       _Nine+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Nine+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Nine+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,778 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big224
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big221
L__LCD_Chr_Big224:
;MyGeiger_NT.mbas,779 :: 		PositionLCD (px, py)
	MOVF        FARG_LCD_Chr_Big_px+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVF        FARG_LCD_Chr_Big_py+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,780 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       LCD_Chr_Big_hh+0 
L__LCD_Chr_Big226:
;MyGeiger_NT.mbas,781 :: 		Soft_SPI_Write (Nine[hh])
	MOVLW       _Nine+0
	ADDWF       LCD_Chr_Big_hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Nine+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Nine+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,782 :: 		next hh
	MOVF        LCD_Chr_Big_hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__LCD_Chr_Big229
	INCF        LCD_Chr_Big_hh+0, 1 
	GOTO        L__LCD_Chr_Big226
L__LCD_Chr_Big229:
L__LCD_Chr_Big218:
;MyGeiger_NT.mbas,785 :: 		end sub
L_end_LCD_Chr_Big:
	RETURN      0
; end of _LCD_Chr_Big

_NOK_Print:

;MyGeiger_NT.mbas,786 :: 		sub procedure NOK_Print(dim poloska as byte)
;MyGeiger_NT.mbas,787 :: 		Soft_SPI_Write(poloska)
	MOVF        FARG_NOK_Print_poloska+0, 0 
	MOVWF       FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,788 :: 		end sub
L_end_NOK_Print:
	RETURN      0
; end of _NOK_Print

_Display_Logo:

;MyGeiger_NT.mbas,792 :: 		zz as word
;MyGeiger_NT.mbas,793 :: 		zz = 0
	CLRF        Display_Logo_zz+0 
	CLRF        Display_Logo_zz+1 
;MyGeiger_NT.mbas,794 :: 		for xx = 0 to 7
	CLRF        Display_Logo_xx+0 
L__Display_Logo233:
;MyGeiger_NT.mbas,795 :: 		PositionLCD (0, xx)
	CLRF        FARG_PositionLCD_x+0 
	MOVF        Display_Logo_xx+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,796 :: 		for yy = 0 to 127
	CLRF        Display_Logo_yy+0 
L__Display_Logo238:
;MyGeiger_NT.mbas,797 :: 		Soft_SPI_Write (rh_logo[zz+yy])
	MOVF        Display_Logo_yy+0, 0 
	ADDWF       Display_Logo_zz+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Display_Logo_zz+1, 0 
	MOVWF       R1 
	MOVLW       _rh_logo+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_rh_logo+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_rh_logo+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,798 :: 		next yy
	MOVF        Display_Logo_yy+0, 0 
	XORLW       127
	BTFSC       STATUS+0, 2 
	GOTO        L__Display_Logo241
	INCF        Display_Logo_yy+0, 1 
	GOTO        L__Display_Logo238
L__Display_Logo241:
;MyGeiger_NT.mbas,799 :: 		zz = zz+128
	MOVLW       128
	ADDWF       Display_Logo_zz+0, 1 
	MOVLW       0
	ADDWFC      Display_Logo_zz+1, 1 
;MyGeiger_NT.mbas,800 :: 		next xx
	MOVF        Display_Logo_xx+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L__Display_Logo236
	INCF        Display_Logo_xx+0, 1 
	GOTO        L__Display_Logo233
L__Display_Logo236:
;MyGeiger_NT.mbas,801 :: 		end sub
L_end_Display_Logo:
	RETURN      0
; end of _Display_Logo

_halt_system:

;MyGeiger_NT.mbas,805 :: 		zz as word
;MyGeiger_NT.mbas,806 :: 		zz = 0
	CLRF        halt_system_zz+0 
	CLRF        halt_system_zz+1 
;MyGeiger_NT.mbas,807 :: 		for xx = 0 to 7
	CLRF        halt_system_xx+0 
L__halt_system244:
;MyGeiger_NT.mbas,808 :: 		PositionLCD (0, xx)
	CLRF        FARG_PositionLCD_x+0 
	MOVF        halt_system_xx+0, 0 
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,809 :: 		for yy = 0 to 127
	CLRF        halt_system_yy+0 
L__halt_system249:
;MyGeiger_NT.mbas,810 :: 		Soft_SPI_Write (lowbat[zz+yy])
	MOVF        halt_system_yy+0, 0 
	ADDWF       halt_system_zz+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      halt_system_zz+1, 0 
	MOVWF       R1 
	MOVLW       _lowbat+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_lowbat+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_lowbat+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,811 :: 		next yy
	MOVF        halt_system_yy+0, 0 
	XORLW       127
	BTFSC       STATUS+0, 2 
	GOTO        L__halt_system252
	INCF        halt_system_yy+0, 1 
	GOTO        L__halt_system249
L__halt_system252:
;MyGeiger_NT.mbas,812 :: 		zz = zz+128
	MOVLW       128
	ADDWF       halt_system_zz+0, 1 
	MOVLW       0
	ADDWFC      halt_system_zz+1, 1 
;MyGeiger_NT.mbas,813 :: 		next xx
	MOVF        halt_system_xx+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L__halt_system247
	INCF        halt_system_xx+0, 1 
	GOTO        L__halt_system244
L__halt_system247:
;MyGeiger_NT.mbas,814 :: 		LATA.2   = 0
	BCF         LATA+0, 2 
;MyGeiger_NT.mbas,815 :: 		LATB.3   = 0
	BCF         LATB+0, 3 
;MyGeiger_NT.mbas,816 :: 		LATA.5   = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,817 :: 		TMR0IE_bit = 0
	BCF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;MyGeiger_NT.mbas,818 :: 		TMR1IE_bit = 0
	BCF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;MyGeiger_NT.mbas,819 :: 		TMR2IE_bit = 0
	BCF         TMR2IE_bit+0, BitPos(TMR2IE_bit+0) 
;MyGeiger_NT.mbas,820 :: 		TMR3IE_bit = 0
	BCF         TMR3IE_bit+0, BitPos(TMR3IE_bit+0) 
;MyGeiger_NT.mbas,821 :: 		INT0IE_bit = 0
	BCF         INT0IE_bit+0, BitPos(INT0IE_bit+0) 
;MyGeiger_NT.mbas,822 :: 		CCP1CON    = %00000000
	CLRF        CCP1CON+0 
;MyGeiger_NT.mbas,823 :: 		PORTC.2    = 0
	BCF         PORTC+0, 2 
;MyGeiger_NT.mbas,824 :: 		ADCON0     = %00000000
	CLRF        ADCON0+0 
;MyGeiger_NT.mbas,825 :: 		sleep
	SLEEP
;MyGeiger_NT.mbas,826 :: 		end sub
L_end_halt_system:
	RETURN      0
; end of _halt_system

_sendcpm:

;MyGeiger_NT.mbas,854 :: 		dim res1, v1 as byte
;MyGeiger_NT.mbas,855 :: 		ltrim (cpms)
	MOVF        FARG_sendcpm_cpms+0, 0 
	MOVWF       FARG_ltrim_astring+0 
	MOVF        FARG_sendcpm_cpms+1, 0 
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,856 :: 		res1 = length(cpms)
	MOVF        FARG_sendcpm_cpms+0, 0 
	MOVWF       FARG_Length_Text+0 
	MOVF        FARG_sendcpm_cpms+1, 0 
	MOVWF       FARG_Length_Text+1 
	CALL        _Length+0, 0
	MOVF        R0, 0 
	MOVWF       sendcpm_res1+0 
;MyGeiger_NT.mbas,857 :: 		res1 = res1 -1
	DECF        R0, 0 
	MOVWF       sendcpm_res1+0 
;MyGeiger_NT.mbas,858 :: 		GIEH_bit = 0
	BCF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;MyGeiger_NT.mbas,859 :: 		GIEL_bit = 0
	BCF         GIEL_bit+0, BitPos(GIEL_bit+0) 
;MyGeiger_NT.mbas,860 :: 		LATA.5  = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,861 :: 		LATB.3 = 0
	BCF         LATB+0, 3 
;MyGeiger_NT.mbas,862 :: 		for v1 = 0 to res1
	CLRF        sendcpm_v1+0 
L__sendcpm254:
	MOVF        sendcpm_v1+0, 0 
	SUBWF       sendcpm_res1+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L__sendcpm258
;MyGeiger_NT.mbas,863 :: 		Soft_UART_Write(cpms[v1])
	MOVF        sendcpm_v1+0, 0 
	ADDWF       FARG_sendcpm_cpms+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_sendcpm_cpms+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;MyGeiger_NT.mbas,864 :: 		next v1
	MOVF        sendcpm_v1+0, 0 
	XORWF       sendcpm_res1+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__sendcpm258
	INCF        sendcpm_v1+0, 1 
	GOTO        L__sendcpm254
L__sendcpm258:
;MyGeiger_NT.mbas,866 :: 		end sub
L_end_sendcpm:
	RETURN      0
; end of _sendcpm

_sendrandom:

;MyGeiger_NT.mbas,869 :: 		dim v2 as byte
;MyGeiger_NT.mbas,871 :: 		for v2 = 7 to 0 step -1
	MOVLW       7
	MOVWF       sendrandom_v2+0 
L__sendrandom261:
;MyGeiger_NT.mbas,872 :: 		Soft_UART_Write(randomtxt[v2])
	MOVF        sendrandom_v2+0, 0 
	ADDWF       FARG_sendrandom_randomtxt+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_sendrandom_randomtxt+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;MyGeiger_NT.mbas,873 :: 		next v2
	MOVF        sendrandom_v2+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__sendrandom264
	MOVLW       255
	ADDWF       sendrandom_v2+0, 1 
	GOTO        L__sendrandom261
L__sendrandom264:
;MyGeiger_NT.mbas,875 :: 		end sub
L_end_sendrandom:
	RETURN      0
; end of _sendrandom

_calibration:

;MyGeiger_NT.mbas,879 :: 		sub procedure calibration()
;MyGeiger_NT.mbas,880 :: 		GIE_bit = 0
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;MyGeiger_NT.mbas,882 :: 		LATA.2   = 1 ' light
	BSF         LATA+0, 2 
;MyGeiger_NT.mbas,883 :: 		LATB.3 = 0
	BCF         LATB+0, 3 
;MyGeiger_NT.mbas,884 :: 		LATA.5  = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,885 :: 		LATB.7  = 0             ' turn off alert on portb.7 and wait for button
	BCF         LATB+0, 7 
;MyGeiger_NT.mbas,886 :: 		TRISB.7 = 1             ' input
	BSF         TRISB+0, 7 
;MyGeiger_NT.mbas,888 :: 		ClearLCD()
	CALL        _ClearLCD+0, 0
;MyGeiger_NT.mbas,889 :: 		MyText_LCD(32,6,  "use to set:")
	MOVLW       32
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       6
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       117
	MOVWF       ?LocalText_calibration+0 
	MOVLW       115
	MOVWF       ?LocalText_calibration+1 
	MOVLW       101
	MOVWF       ?LocalText_calibration+2 
	MOVLW       32
	MOVWF       ?LocalText_calibration+3 
	MOVLW       116
	MOVWF       ?LocalText_calibration+4 
	MOVLW       111
	MOVWF       ?LocalText_calibration+5 
	MOVLW       32
	MOVWF       ?LocalText_calibration+6 
	MOVLW       115
	MOVWF       ?LocalText_calibration+7 
	MOVLW       101
	MOVWF       ?LocalText_calibration+8 
	MOVLW       116
	MOVWF       ?LocalText_calibration+9 
	MOVLW       58
	MOVWF       ?LocalText_calibration+10 
	CLRF        ?LocalText_calibration+11 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,890 :: 		MyText_LCD(24, 7, "plus,minus,OK")
	MOVLW       24
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       112
	MOVWF       ?LocalText_calibration+0 
	MOVLW       108
	MOVWF       ?LocalText_calibration+1 
	MOVLW       117
	MOVWF       ?LocalText_calibration+2 
	MOVLW       115
	MOVWF       ?LocalText_calibration+3 
	MOVLW       44
	MOVWF       ?LocalText_calibration+4 
	MOVLW       109
	MOVWF       ?LocalText_calibration+5 
	MOVLW       105
	MOVWF       ?LocalText_calibration+6 
	MOVLW       110
	MOVWF       ?LocalText_calibration+7 
	MOVLW       117
	MOVWF       ?LocalText_calibration+8 
	MOVLW       115
	MOVWF       ?LocalText_calibration+9 
	MOVLW       44
	MOVWF       ?LocalText_calibration+10 
	MOVLW       79
	MOVWF       ?LocalText_calibration+11 
	MOVLW       75
	MOVWF       ?LocalText_calibration+12 
	CLRF        ?LocalText_calibration+13 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,891 :: 		MyText_LCD(0,0, "CF=0.0")
	CLRF        FARG_MyText_LCD_x+0 
	CLRF        FARG_MyText_LCD_y+0 
	MOVLW       67
	MOVWF       ?LocalText_calibration+0 
	MOVLW       70
	MOVWF       ?LocalText_calibration+1 
	MOVLW       61
	MOVWF       ?LocalText_calibration+2 
	MOVLW       48
	MOVWF       ?LocalText_calibration+3 
	MOVLW       46
	MOVWF       ?LocalText_calibration+4 
	MOVLW       48
	MOVWF       ?LocalText_calibration+5 
	CLRF        ?LocalText_calibration+6 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,892 :: 		ch = (CF div 100) mod 10
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,893 :: 		PositionLCD(36, 0)
	MOVLW       36
	MOVWF       FARG_PositionLCD_x+0 
	CLRF        FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,894 :: 		Char_LCD (48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,895 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,896 :: 		ch = (CF div 10) mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,897 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,898 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,899 :: 		ch = CF mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,900 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,901 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,906 :: 		while (1)
L__calibration268:
;MyGeiger_NT.mbas,907 :: 		if Button (PORTB, 7, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration273
;MyGeiger_NT.mbas,908 :: 		inc (CF)
	INCF        _CF+0, 1 
;MyGeiger_NT.mbas,909 :: 		if CF> 0xFA then
	MOVF        _CF+0, 0 
	SUBLW       250
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration276
;MyGeiger_NT.mbas,910 :: 		dec (CF)
	DECF        _CF+0, 1 
L__calibration276:
;MyGeiger_NT.mbas,912 :: 		ch = (CF div 100) mod 10
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,913 :: 		PositionLCD(36, 0)
	MOVLW       36
	MOVWF       FARG_PositionLCD_x+0 
	CLRF        FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,914 :: 		Char_LCD (48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,915 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,916 :: 		ch = (CF div 10) mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,917 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,918 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,919 :: 		ch = CF mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,920 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,921 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
L__calibration273:
;MyGeiger_NT.mbas,925 :: 		if Button (PORTB, 6, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration279
;MyGeiger_NT.mbas,926 :: 		dec (CF)
	DECF        _CF+0, 1 
;MyGeiger_NT.mbas,927 :: 		if CF<0x01 then
	MOVLW       1
	SUBWF       _CF+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration282
;MyGeiger_NT.mbas,928 :: 		inc (CF)
	INCF        _CF+0, 1 
L__calibration282:
;MyGeiger_NT.mbas,930 :: 		ch = (CF div 100) mod 10
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,931 :: 		PositionLCD(36, 0)
	MOVLW       36
	MOVWF       FARG_PositionLCD_x+0 
	CLRF        FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,932 :: 		Char_LCD (48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,933 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,934 :: 		ch = (CF div 10) mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,935 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,936 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,937 :: 		ch = CF mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,938 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,939 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
L__calibration279:
;MyGeiger_NT.mbas,943 :: 		if Button (PORTB, 5, 150, 1) then         'ok
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration285
;MyGeiger_NT.mbas,944 :: 		EEPROM_Write (0x00, CF)
	CLRF        FARG_EEPROM_Write_address+0 
	MOVF        _CF+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,945 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__calibration287:
	DECFSZ      R13, 1, 1
	BRA         L__calibration287
	DECFSZ      R12, 1, 1
	BRA         L__calibration287
	NOP
	NOP
;MyGeiger_NT.mbas,946 :: 		goto tube_limit
	GOTO        L__calibration_tube_limit
L__calibration285:
;MyGeiger_NT.mbas,948 :: 		wend
	GOTO        L__calibration268
;MyGeiger_NT.mbas,951 :: 		tube_limit:                                   ' set normal background limit
L__calibration_tube_limit:
;MyGeiger_NT.mbas,953 :: 		MyText_LCD(0,1, "BG=              CPM")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       1
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       66
	MOVWF       ?LocalText_calibration+0 
	MOVLW       71
	MOVWF       ?LocalText_calibration+1 
	MOVLW       61
	MOVWF       ?LocalText_calibration+2 
	MOVLW       32
	MOVWF       ?LocalText_calibration+3 
	MOVLW       32
	MOVWF       ?LocalText_calibration+4 
	MOVLW       32
	MOVWF       ?LocalText_calibration+5 
	MOVLW       32
	MOVWF       ?LocalText_calibration+6 
	MOVLW       32
	MOVWF       ?LocalText_calibration+7 
	MOVLW       32
	MOVWF       ?LocalText_calibration+8 
	MOVLW       32
	MOVWF       ?LocalText_calibration+9 
	MOVLW       32
	MOVWF       ?LocalText_calibration+10 
	MOVLW       32
	MOVWF       ?LocalText_calibration+11 
	MOVLW       32
	MOVWF       ?LocalText_calibration+12 
	MOVLW       32
	MOVWF       ?LocalText_calibration+13 
	MOVLW       32
	MOVWF       ?LocalText_calibration+14 
	MOVLW       32
	MOVWF       ?LocalText_calibration+15 
	MOVLW       32
	MOVWF       ?LocalText_calibration+16 
	MOVLW       67
	MOVWF       ?LocalText_calibration+17 
	MOVLW       80
	MOVWF       ?LocalText_calibration+18 
	MOVLW       77
	MOVWF       ?LocalText_calibration+19 
	CLRF        ?LocalText_calibration+20 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,954 :: 		ByteToStr (BG, tube_limit_txt)
	MOVF        _BG+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,955 :: 		MyText_LCD(20, 1, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       1
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,957 :: 		while(1)
L__calibration291:
;MyGeiger_NT.mbas,958 :: 		if Button (PORTB, 7, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration296
;MyGeiger_NT.mbas,959 :: 		inc(BG)
	INCF        _BG+0, 1 
;MyGeiger_NT.mbas,960 :: 		if BG>254 then
	MOVF        _BG+0, 0 
	SUBLW       254
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration299
;MyGeiger_NT.mbas,961 :: 		BG = 254
	MOVLW       254
	MOVWF       _BG+0 
L__calibration299:
;MyGeiger_NT.mbas,963 :: 		ByteToStr (BG, tube_limit_txt)
	MOVF        _BG+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,964 :: 		MyText_LCD(20, 1, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       1
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__calibration296:
;MyGeiger_NT.mbas,967 :: 		if Button (PORTB, 6, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration302
;MyGeiger_NT.mbas,968 :: 		dec(BG)
	DECF        _BG+0, 1 
;MyGeiger_NT.mbas,969 :: 		if BG<3 then
	MOVLW       3
	SUBWF       _BG+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration305
;MyGeiger_NT.mbas,970 :: 		BG = 3
	MOVLW       3
	MOVWF       _BG+0 
L__calibration305:
;MyGeiger_NT.mbas,972 :: 		ByteToStr (BG, tube_limit_txt)
	MOVF        _BG+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,973 :: 		MyText_LCD(20, 1, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       1
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__calibration302:
;MyGeiger_NT.mbas,975 :: 		if Button (PORTB, 5, 150, 1) then         'ok
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration308
;MyGeiger_NT.mbas,976 :: 		DL = sqrt(BG) * 4.65 + 3
	MOVF        _BG+0, 0 
	MOVWF       R0 
	CALL        _Byte2Double+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sqrt_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_sqrt_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_sqrt_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_sqrt_x+3 
	CALL        _sqrt+0, 0
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       20
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       64
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _Double2Byte+0, 0
	MOVF        R0, 0 
	MOVWF       _DL+0 
;MyGeiger_NT.mbas,977 :: 		EEPROM_Write (0x07, BG)
	MOVLW       7
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _BG+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,978 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__calibration310:
	DECFSZ      R13, 1, 1
	BRA         L__calibration310
	DECFSZ      R12, 1, 1
	BRA         L__calibration310
	NOP
	NOP
;MyGeiger_NT.mbas,979 :: 		EEPROM_Write (0x08, DL)
	MOVLW       8
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _DL+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,980 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__calibration311:
	DECFSZ      R13, 1, 1
	BRA         L__calibration311
	DECFSZ      R12, 1, 1
	BRA         L__calibration311
	NOP
	NOP
;MyGeiger_NT.mbas,981 :: 		goto tube_square_set
	GOTO        L__calibration_tube_square_set
L__calibration308:
;MyGeiger_NT.mbas,983 :: 		wend
	GOTO        L__calibration291
;MyGeiger_NT.mbas,984 :: 		tube_square_set:
L__calibration_tube_square_set:
;MyGeiger_NT.mbas,985 :: 		MyText_LCD(0,2,"SQ=             cm^2")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       83
	MOVWF       ?LocalText_calibration+0 
	MOVLW       81
	MOVWF       ?LocalText_calibration+1 
	MOVLW       61
	MOVWF       ?LocalText_calibration+2 
	MOVLW       32
	MOVWF       ?LocalText_calibration+3 
	MOVLW       32
	MOVWF       ?LocalText_calibration+4 
	MOVLW       32
	MOVWF       ?LocalText_calibration+5 
	MOVLW       32
	MOVWF       ?LocalText_calibration+6 
	MOVLW       32
	MOVWF       ?LocalText_calibration+7 
	MOVLW       32
	MOVWF       ?LocalText_calibration+8 
	MOVLW       32
	MOVWF       ?LocalText_calibration+9 
	MOVLW       32
	MOVWF       ?LocalText_calibration+10 
	MOVLW       32
	MOVWF       ?LocalText_calibration+11 
	MOVLW       32
	MOVWF       ?LocalText_calibration+12 
	MOVLW       32
	MOVWF       ?LocalText_calibration+13 
	MOVLW       32
	MOVWF       ?LocalText_calibration+14 
	MOVLW       32
	MOVWF       ?LocalText_calibration+15 
	MOVLW       99
	MOVWF       ?LocalText_calibration+16 
	MOVLW       109
	MOVWF       ?LocalText_calibration+17 
	MOVLW       94
	MOVWF       ?LocalText_calibration+18 
	MOVLW       50
	MOVWF       ?LocalText_calibration+19 
	CLRF        ?LocalText_calibration+20 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,986 :: 		ByteToStr (tube_square, tube_limit_txt)
	MOVF        _tube_square+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,987 :: 		MyText_LCD(20, 2, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,988 :: 		while(1)
L__calibration314:
;MyGeiger_NT.mbas,989 :: 		if Button (PORTB, 7, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration319
;MyGeiger_NT.mbas,990 :: 		inc(tube_square)
	INCF        _tube_square+0, 1 
;MyGeiger_NT.mbas,991 :: 		if tube_square>254 then
	MOVF        _tube_square+0, 0 
	SUBLW       254
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration322
;MyGeiger_NT.mbas,992 :: 		tube_square = 254
	MOVLW       254
	MOVWF       _tube_square+0 
L__calibration322:
;MyGeiger_NT.mbas,994 :: 		ByteToStr (tube_square, tube_limit_txt)
	MOVF        _tube_square+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,995 :: 		MyText_LCD(20, 2, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__calibration319:
;MyGeiger_NT.mbas,998 :: 		if Button (PORTB, 6, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration325
;MyGeiger_NT.mbas,999 :: 		dec(tube_square)
	DECF        _tube_square+0, 1 
;MyGeiger_NT.mbas,1000 :: 		if tube_square<3 then
	MOVLW       3
	SUBWF       _tube_square+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration328
;MyGeiger_NT.mbas,1001 :: 		tube_square = 3
	MOVLW       3
	MOVWF       _tube_square+0 
L__calibration328:
;MyGeiger_NT.mbas,1003 :: 		ByteToStr (tube_square, tube_limit_txt)
	MOVF        _tube_square+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1004 :: 		MyText_LCD(20, 2, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__calibration325:
;MyGeiger_NT.mbas,1006 :: 		if Button (PORTB, 5, 150, 1) then         'ok
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration331
;MyGeiger_NT.mbas,1007 :: 		EEPROM_Write (0x06, tube_square)
	MOVLW       6
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _tube_square+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1008 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__calibration333:
	DECFSZ      R13, 1, 1
	BRA         L__calibration333
	DECFSZ      R12, 1, 1
	BRA         L__calibration333
	NOP
	NOP
;MyGeiger_NT.mbas,1009 :: 		goto dead_time_set
	GOTO        L__calibration_dead_time_set
L__calibration331:
;MyGeiger_NT.mbas,1011 :: 		wend
	GOTO        L__calibration314
;MyGeiger_NT.mbas,1012 :: 		dead_time_set:
L__calibration_dead_time_set:
;MyGeiger_NT.mbas,1013 :: 		MyText_LCD(0,3,"DT=             ;Sec")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       3
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       68
	MOVWF       ?LocalText_calibration+0 
	MOVLW       84
	MOVWF       ?LocalText_calibration+1 
	MOVLW       61
	MOVWF       ?LocalText_calibration+2 
	MOVLW       32
	MOVWF       ?LocalText_calibration+3 
	MOVLW       32
	MOVWF       ?LocalText_calibration+4 
	MOVLW       32
	MOVWF       ?LocalText_calibration+5 
	MOVLW       32
	MOVWF       ?LocalText_calibration+6 
	MOVLW       32
	MOVWF       ?LocalText_calibration+7 
	MOVLW       32
	MOVWF       ?LocalText_calibration+8 
	MOVLW       32
	MOVWF       ?LocalText_calibration+9 
	MOVLW       32
	MOVWF       ?LocalText_calibration+10 
	MOVLW       32
	MOVWF       ?LocalText_calibration+11 
	MOVLW       32
	MOVWF       ?LocalText_calibration+12 
	MOVLW       32
	MOVWF       ?LocalText_calibration+13 
	MOVLW       32
	MOVWF       ?LocalText_calibration+14 
	MOVLW       32
	MOVWF       ?LocalText_calibration+15 
	MOVLW       59
	MOVWF       ?LocalText_calibration+16 
	MOVLW       83
	MOVWF       ?LocalText_calibration+17 
	MOVLW       101
	MOVWF       ?LocalText_calibration+18 
	MOVLW       99
	MOVWF       ?LocalText_calibration+19 
	CLRF        ?LocalText_calibration+20 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1014 :: 		ByteToStr (DT, tube_limit_txt)
	MOVF        _DT+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1015 :: 		MyText_LCD(20, 3, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       3
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1016 :: 		while(1)
L__calibration336:
;MyGeiger_NT.mbas,1017 :: 		if Button (PORTB, 7, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration341
;MyGeiger_NT.mbas,1018 :: 		inc(DT)
	INCF        _DT+0, 1 
;MyGeiger_NT.mbas,1019 :: 		if DT>251 then
	MOVF        _DT+0, 0 
	SUBLW       251
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration344
;MyGeiger_NT.mbas,1020 :: 		DT = 250
	MOVLW       250
	MOVWF       _DT+0 
L__calibration344:
;MyGeiger_NT.mbas,1022 :: 		ByteToStr (DT, tube_limit_txt)
	MOVF        _DT+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1023 :: 		MyText_LCD(20, 3, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       3
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__calibration341:
;MyGeiger_NT.mbas,1026 :: 		if Button (PORTB, 6, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration347
;MyGeiger_NT.mbas,1027 :: 		dec(DT)
	DECF        _DT+0, 1 
;MyGeiger_NT.mbas,1028 :: 		if DT<2 then
	MOVLW       2
	SUBWF       _DT+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__calibration350
;MyGeiger_NT.mbas,1029 :: 		DT = 1
	MOVLW       1
	MOVWF       _DT+0 
L__calibration350:
;MyGeiger_NT.mbas,1031 :: 		ByteToStr (DT, tube_limit_txt)
	MOVF        _DT+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1032 :: 		MyText_LCD(20, 3, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       3
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__calibration347:
;MyGeiger_NT.mbas,1034 :: 		if Button (PORTB, 5, 150, 1) then         'ok
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration353
;MyGeiger_NT.mbas,1035 :: 		EEPROM_Write (0x0A, DT)
	MOVLW       10
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _DT+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1036 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__calibration355:
	DECFSZ      R13, 1, 1
	BRA         L__calibration355
	DECFSZ      R12, 1, 1
	BRA         L__calibration355
	NOP
	NOP
;MyGeiger_NT.mbas,1037 :: 		goto becquerel_output
	GOTO        L__calibration_becquerel_output
L__calibration353:
;MyGeiger_NT.mbas,1039 :: 		wend
	GOTO        L__calibration336
;MyGeiger_NT.mbas,1041 :: 		becquerel_output:
L__calibration_becquerel_output:
;MyGeiger_NT.mbas,1042 :: 		MyText_LCD(0,4,"USB data:CPM")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       4
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       85
	MOVWF       ?LocalText_calibration+0 
	MOVLW       83
	MOVWF       ?LocalText_calibration+1 
	MOVLW       66
	MOVWF       ?LocalText_calibration+2 
	MOVLW       32
	MOVWF       ?LocalText_calibration+3 
	MOVLW       100
	MOVWF       ?LocalText_calibration+4 
	MOVLW       97
	MOVWF       ?LocalText_calibration+5 
	MOVLW       116
	MOVWF       ?LocalText_calibration+6 
	MOVLW       97
	MOVWF       ?LocalText_calibration+7 
	MOVLW       58
	MOVWF       ?LocalText_calibration+8 
	MOVLW       67
	MOVWF       ?LocalText_calibration+9 
	MOVLW       80
	MOVWF       ?LocalText_calibration+10 
	MOVLW       77
	MOVWF       ?LocalText_calibration+11 
	CLRF        ?LocalText_calibration+12 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1043 :: 		becquerel  = 0x00
	CLRF        _becquerel+0 
;MyGeiger_NT.mbas,1044 :: 		while(1)
L__calibration358:
;MyGeiger_NT.mbas,1045 :: 		if Button (PORTB, 7, 150, 1) then        '+
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration363
;MyGeiger_NT.mbas,1046 :: 		MyText_LCD(54,4,"CPM")
	MOVLW       54
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       4
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       67
	MOVWF       ?LocalText_calibration+0 
	MOVLW       80
	MOVWF       ?LocalText_calibration+1 
	MOVLW       77
	MOVWF       ?LocalText_calibration+2 
	CLRF        ?LocalText_calibration+3 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1047 :: 		becquerel  = 0x00
	CLRF        _becquerel+0 
L__calibration363:
;MyGeiger_NT.mbas,1050 :: 		if Button (PORTB, 6, 150, 1) then        '-
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration366
;MyGeiger_NT.mbas,1051 :: 		MyText_LCD(54,4,"Bq ")
	MOVLW       54
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       4
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       66
	MOVWF       ?LocalText_calibration+0 
	MOVLW       113
	MOVWF       ?LocalText_calibration+1 
	MOVLW       32
	MOVWF       ?LocalText_calibration+2 
	CLRF        ?LocalText_calibration+3 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1052 :: 		becquerel = 0x01
	MOVLW       1
	MOVWF       _becquerel+0 
L__calibration366:
;MyGeiger_NT.mbas,1054 :: 		if Button (PORTB, 5, 150, 1) then         'ok
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration369
;MyGeiger_NT.mbas,1055 :: 		EEPROM_Write (0x09, becquerel)
	MOVLW       9
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _becquerel+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1056 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__calibration371:
	DECFSZ      R13, 1, 1
	BRA         L__calibration371
	DECFSZ      R12, 1, 1
	BRA         L__calibration371
	NOP
	NOP
;MyGeiger_NT.mbas,1057 :: 		goto backlight_settings
	GOTO        L__calibration_backlight_settings
L__calibration369:
;MyGeiger_NT.mbas,1060 :: 		wend
	GOTO        L__calibration358
;MyGeiger_NT.mbas,1061 :: 		backlight_settings:
L__calibration_backlight_settings:
;MyGeiger_NT.mbas,1062 :: 		MyText_LCD(0,5,"Smart Backlight? YES")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       5
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       83
	MOVWF       ?LocalText_calibration+0 
	MOVLW       109
	MOVWF       ?LocalText_calibration+1 
	MOVLW       97
	MOVWF       ?LocalText_calibration+2 
	MOVLW       114
	MOVWF       ?LocalText_calibration+3 
	MOVLW       116
	MOVWF       ?LocalText_calibration+4 
	MOVLW       32
	MOVWF       ?LocalText_calibration+5 
	MOVLW       66
	MOVWF       ?LocalText_calibration+6 
	MOVLW       97
	MOVWF       ?LocalText_calibration+7 
	MOVLW       99
	MOVWF       ?LocalText_calibration+8 
	MOVLW       107
	MOVWF       ?LocalText_calibration+9 
	MOVLW       108
	MOVWF       ?LocalText_calibration+10 
	MOVLW       105
	MOVWF       ?LocalText_calibration+11 
	MOVLW       103
	MOVWF       ?LocalText_calibration+12 
	MOVLW       104
	MOVWF       ?LocalText_calibration+13 
	MOVLW       116
	MOVWF       ?LocalText_calibration+14 
	MOVLW       63
	MOVWF       ?LocalText_calibration+15 
	MOVLW       32
	MOVWF       ?LocalText_calibration+16 
	MOVLW       89
	MOVWF       ?LocalText_calibration+17 
	MOVLW       69
	MOVWF       ?LocalText_calibration+18 
	MOVLW       83
	MOVWF       ?LocalText_calibration+19 
	CLRF        ?LocalText_calibration+20 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1063 :: 		smartBL  = 0x01
	MOVLW       1
	MOVWF       _smartBL+0 
;MyGeiger_NT.mbas,1064 :: 		while(1)
L__calibration374:
;MyGeiger_NT.mbas,1065 :: 		if Button (PORTB, 7, 150, 1) then        '+
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration379
;MyGeiger_NT.mbas,1066 :: 		MyText_LCD(102,5,"YES")
	MOVLW       102
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       5
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       89
	MOVWF       ?LocalText_calibration+0 
	MOVLW       69
	MOVWF       ?LocalText_calibration+1 
	MOVLW       83
	MOVWF       ?LocalText_calibration+2 
	CLRF        ?LocalText_calibration+3 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1067 :: 		smartBL  = 0x01
	MOVLW       1
	MOVWF       _smartBL+0 
L__calibration379:
;MyGeiger_NT.mbas,1070 :: 		if Button (PORTB, 6, 150, 1) then        '-
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration382
;MyGeiger_NT.mbas,1071 :: 		MyText_LCD(102,5,"NO ")
	MOVLW       102
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       5
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       78
	MOVWF       ?LocalText_calibration+0 
	MOVLW       79
	MOVWF       ?LocalText_calibration+1 
	MOVLW       32
	MOVWF       ?LocalText_calibration+2 
	CLRF        ?LocalText_calibration+3 
	MOVLW       ?LocalText_calibration+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_calibration+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1072 :: 		smartBL  = 0x00
	CLRF        _smartBL+0 
L__calibration382:
;MyGeiger_NT.mbas,1074 :: 		if Button (PORTB, 5, 150, 1) then         'ok
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__calibration385
;MyGeiger_NT.mbas,1075 :: 		EEPROM_Write (0x10, smartBL)
	MOVLW       16
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _smartBL+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1076 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__calibration387:
	DECFSZ      R13, 1, 1
	BRA         L__calibration387
	DECFSZ      R12, 1, 1
	BRA         L__calibration387
	NOP
	NOP
;MyGeiger_NT.mbas,1077 :: 		goto exit_calibration
	GOTO        L__calibration_exit_calibration
L__calibration385:
;MyGeiger_NT.mbas,1080 :: 		wend
	GOTO        L__calibration374
;MyGeiger_NT.mbas,1082 :: 		exit_calibration:
L__calibration_exit_calibration:
;MyGeiger_NT.mbas,1084 :: 		ClearLCD()
	CALL        _ClearLCD+0, 0
;MyGeiger_NT.mbas,1085 :: 		counts = 0
	CLRF        _counts+0 
	CLRF        _counts+1 
;MyGeiger_NT.mbas,1086 :: 		cpm = 0
	CLRF        _cpm+0 
	CLRF        _cpm+1 
	CLRF        _cpm+2 
	CLRF        _cpm+3 
;MyGeiger_NT.mbas,1087 :: 		dose = 0
	CLRF        _dose+0 
	CLRF        _dose+1 
	CLRF        _dose+2 
	CLRF        _dose+3 
;MyGeiger_NT.mbas,1088 :: 		timer_cnt = 0
	CLRF        _timer_cnt+0 
;MyGeiger_NT.mbas,1089 :: 		cpm_read_done = 0
	BCF         _cpm_read_done+0, BitPos(_cpm_read_done+0) 
;MyGeiger_NT.mbas,1090 :: 		TMR1IF_bit = 0
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;MyGeiger_NT.mbas,1091 :: 		reset
	RESET
;MyGeiger_NT.mbas,1092 :: 		end sub
L_end_calibration:
	RETURN      0
; end of _calibration

_signalization:

;MyGeiger_NT.mbas,1099 :: 		dim shag as byte
;MyGeiger_NT.mbas,1100 :: 		shag = 10
	MOVLW       10
	MOVWF       signalization_shag+0 
;MyGeiger_NT.mbas,1101 :: 		ClearLCD()
	CALL        _ClearLCD+0, 0
;MyGeiger_NT.mbas,1103 :: 		MyText_LCD(8,0,   "SET ALERT CPM NOW?")
	MOVLW       8
	MOVWF       FARG_MyText_LCD_x+0 
	CLRF        FARG_MyText_LCD_y+0 
	MOVLW       83
	MOVWF       ?LocalText_signalization+0 
	MOVLW       69
	MOVWF       ?LocalText_signalization+1 
	MOVLW       84
	MOVWF       ?LocalText_signalization+2 
	MOVLW       32
	MOVWF       ?LocalText_signalization+3 
	MOVLW       65
	MOVWF       ?LocalText_signalization+4 
	MOVLW       76
	MOVWF       ?LocalText_signalization+5 
	MOVLW       69
	MOVWF       ?LocalText_signalization+6 
	MOVLW       82
	MOVWF       ?LocalText_signalization+7 
	MOVLW       84
	MOVWF       ?LocalText_signalization+8 
	MOVLW       32
	MOVWF       ?LocalText_signalization+9 
	MOVLW       67
	MOVWF       ?LocalText_signalization+10 
	MOVLW       80
	MOVWF       ?LocalText_signalization+11 
	MOVLW       77
	MOVWF       ?LocalText_signalization+12 
	MOVLW       32
	MOVWF       ?LocalText_signalization+13 
	MOVLW       78
	MOVWF       ?LocalText_signalization+14 
	MOVLW       79
	MOVWF       ?LocalText_signalization+15 
	MOVLW       87
	MOVWF       ?LocalText_signalization+16 
	MOVLW       63
	MOVWF       ?LocalText_signalization+17 
	CLRF        ?LocalText_signalization+18 
	MOVLW       ?LocalText_signalization+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_signalization+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1104 :: 		MyText_LCD(32,6,  "use to set:")
	MOVLW       32
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       6
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       117
	MOVWF       ?LocalText_signalization+0 
	MOVLW       115
	MOVWF       ?LocalText_signalization+1 
	MOVLW       101
	MOVWF       ?LocalText_signalization+2 
	MOVLW       32
	MOVWF       ?LocalText_signalization+3 
	MOVLW       116
	MOVWF       ?LocalText_signalization+4 
	MOVLW       111
	MOVWF       ?LocalText_signalization+5 
	MOVLW       32
	MOVWF       ?LocalText_signalization+6 
	MOVLW       115
	MOVWF       ?LocalText_signalization+7 
	MOVLW       101
	MOVWF       ?LocalText_signalization+8 
	MOVLW       116
	MOVWF       ?LocalText_signalization+9 
	MOVLW       58
	MOVWF       ?LocalText_signalization+10 
	CLRF        ?LocalText_signalization+11 
	MOVLW       ?LocalText_signalization+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_signalization+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1105 :: 		MyText_LCD(24, 7, "plus,minus,OK")
	MOVLW       24
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       112
	MOVWF       ?LocalText_signalization+0 
	MOVLW       108
	MOVWF       ?LocalText_signalization+1 
	MOVLW       117
	MOVWF       ?LocalText_signalization+2 
	MOVLW       115
	MOVWF       ?LocalText_signalization+3 
	MOVLW       44
	MOVWF       ?LocalText_signalization+4 
	MOVLW       109
	MOVWF       ?LocalText_signalization+5 
	MOVLW       105
	MOVWF       ?LocalText_signalization+6 
	MOVLW       110
	MOVWF       ?LocalText_signalization+7 
	MOVLW       117
	MOVWF       ?LocalText_signalization+8 
	MOVLW       115
	MOVWF       ?LocalText_signalization+9 
	MOVLW       44
	MOVWF       ?LocalText_signalization+10 
	MOVLW       79
	MOVWF       ?LocalText_signalization+11 
	MOVLW       75
	MOVWF       ?LocalText_signalization+12 
	CLRF        ?LocalText_signalization+13 
	MOVLW       ?LocalText_signalization+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_signalization+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1107 :: 		WordToStr (ALARM, txt1)
	MOVF        _ALARM+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _ALARM+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       signalization_txt1+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyGeiger_NT.mbas,1108 :: 		ltrim (txt1)
	MOVLW       signalization_txt1+0
	MOVWF       FARG_ltrim_astring+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,1109 :: 		MyText_LCD (51, 2, txt1)
	MOVLW       51
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       signalization_txt1+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1110 :: 		for zzz = 0 to 30000
	CLRF        signalization_zzz+0 
	CLRF        signalization_zzz+1 
L__signalization391:
;MyGeiger_NT.mbas,1111 :: 		if Button (PORTB, 7, 50, 1) or Button (PORTB, 6, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       50
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__signalization+0 
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        FLOC__signalization+0, 0 
	IORWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__signalization396
;MyGeiger_NT.mbas,1112 :: 		goto CHANGE
	GOTO        L__signalization_change
L__signalization396:
;MyGeiger_NT.mbas,1114 :: 		next zzz
	MOVF        signalization_zzz+1, 0 
	XORLW       117
	BTFSS       STATUS+0, 2 
	GOTO        L__signalization826
	MOVLW       48
	XORWF       signalization_zzz+0, 0 
L__signalization826:
	BTFSC       STATUS+0, 2 
	GOTO        L__signalization394
	INFSNZ      signalization_zzz+0, 1 
	INCF        signalization_zzz+1, 1 
	GOTO        L__signalization391
L__signalization394:
;MyGeiger_NT.mbas,1115 :: 		goto CHANGE2
	GOTO        L__signalization_change2
;MyGeiger_NT.mbas,1117 :: 		CHANGE:
L__signalization_change:
;MyGeiger_NT.mbas,1119 :: 		while (1)
L__signalization401:
;MyGeiger_NT.mbas,1120 :: 		if ALARM >= 200 then
	MOVLW       0
	SUBWF       _ALARM+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__signalization827
	MOVLW       200
	SUBWF       _ALARM+0, 0 
L__signalization827:
	BTFSS       STATUS+0, 0 
	GOTO        L__signalization406
;MyGeiger_NT.mbas,1121 :: 		shag = 100
	MOVLW       100
	MOVWF       signalization_shag+0 
	GOTO        L__signalization407
;MyGeiger_NT.mbas,1122 :: 		else
L__signalization406:
;MyGeiger_NT.mbas,1123 :: 		shag = 10
	MOVLW       10
	MOVWF       signalization_shag+0 
;MyGeiger_NT.mbas,1124 :: 		end if
L__signalization407:
;MyGeiger_NT.mbas,1126 :: 		if Button (PORTB, 7, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__signalization409
;MyGeiger_NT.mbas,1127 :: 		ALARM = ALARM + shag
	MOVF        signalization_shag+0, 0 
	ADDWF       _ALARM+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _ALARM+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _ALARM+0 
	MOVF        R2, 0 
	MOVWF       _ALARM+1 
;MyGeiger_NT.mbas,1128 :: 		if ALARM>5000 then
	MOVF        R2, 0 
	SUBLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L__signalization828
	MOVF        R1, 0 
	SUBLW       136
L__signalization828:
	BTFSC       STATUS+0, 0 
	GOTO        L__signalization412
;MyGeiger_NT.mbas,1129 :: 		ALARM = 5000
	MOVLW       136
	MOVWF       _ALARM+0 
	MOVLW       19
	MOVWF       _ALARM+1 
L__signalization412:
;MyGeiger_NT.mbas,1131 :: 		WordToStr (ALARM, txt1)
	MOVF        _ALARM+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _ALARM+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       signalization_txt1+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyGeiger_NT.mbas,1132 :: 		ltrim (txt1)
	MOVLW       signalization_txt1+0
	MOVWF       FARG_ltrim_astring+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,1133 :: 		MyText_LCD (51, 2, "     ")
	MOVLW       51
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       32
	MOVWF       ?LocalText_signalization+0 
	MOVLW       32
	MOVWF       ?LocalText_signalization+1 
	MOVLW       32
	MOVWF       ?LocalText_signalization+2 
	MOVLW       32
	MOVWF       ?LocalText_signalization+3 
	MOVLW       32
	MOVWF       ?LocalText_signalization+4 
	CLRF        ?LocalText_signalization+5 
	MOVLW       ?LocalText_signalization+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_signalization+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1134 :: 		MyText_LCD (51, 2, txt1)
	MOVLW       51
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       signalization_txt1+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__signalization409:
;MyGeiger_NT.mbas,1137 :: 		if Button (PORTB, 6, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__signalization415
;MyGeiger_NT.mbas,1138 :: 		ALARM = ALARM - shag
	MOVF        signalization_shag+0, 0 
	SUBWF       _ALARM+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _ALARM+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _ALARM+0 
	MOVF        R2, 0 
	MOVWF       _ALARM+1 
;MyGeiger_NT.mbas,1139 :: 		if ALARM<10 then
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__signalization829
	MOVLW       10
	SUBWF       R1, 0 
L__signalization829:
	BTFSC       STATUS+0, 0 
	GOTO        L__signalization418
;MyGeiger_NT.mbas,1140 :: 		ALARM = 10
	MOVLW       10
	MOVWF       _ALARM+0 
	MOVLW       0
	MOVWF       _ALARM+1 
L__signalization418:
;MyGeiger_NT.mbas,1142 :: 		WordToStr (ALARM, txt1)
	MOVF        _ALARM+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _ALARM+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       signalization_txt1+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyGeiger_NT.mbas,1143 :: 		ltrim(txt1)
	MOVLW       signalization_txt1+0
	MOVWF       FARG_ltrim_astring+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,1144 :: 		MyText_LCD (51, 2, "     ")
	MOVLW       51
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       32
	MOVWF       ?LocalText_signalization+0 
	MOVLW       32
	MOVWF       ?LocalText_signalization+1 
	MOVLW       32
	MOVWF       ?LocalText_signalization+2 
	MOVLW       32
	MOVWF       ?LocalText_signalization+3 
	MOVLW       32
	MOVWF       ?LocalText_signalization+4 
	CLRF        ?LocalText_signalization+5 
	MOVLW       ?LocalText_signalization+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_signalization+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1145 :: 		MyText_LCD (51, 2, txt1)
	MOVLW       51
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       signalization_txt1+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(signalization_txt1+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__signalization415:
;MyGeiger_NT.mbas,1148 :: 		if Button (PORTB, 5, 150, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       150
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__signalization421
;MyGeiger_NT.mbas,1149 :: 		ALARM_L = Lo (ALARM)
	MOVF        _ALARM+0, 0 
	MOVWF       _ALARM_L+0 
;MyGeiger_NT.mbas,1150 :: 		ALARM_H = Hi (ALARM)
	MOVF        _ALARM+1, 0 
	MOVWF       _ALARM_H+0 
;MyGeiger_NT.mbas,1151 :: 		EEPROM_Write (0x02,ALARM_L)
	MOVLW       2
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _ALARM+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1152 :: 		EEPROM_Write (0x03,ALARM_H)
	MOVLW       3
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _ALARM_H+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1153 :: 		goto CHANGE2
	GOTO        L__signalization_change2
L__signalization421:
;MyGeiger_NT.mbas,1155 :: 		wend
	GOTO        L__signalization401
;MyGeiger_NT.mbas,1156 :: 		CHANGE2:
L__signalization_change2:
;MyGeiger_NT.mbas,1157 :: 		ALARM = ALARM / 60             'convert ALARM to cps
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _ALARM+0, 0 
	MOVWF       R0 
	MOVF        _ALARM+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ALARM+0 
	MOVF        R1, 0 
	MOVWF       _ALARM+1 
;MyGeiger_NT.mbas,1158 :: 		ClearLCD()
	CALL        _ClearLCD+0, 0
;MyGeiger_NT.mbas,1159 :: 		end sub
L_end_signalization:
	RETURN      0
; end of _signalization

_parameters:

;MyGeiger_NT.mbas,1161 :: 		sub procedure parameters()                     ' show saved parameters at startup
;MyGeiger_NT.mbas,1163 :: 		MyText_LCD(0,0, "MAX CPM:")
	CLRF        FARG_MyText_LCD_x+0 
	CLRF        FARG_MyText_LCD_y+0 
	MOVLW       77
	MOVWF       ?LocalText_parameters+0 
	MOVLW       65
	MOVWF       ?LocalText_parameters+1 
	MOVLW       88
	MOVWF       ?LocalText_parameters+2 
	MOVLW       32
	MOVWF       ?LocalText_parameters+3 
	MOVLW       67
	MOVWF       ?LocalText_parameters+4 
	MOVLW       80
	MOVWF       ?LocalText_parameters+5 
	MOVLW       77
	MOVWF       ?LocalText_parameters+6 
	MOVLW       58
	MOVWF       ?LocalText_parameters+7 
	CLRF        ?LocalText_parameters+8 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1164 :: 		LongWordToStr (cpm_max, CPM_Display)
	MOVF        _cpm_max+0, 0 
	MOVWF       FARG_LongWordToStr_input+0 
	MOVF        _cpm_max+1, 0 
	MOVWF       FARG_LongWordToStr_input+1 
	MOVF        _cpm_max+2, 0 
	MOVWF       FARG_LongWordToStr_input+2 
	MOVF        _cpm_max+3, 0 
	MOVWF       FARG_LongWordToStr_input+3 
	MOVLW       _CPM_Display+0
	MOVWF       FARG_LongWordToStr_output+0 
	MOVLW       hi_addr(_CPM_Display+0)
	MOVWF       FARG_LongWordToStr_output+1 
	CALL        _LongWordToStr+0, 0
;MyGeiger_NT.mbas,1165 :: 		ltrim(CPM_Display)
	MOVLW       _CPM_Display+0
	MOVWF       FARG_ltrim_astring+0 
	MOVLW       hi_addr(_CPM_Display+0)
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,1166 :: 		MyText_LCD(50,0, CPM_Display)
	MOVLW       50
	MOVWF       FARG_MyText_LCD_x+0 
	CLRF        FARG_MyText_LCD_y+0 
	MOVLW       _CPM_Display+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_CPM_Display+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1168 :: 		MyText_LCD(0,1, "CF=0.0")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       1
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       67
	MOVWF       ?LocalText_parameters+0 
	MOVLW       70
	MOVWF       ?LocalText_parameters+1 
	MOVLW       61
	MOVWF       ?LocalText_parameters+2 
	MOVLW       48
	MOVWF       ?LocalText_parameters+3 
	MOVLW       46
	MOVWF       ?LocalText_parameters+4 
	MOVLW       48
	MOVWF       ?LocalText_parameters+5 
	CLRF        ?LocalText_parameters+6 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1169 :: 		ch = (CF div 100) mod 10
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1170 :: 		PositionLCD(36, 1)
	MOVLW       36
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1171 :: 		Char_LCD (48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,1172 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1173 :: 		ch = (CF div 10) mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1174 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,1175 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1176 :: 		ch = CF mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1177 :: 		Char_LCD (48+ch)
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Char_LCD_bykva+0 
	CALL        _Char_LCD+0, 0
;MyGeiger_NT.mbas,1179 :: 		MyText_LCD(0,2, "BG=")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       66
	MOVWF       ?LocalText_parameters+0 
	MOVLW       71
	MOVWF       ?LocalText_parameters+1 
	MOVLW       61
	MOVWF       ?LocalText_parameters+2 
	CLRF        ?LocalText_parameters+3 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1180 :: 		ByteToStr (BG, tube_limit_txt)
	MOVF        _BG+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1181 :: 		MyText_LCD(20, 2, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1182 :: 		MyText_LCD(50,2, "CPM")
	MOVLW       50
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       67
	MOVWF       ?LocalText_parameters+0 
	MOVLW       80
	MOVWF       ?LocalText_parameters+1 
	MOVLW       77
	MOVWF       ?LocalText_parameters+2 
	CLRF        ?LocalText_parameters+3 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1184 :: 		MyText_LCD(0,3, "SQ=")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       3
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       83
	MOVWF       ?LocalText_parameters+0 
	MOVLW       81
	MOVWF       ?LocalText_parameters+1 
	MOVLW       61
	MOVWF       ?LocalText_parameters+2 
	CLRF        ?LocalText_parameters+3 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1185 :: 		ByteToStr (tube_square, tube_limit_txt)
	MOVF        _tube_square+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1186 :: 		MyText_LCD(20, 3, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       3
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1187 :: 		MyText_LCD(50,3, "cm^2")
	MOVLW       50
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       3
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       99
	MOVWF       ?LocalText_parameters+0 
	MOVLW       109
	MOVWF       ?LocalText_parameters+1 
	MOVLW       94
	MOVWF       ?LocalText_parameters+2 
	MOVLW       50
	MOVWF       ?LocalText_parameters+3 
	CLRF        ?LocalText_parameters+4 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1189 :: 		MyText_LCD(0,4, "DL=")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       4
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       68
	MOVWF       ?LocalText_parameters+0 
	MOVLW       76
	MOVWF       ?LocalText_parameters+1 
	MOVLW       61
	MOVWF       ?LocalText_parameters+2 
	CLRF        ?LocalText_parameters+3 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1190 :: 		ByteToStr (DL, tube_limit_txt)
	MOVF        _DL+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1191 :: 		MyText_LCD(20, 4, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       4
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1192 :: 		MyText_LCD(50,4, "CPM")
	MOVLW       50
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       4
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       67
	MOVWF       ?LocalText_parameters+0 
	MOVLW       80
	MOVWF       ?LocalText_parameters+1 
	MOVLW       77
	MOVWF       ?LocalText_parameters+2 
	CLRF        ?LocalText_parameters+3 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1194 :: 		MyText_LCD(0,5, "DT=")
	CLRF        FARG_MyText_LCD_x+0 
	MOVLW       5
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       68
	MOVWF       ?LocalText_parameters+0 
	MOVLW       84
	MOVWF       ?LocalText_parameters+1 
	MOVLW       61
	MOVWF       ?LocalText_parameters+2 
	CLRF        ?LocalText_parameters+3 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1195 :: 		ByteToStr (DT, tube_limit_txt)
	MOVF        _DT+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1196 :: 		MyText_LCD(20, 5, tube_limit_txt)
	MOVLW       20
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       5
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       _tube_limit_txt+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(_tube_limit_txt+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1197 :: 		MyText_LCD(50,5, "micro seconds")
	MOVLW       50
	MOVWF       FARG_MyText_LCD_x+0 
	MOVLW       5
	MOVWF       FARG_MyText_LCD_y+0 
	MOVLW       109
	MOVWF       ?LocalText_parameters+0 
	MOVLW       105
	MOVWF       ?LocalText_parameters+1 
	MOVLW       99
	MOVWF       ?LocalText_parameters+2 
	MOVLW       114
	MOVWF       ?LocalText_parameters+3 
	MOVLW       111
	MOVWF       ?LocalText_parameters+4 
	MOVLW       32
	MOVWF       ?LocalText_parameters+5 
	MOVLW       115
	MOVWF       ?LocalText_parameters+6 
	MOVLW       101
	MOVWF       ?LocalText_parameters+7 
	MOVLW       99
	MOVWF       ?LocalText_parameters+8 
	MOVLW       111
	MOVWF       ?LocalText_parameters+9 
	MOVLW       110
	MOVWF       ?LocalText_parameters+10 
	MOVLW       100
	MOVWF       ?LocalText_parameters+11 
	MOVLW       115
	MOVWF       ?LocalText_parameters+12 
	CLRF        ?LocalText_parameters+13 
	MOVLW       ?LocalText_parameters+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_parameters+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1200 :: 		delay_ms(2000)
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L__parameters424:
	DECFSZ      R13, 1, 1
	BRA         L__parameters424
	DECFSZ      R12, 1, 1
	BRA         L__parameters424
	DECFSZ      R11, 1, 1
	BRA         L__parameters424
	NOP
	NOP
;MyGeiger_NT.mbas,1201 :: 		ClearLCD()
	CALL        _ClearLCD+0, 0
;MyGeiger_NT.mbas,1204 :: 		end sub
L_end_parameters:
	RETURN      0
; end of _parameters

_dosextract:

;MyGeiger_NT.mbas,1207 :: 		sub procedure dosextract()
;MyGeiger_NT.mbas,1209 :: 		if dose < 100000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract832
	MOVLW       1
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract832
	MOVLW       134
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract832
	MOVLW       160
	SUBWF       _dose+0, 0 
L__dosextract832:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract427
;MyGeiger_NT.mbas,1210 :: 		Text_LCD(54,2,",")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       44
	MOVWF       ?LocalText_dosextract+0 
	CLRF        ?LocalText_dosextract+1 
	MOVLW       ?LocalText_dosextract+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1211 :: 		ch = (dose div 10000)
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1212 :: 		LCD_Chr_Big(10, 1, ch)
	MOVLW       10
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1213 :: 		PositionLCD (22, 1)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1214 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract430:
;MyGeiger_NT.mbas,1215 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1216 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract433
	INCF        _hh+0, 1 
	GOTO        L__dosextract430
L__dosextract433:
;MyGeiger_NT.mbas,1217 :: 		PositionLCD (22, 2)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1218 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract435:
;MyGeiger_NT.mbas,1219 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1220 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract438
	INCF        _hh+0, 1 
	GOTO        L__dosextract435
L__dosextract438:
;MyGeiger_NT.mbas,1221 :: 		Text_LCD(22,2,")")
	MOVLW       22
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       41
	MOVWF       ?LocalText_dosextract+0 
	CLRF        ?LocalText_dosextract+1 
	MOVLW       ?LocalText_dosextract+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1222 :: 		ch = (dose div 1000) mod 10
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1223 :: 		LCD_Chr_Big(27, 1, ch)
	MOVLW       27
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1224 :: 		ch = (dose div 100) mod 10
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1225 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
	GOTO        L__dosextract428
;MyGeiger_NT.mbas,1226 :: 		else
L__dosextract427:
;MyGeiger_NT.mbas,1227 :: 		if dose < 1000000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract833
	MOVLW       15
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract833
	MOVLW       66
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract833
	MOVLW       64
	SUBWF       _dose+0, 0 
L__dosextract833:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract440
;MyGeiger_NT.mbas,1228 :: 		Text_LCD(54,2,",")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       44
	MOVWF       ?LocalText_dosextract+0 
	CLRF        ?LocalText_dosextract+1 
	MOVLW       ?LocalText_dosextract+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1230 :: 		ch = (dose div 100000)
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1231 :: 		LCD_Chr_Big(10, 1, ch)
	MOVLW       10
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1232 :: 		ch = (dose div 10000) mod 10
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1233 :: 		LCD_Chr_Big (22, 1, ch)
	MOVLW       22
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1234 :: 		PositionLCD (34, 1)
	MOVLW       34
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1235 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract443:
;MyGeiger_NT.mbas,1236 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1237 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract446
	INCF        _hh+0, 1 
	GOTO        L__dosextract443
L__dosextract446:
;MyGeiger_NT.mbas,1238 :: 		PositionLCD (34, 2)
	MOVLW       34
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1239 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract448:
;MyGeiger_NT.mbas,1240 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1241 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract451
	INCF        _hh+0, 1 
	GOTO        L__dosextract448
L__dosextract451:
;MyGeiger_NT.mbas,1242 :: 		Text_LCD (34, 2, ")")
	MOVLW       34
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       41
	MOVWF       ?LocalText_dosextract+0 
	CLRF        ?LocalText_dosextract+1 
	MOVLW       ?LocalText_dosextract+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1243 :: 		ch = (dose div 1000) mod 10
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1244 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
	GOTO        L__dosextract441
;MyGeiger_NT.mbas,1245 :: 		else
L__dosextract440:
;MyGeiger_NT.mbas,1246 :: 		Text_LCD(54,2,"+")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       43
	MOVWF       ?LocalText_dosextract+0 
	CLRF        ?LocalText_dosextract+1 
	MOVLW       ?LocalText_dosextract+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1247 :: 		ch = (dose div 10000000)
	MOVLW       128
	MOVWF       R4 
	MOVLW       150
	MOVWF       R5 
	MOVLW       152
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1248 :: 		LCD_Chr_Big (10, 1, ch)
	MOVLW       10
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1249 :: 		PositionLCD (22, 1)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1250 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract453:
;MyGeiger_NT.mbas,1251 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1252 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract456
	INCF        _hh+0, 1 
	GOTO        L__dosextract453
L__dosextract456:
;MyGeiger_NT.mbas,1253 :: 		PositionLCD (22, 2)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1254 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract458:
;MyGeiger_NT.mbas,1255 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1256 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract461
	INCF        _hh+0, 1 
	GOTO        L__dosextract458
L__dosextract461:
;MyGeiger_NT.mbas,1257 :: 		Text_LCD (22, 2, ")")
	MOVLW       22
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       41
	MOVWF       ?LocalText_dosextract+0 
	CLRF        ?LocalText_dosextract+1 
	MOVLW       ?LocalText_dosextract+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1258 :: 		ch = (dose div 1000000) mod 10
	MOVLW       64
	MOVWF       R4 
	MOVLW       66
	MOVWF       R5 
	MOVLW       15
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1259 :: 		LCD_Chr_Big (27, 1, ch)
	MOVLW       27
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1260 :: 		ch = (dose div 100000) mod 10
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1261 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1266 :: 		end if
L__dosextract441:
;MyGeiger_NT.mbas,1267 :: 		end if
L__dosextract428:
;MyGeiger_NT.mbas,1269 :: 		end sub
L_end_dosextract:
	RETURN      0
; end of _dosextract

_dosextract2:

;MyGeiger_NT.mbas,1273 :: 		sub procedure dosextract2()
;MyGeiger_NT.mbas,1275 :: 		if dose < 1000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2835
	MOVLW       0
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2835
	MOVLW       3
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2835
	MOVLW       232
	SUBWF       _dose+0, 0 
L__dosextract2835:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract2464
;MyGeiger_NT.mbas,1276 :: 		Text_LCD(54,2,",")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       44
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1277 :: 		ch = (dose div 100)
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1278 :: 		LCD_Chr_Big(10, 1, ch)
	MOVLW       10
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1279 :: 		PositionLCD (22, 1)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1280 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract2467:
;MyGeiger_NT.mbas,1281 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1282 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2470
	INCF        _hh+0, 1 
	GOTO        L__dosextract2467
L__dosextract2470:
;MyGeiger_NT.mbas,1283 :: 		PositionLCD (22, 2)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1284 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract2472:
;MyGeiger_NT.mbas,1285 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1286 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2475
	INCF        _hh+0, 1 
	GOTO        L__dosextract2472
L__dosextract2475:
;MyGeiger_NT.mbas,1287 :: 		Text_LCD(22,2,")")
	MOVLW       22
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       41
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1288 :: 		ch = (dose div 10) mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1289 :: 		LCD_Chr_Big(27, 1, ch)
	MOVLW       27
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1290 :: 		ch = dose mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1291 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
	GOTO        L__dosextract2465
;MyGeiger_NT.mbas,1292 :: 		else
L__dosextract2464:
;MyGeiger_NT.mbas,1293 :: 		if dose < 10000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2836
	MOVLW       0
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2836
	MOVLW       39
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2836
	MOVLW       16
	SUBWF       _dose+0, 0 
L__dosextract2836:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract2477
;MyGeiger_NT.mbas,1294 :: 		Text_LCD(54,2,",")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       44
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1296 :: 		ch = (dose div 1000)
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1297 :: 		LCD_Chr_Big(10, 1, ch)
	MOVLW       10
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1298 :: 		ch = (dose div 100) mod 10
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1299 :: 		LCD_Chr_Big (22, 1, ch)
	MOVLW       22
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1300 :: 		PositionLCD (34, 1)
	MOVLW       34
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1301 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract2480:
;MyGeiger_NT.mbas,1302 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1303 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2483
	INCF        _hh+0, 1 
	GOTO        L__dosextract2480
L__dosextract2483:
;MyGeiger_NT.mbas,1304 :: 		PositionLCD (34, 2)
	MOVLW       34
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1305 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract2485:
;MyGeiger_NT.mbas,1306 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1307 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2488
	INCF        _hh+0, 1 
	GOTO        L__dosextract2485
L__dosextract2488:
;MyGeiger_NT.mbas,1308 :: 		Text_LCD (34, 2, ")")
	MOVLW       34
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       41
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1309 :: 		ch = (dose div 10) mod 10
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1310 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
	GOTO        L__dosextract2478
;MyGeiger_NT.mbas,1311 :: 		else
L__dosextract2477:
;MyGeiger_NT.mbas,1312 :: 		if dose < 1000000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2837
	MOVLW       15
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2837
	MOVLW       66
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2837
	MOVLW       64
	SUBWF       _dose+0, 0 
L__dosextract2837:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract2490
;MyGeiger_NT.mbas,1313 :: 		Text_LCD(54,2,"+")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       43
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1314 :: 		ch = (dose div 100000)
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1315 :: 		LCD_Chr_Big (10, 1, ch)
	MOVLW       10
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1316 :: 		PositionLCD (22, 1)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1317 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract2493:
;MyGeiger_NT.mbas,1318 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1319 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2496
	INCF        _hh+0, 1 
	GOTO        L__dosextract2493
L__dosextract2496:
;MyGeiger_NT.mbas,1320 :: 		PositionLCD (22, 2)
	MOVLW       22
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1321 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract2498:
;MyGeiger_NT.mbas,1322 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1323 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2501
	INCF        _hh+0, 1 
	GOTO        L__dosextract2498
L__dosextract2501:
;MyGeiger_NT.mbas,1324 :: 		Text_LCD (22, 2, ")")
	MOVLW       22
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       41
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1325 :: 		ch = (dose div 10000) mod 10
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1326 :: 		LCD_Chr_Big (27, 1, ch)
	MOVLW       27
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1327 :: 		ch = (dose div 1000) mod 10
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1328 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
	GOTO        L__dosextract2491
;MyGeiger_NT.mbas,1329 :: 		else
L__dosextract2490:
;MyGeiger_NT.mbas,1330 :: 		if dose <10000000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2838
	MOVLW       152
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2838
	MOVLW       150
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract2838
	MOVLW       128
	SUBWF       _dose+0, 0 
L__dosextract2838:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract2503
;MyGeiger_NT.mbas,1331 :: 		Text_LCD(54,2,"+")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       43
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1332 :: 		ch = (dose div 1000000)
	MOVLW       64
	MOVWF       R4 
	MOVLW       66
	MOVWF       R5 
	MOVLW       15
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1333 :: 		LCD_Chr_Big (10, 1, ch)
	MOVLW       10
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1334 :: 		ch = (dose div 100000) mod 10
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1335 :: 		LCD_Chr_Big (22, 1, ch)
	MOVLW       22
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1336 :: 		PositionLCD (34, 1)
	MOVLW       34
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1337 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract2506:
;MyGeiger_NT.mbas,1338 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1339 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2509
	INCF        _hh+0, 1 
	GOTO        L__dosextract2506
L__dosextract2509:
;MyGeiger_NT.mbas,1340 :: 		PositionLCD (34, 2)
	MOVLW       34
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1341 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract2511:
;MyGeiger_NT.mbas,1342 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1343 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2514
	INCF        _hh+0, 1 
	GOTO        L__dosextract2511
L__dosextract2514:
;MyGeiger_NT.mbas,1344 :: 		Text_LCD (34, 2, ")")
	MOVLW       34
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       41
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1345 :: 		ch = (dose div 10000) mod 10
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1346 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
	GOTO        L__dosextract2504
;MyGeiger_NT.mbas,1347 :: 		else
L__dosextract2503:
;MyGeiger_NT.mbas,1348 :: 		Text_LCD(54,2,"+")
	MOVLW       54
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       43
	MOVWF       ?LocalText_dosextract2+0 
	CLRF        ?LocalText_dosextract2+1 
	MOVLW       ?LocalText_dosextract2+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract2+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1349 :: 		PositionLCD (10, 1)
	MOVLW       10
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       1
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1350 :: 		for hh = 0 to 11
	CLRF        _hh+0 
L__dosextract2516:
;MyGeiger_NT.mbas,1351 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1352 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2519
	INCF        _hh+0, 1 
	GOTO        L__dosextract2516
L__dosextract2519:
;MyGeiger_NT.mbas,1353 :: 		PositionLCD (10, 2)
	MOVLW       10
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1354 :: 		for hh = 12 to 23
	MOVLW       12
	MOVWF       _hh+0 
L__dosextract2521:
;MyGeiger_NT.mbas,1355 :: 		Soft_SPI_Write (KK[hh])
	MOVLW       _KK+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_KK+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_KK+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1356 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L__dosextract2524
	INCF        _hh+0, 1 
	GOTO        L__dosextract2521
L__dosextract2524:
;MyGeiger_NT.mbas,1357 :: 		ch = (dose div 10000000)
	MOVLW       128
	MOVWF       R4 
	MOVLW       150
	MOVWF       R5 
	MOVLW       152
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1358 :: 		LCD_Chr_Big (15, 1, ch)
	MOVLW       15
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1359 :: 		ch = (dose div 1000000) mod 10
	MOVLW       64
	MOVWF       R4 
	MOVLW       66
	MOVWF       R5 
	MOVLW       15
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1360 :: 		LCD_Chr_Big (27, 1, ch)
	MOVLW       27
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1361 :: 		ch = (dose div 100000) mod 10
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1362 :: 		LCD_Chr_Big (39, 1, ch)
	MOVLW       39
	MOVWF       FARG_LCD_Chr_Big_px+0 
	MOVLW       1
	MOVWF       FARG_LCD_Chr_Big_py+0 
	MOVF        R0, 0 
	MOVWF       FARG_LCD_Chr_Big_digit+0 
	CALL        _LCD_Chr_Big+0, 0
;MyGeiger_NT.mbas,1363 :: 		end if
L__dosextract2504:
;MyGeiger_NT.mbas,1365 :: 		end if
L__dosextract2491:
;MyGeiger_NT.mbas,1370 :: 		end if
L__dosextract2478:
;MyGeiger_NT.mbas,1371 :: 		end if
L__dosextract2465:
;MyGeiger_NT.mbas,1375 :: 		end sub
L_end_dosextract2:
	RETURN      0
; end of _dosextract2

_dosextract3:

;MyGeiger_NT.mbas,1377 :: 		sub procedure dosextract3()
;MyGeiger_NT.mbas,1378 :: 		if dose < 100000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract3840
	MOVLW       1
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract3840
	MOVLW       134
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract3840
	MOVLW       160
	SUBWF       _dose+0, 0 
L__dosextract3840:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract3527
;MyGeiger_NT.mbas,1379 :: 		Text_LCD(122,7,",")
	MOVLW       122
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       44
	MOVWF       ?LocalText_dosextract3+0 
	CLRF        ?LocalText_dosextract3+1 
	MOVLW       ?LocalText_dosextract3+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract3+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1380 :: 		ch = (dose div 10000)
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1381 :: 		PositionLCD(100,7)
	MOVLW       100
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1382 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,1383 :: 		Text_LCD(105, 7, "/")
	MOVLW       105
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       47
	MOVWF       ?LocalText_dosextract3+0 
	CLRF        ?LocalText_dosextract3+1 
	MOVLW       ?LocalText_dosextract3+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract3+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1384 :: 		ch = (dose div 1000) mod 10
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1385 :: 		PositionLCD(110,7)
	MOVLW       110
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1386 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,1387 :: 		ch = (dose div 100) mod 10
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1388 :: 		PositionLCD(115,7)
	MOVLW       115
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1389 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
	GOTO        L__dosextract3528
;MyGeiger_NT.mbas,1390 :: 		else
L__dosextract3527:
;MyGeiger_NT.mbas,1391 :: 		if dose < 1000000 then
	MOVLW       0
	SUBWF       _dose+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract3841
	MOVLW       15
	SUBWF       _dose+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract3841
	MOVLW       66
	SUBWF       _dose+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dosextract3841
	MOVLW       64
	SUBWF       _dose+0, 0 
L__dosextract3841:
	BTFSC       STATUS+0, 0 
	GOTO        L__dosextract3530
;MyGeiger_NT.mbas,1392 :: 		Text_LCD(122, 7, ",")
	MOVLW       122
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       44
	MOVWF       ?LocalText_dosextract3+0 
	CLRF        ?LocalText_dosextract3+1 
	MOVLW       ?LocalText_dosextract3+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract3+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1393 :: 		ch = (dose div 100000)
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1394 :: 		PositionLCD(100,7)
	MOVLW       100
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1395 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,1396 :: 		ch = (dose div 10000) mod 10
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1397 :: 		PositionLCD(105,7)
	MOVLW       105
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1398 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,1399 :: 		Text_LCD (110, 7, "/")
	MOVLW       110
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       47
	MOVWF       ?LocalText_dosextract3+0 
	CLRF        ?LocalText_dosextract3+1 
	MOVLW       ?LocalText_dosextract3+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract3+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1400 :: 		ch = (dose div 1000) mod 10
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1401 :: 		PositionLCD(115,7)
	MOVLW       115
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1402 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
	GOTO        L__dosextract3531
;MyGeiger_NT.mbas,1403 :: 		else
L__dosextract3530:
;MyGeiger_NT.mbas,1404 :: 		Text_LCD(122, 7, "+")
	MOVLW       122
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       43
	MOVWF       ?LocalText_dosextract3+0 
	CLRF        ?LocalText_dosextract3+1 
	MOVLW       ?LocalText_dosextract3+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract3+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1405 :: 		ch = (dose div 10000000)
	MOVLW       128
	MOVWF       R4 
	MOVLW       150
	MOVWF       R5 
	MOVLW       152
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1406 :: 		PositionLCD(100,7)
	MOVLW       100
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1407 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,1408 :: 		Text_LCD (105, 7, "/")
	MOVLW       105
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       47
	MOVWF       ?LocalText_dosextract3+0 
	CLRF        ?LocalText_dosextract3+1 
	MOVLW       ?LocalText_dosextract3+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_dosextract3+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1409 :: 		ch = (dose div 1000000) mod 10
	MOVLW       64
	MOVWF       R4 
	MOVLW       66
	MOVWF       R5 
	MOVLW       15
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1410 :: 		PositionLCD(110,7)
	MOVLW       110
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1411 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,1412 :: 		ch = (dose div 100000) mod 10
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	MOVF        _dose+0, 0 
	MOVWF       R0 
	MOVF        _dose+1, 0 
	MOVWF       R1 
	MOVF        _dose+2, 0 
	MOVWF       R2 
	MOVF        _dose+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _ch+0 
	MOVF        R1, 0 
	MOVWF       _ch+1 
;MyGeiger_NT.mbas,1413 :: 		PositionLCD(115,7)
	MOVLW       115
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1414 :: 		Chr_LCD(48+ch)
	MOVF        _ch+0, 0 
	ADDLW       48
	MOVWF       FARG_Chr_LCD_symlcd+0 
	CALL        _Chr_LCD+0, 0
;MyGeiger_NT.mbas,1415 :: 		end if
L__dosextract3531:
;MyGeiger_NT.mbas,1416 :: 		end if
L__dosextract3528:
;MyGeiger_NT.mbas,1417 :: 		end sub
L_end_dosextract3:
	RETURN      0
; end of _dosextract3

_printSV:

;MyGeiger_NT.mbas,1420 :: 		sub procedure printSV()
;MyGeiger_NT.mbas,1421 :: 		PositionLCD (60, 2)
	MOVLW       60
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1422 :: 		for nn = 0 to 19
	CLRF        _nn+0 
	CLRF        _nn+1 
L__printSV534:
;MyGeiger_NT.mbas,1423 :: 		Soft_SPI_Write (uSv_label[nn])
	MOVLW       _uSv_label+0
	ADDWF       _nn+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_uSv_label+0)
	ADDWFC      _nn+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_uSv_label+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1424 :: 		next nn
	MOVLW       0
	XORWF       _nn+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__printSV843
	MOVLW       19
	XORWF       _nn+0, 0 
L__printSV843:
	BTFSC       STATUS+0, 2 
	GOTO        L__printSV537
	INFSNZ      _nn+0, 1 
	INCF        _nn+1, 1 
	GOTO        L__printSV534
L__printSV537:
;MyGeiger_NT.mbas,1425 :: 		end sub
L_end_printSV:
	RETURN      0
; end of _printSV

_printRN:

;MyGeiger_NT.mbas,1427 :: 		sub procedure printRN()
;MyGeiger_NT.mbas,1428 :: 		PositionLCD (60, 2)
	MOVLW       60
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1429 :: 		for nn = 0 to 19
	CLRF        _nn+0 
	CLRF        _nn+1 
L__printRN540:
;MyGeiger_NT.mbas,1430 :: 		Soft_SPI_Write (uRn_label[nn])
	MOVLW       _uRn_label+0
	ADDWF       _nn+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_uRn_label+0)
	ADDWFC      _nn+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_uRn_label+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1431 :: 		next nn
	MOVLW       0
	XORWF       _nn+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__printRN845
	MOVLW       19
	XORWF       _nn+0, 0 
L__printRN845:
	BTFSC       STATUS+0, 2 
	GOTO        L__printRN543
	INFSNZ      _nn+0, 1 
	INCF        _nn+1, 1 
	GOTO        L__printRN540
L__printRN543:
;MyGeiger_NT.mbas,1432 :: 		end sub
L_end_printRN:
	RETURN      0
; end of _printRN

_stolbik:

;MyGeiger_NT.mbas,1436 :: 		dim mesto, position as byte
;MyGeiger_NT.mbas,1437 :: 		position = 0
	CLRF        stolbik_position+0 
;MyGeiger_NT.mbas,1438 :: 		if G_cpm_max = 0 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _G_cpm_max+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik847
	MOVF        R0, 0 
	XORWF       _G_cpm_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik847
	MOVF        R0, 0 
	XORWF       _G_cpm_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik847
	MOVF        _G_cpm_max+0, 0 
	XORLW       0
L__stolbik847:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik546
;MyGeiger_NT.mbas,1439 :: 		G_cpm_max = 1          '+1 to avoid Zero division
	MOVLW       1
	MOVWF       _G_cpm_max+0 
	MOVLW       0
	MOVWF       _G_cpm_max+1 
	MOVWF       _G_cpm_max+2 
	MOVWF       _G_cpm_max+3 
L__stolbik546:
;MyGeiger_NT.mbas,1441 :: 		for mesto = 63 to 0 step - 1              '29
	MOVLW       63
	MOVWF       stolbik_mesto+0 
L__stolbik549:
;MyGeiger_NT.mbas,1442 :: 		s_high2 = (D_HIGH * G_cpm[mesto]) div G_cpm_max
	MOVF        stolbik_mesto+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _G_cpm+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_G_cpm+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        POSTINC0+0, 0 
	MOVWF       R7 
	MOVF        POSTINC0+0, 0 
	MOVWF       R8 
	MOVLW       4
	MOVWF       R4 
	MOVF        R5, 0 
	MOVWF       R0 
	MOVF        R6, 0 
	MOVWF       R1 
	MOVF        R7, 0 
	MOVWF       R2 
	MOVF        R8, 0 
	MOVWF       R3 
	MOVF        R4, 0 
L__stolbik848:
	BZ          L__stolbik849
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	ADDLW       255
	GOTO        L__stolbik848
L__stolbik849:
	MOVF        _G_cpm_max+0, 0 
	MOVWF       R4 
	MOVF        _G_cpm_max+1, 0 
	MOVWF       R5 
	MOVF        _G_cpm_max+2, 0 
	MOVWF       R6 
	MOVF        _G_cpm_max+3, 0 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _s_high2+0 
	MOVF        R1, 0 
	MOVWF       _s_high2+1 
	MOVF        R2, 0 
	MOVWF       _s_high2+2 
	MOVF        R3, 0 
	MOVWF       _s_high2+3 
;MyGeiger_NT.mbas,1444 :: 		if s_high2> 8  then
	MOVF        R3, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik850
	MOVF        R2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik850
	MOVF        R1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik850
	MOVF        R0, 0 
	SUBLW       8
L__stolbik850:
	BTFSC       STATUS+0, 0 
	GOTO        L__stolbik554
;MyGeiger_NT.mbas,1445 :: 		byte_low = %11111111
	MOVLW       255
	MOVWF       _byte_low+0 
;MyGeiger_NT.mbas,1447 :: 		if s_high2 = 8 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik851
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik851
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik851
	MOVF        _s_high2+0, 0 
	XORLW       8
L__stolbik851:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik557
;MyGeiger_NT.mbas,1448 :: 		byte_high = %10000000
	MOVLW       128
	MOVWF       _byte_high+0 
L__stolbik557:
;MyGeiger_NT.mbas,1450 :: 		if s_high2 = 9 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik852
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik852
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik852
	MOVF        _s_high2+0, 0 
	XORLW       9
L__stolbik852:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik560
;MyGeiger_NT.mbas,1451 :: 		byte_high = %10000000
	MOVLW       128
	MOVWF       _byte_high+0 
L__stolbik560:
;MyGeiger_NT.mbas,1453 :: 		if s_high2 = 10 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik853
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik853
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik853
	MOVF        _s_high2+0, 0 
	XORLW       10
L__stolbik853:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik563
;MyGeiger_NT.mbas,1454 :: 		byte_high = %11000000
	MOVLW       192
	MOVWF       _byte_high+0 
L__stolbik563:
;MyGeiger_NT.mbas,1456 :: 		if s_high2 = 11 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik854
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik854
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik854
	MOVF        _s_high2+0, 0 
	XORLW       11
L__stolbik854:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik566
;MyGeiger_NT.mbas,1457 :: 		byte_high = %11100000
	MOVLW       224
	MOVWF       _byte_high+0 
L__stolbik566:
;MyGeiger_NT.mbas,1459 :: 		if s_high2 = 12 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik855
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik855
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik855
	MOVF        _s_high2+0, 0 
	XORLW       12
L__stolbik855:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik569
;MyGeiger_NT.mbas,1460 :: 		byte_high = %11110000
	MOVLW       240
	MOVWF       _byte_high+0 
L__stolbik569:
;MyGeiger_NT.mbas,1462 :: 		if s_high2 = 13 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik856
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik856
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik856
	MOVF        _s_high2+0, 0 
	XORLW       13
L__stolbik856:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik572
;MyGeiger_NT.mbas,1463 :: 		byte_high = %11111000
	MOVLW       248
	MOVWF       _byte_high+0 
L__stolbik572:
;MyGeiger_NT.mbas,1465 :: 		if s_high2 = 14 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik857
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik857
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik857
	MOVF        _s_high2+0, 0 
	XORLW       14
L__stolbik857:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik575
;MyGeiger_NT.mbas,1466 :: 		byte_high = %11111100
	MOVLW       252
	MOVWF       _byte_high+0 
L__stolbik575:
;MyGeiger_NT.mbas,1468 :: 		if s_high2 = 15 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik858
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik858
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik858
	MOVF        _s_high2+0, 0 
	XORLW       15
L__stolbik858:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik578
;MyGeiger_NT.mbas,1469 :: 		byte_high = %11111110
	MOVLW       254
	MOVWF       _byte_high+0 
L__stolbik578:
;MyGeiger_NT.mbas,1471 :: 		if s_high2 = 16 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik859
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik859
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik859
	MOVF        _s_high2+0, 0 
	XORLW       16
L__stolbik859:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik581
;MyGeiger_NT.mbas,1472 :: 		byte_high = %11111111
	MOVLW       255
	MOVWF       _byte_high+0 
L__stolbik581:
;MyGeiger_NT.mbas,1473 :: 		end if
	GOTO        L__stolbik555
;MyGeiger_NT.mbas,1474 :: 		else
L__stolbik554:
;MyGeiger_NT.mbas,1475 :: 		byte_high = %00000000
	CLRF        _byte_high+0 
;MyGeiger_NT.mbas,1477 :: 		if s_high2 = 0 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik860
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik860
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik860
	MOVF        _s_high2+0, 0 
	XORLW       0
L__stolbik860:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik584
;MyGeiger_NT.mbas,1478 :: 		byte_low = %10000000
	MOVLW       128
	MOVWF       _byte_low+0 
L__stolbik584:
;MyGeiger_NT.mbas,1480 :: 		if s_high2 = 1 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik861
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik861
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik861
	MOVF        _s_high2+0, 0 
	XORLW       1
L__stolbik861:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik587
;MyGeiger_NT.mbas,1481 :: 		byte_low = %10000000
	MOVLW       128
	MOVWF       _byte_low+0 
L__stolbik587:
;MyGeiger_NT.mbas,1483 :: 		if s_high2 = 2 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik862
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik862
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik862
	MOVF        _s_high2+0, 0 
	XORLW       2
L__stolbik862:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik590
;MyGeiger_NT.mbas,1484 :: 		byte_low = %11000000
	MOVLW       192
	MOVWF       _byte_low+0 
L__stolbik590:
;MyGeiger_NT.mbas,1486 :: 		if s_high2 = 3 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik863
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik863
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik863
	MOVF        _s_high2+0, 0 
	XORLW       3
L__stolbik863:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik593
;MyGeiger_NT.mbas,1487 :: 		byte_low = %11100000
	MOVLW       224
	MOVWF       _byte_low+0 
L__stolbik593:
;MyGeiger_NT.mbas,1489 :: 		if s_high2 = 4 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik864
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik864
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik864
	MOVF        _s_high2+0, 0 
	XORLW       4
L__stolbik864:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik596
;MyGeiger_NT.mbas,1490 :: 		byte_low = %11110000
	MOVLW       240
	MOVWF       _byte_low+0 
L__stolbik596:
;MyGeiger_NT.mbas,1492 :: 		if s_high2 = 5 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik865
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik865
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik865
	MOVF        _s_high2+0, 0 
	XORLW       5
L__stolbik865:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik599
;MyGeiger_NT.mbas,1493 :: 		byte_low = %11111000
	MOVLW       248
	MOVWF       _byte_low+0 
L__stolbik599:
;MyGeiger_NT.mbas,1495 :: 		if s_high2 = 6 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik866
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik866
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik866
	MOVF        _s_high2+0, 0 
	XORLW       6
L__stolbik866:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik602
;MyGeiger_NT.mbas,1496 :: 		byte_low = %11111100
	MOVLW       252
	MOVWF       _byte_low+0 
L__stolbik602:
;MyGeiger_NT.mbas,1498 :: 		if s_high2 = 7 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik867
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik867
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik867
	MOVF        _s_high2+0, 0 
	XORLW       7
L__stolbik867:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik605
;MyGeiger_NT.mbas,1499 :: 		byte_low = %11111110
	MOVLW       254
	MOVWF       _byte_low+0 
L__stolbik605:
;MyGeiger_NT.mbas,1501 :: 		if s_high2 = 8 then
	MOVLW       0
	MOVWF       R0 
	XORWF       _s_high2+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik868
	MOVF        R0, 0 
	XORWF       _s_high2+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik868
	MOVF        R0, 0 
	XORWF       _s_high2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik868
	MOVF        _s_high2+0, 0 
	XORLW       8
L__stolbik868:
	BTFSS       STATUS+0, 2 
	GOTO        L__stolbik608
;MyGeiger_NT.mbas,1502 :: 		byte_low = %11111111
	MOVLW       255
	MOVWF       _byte_low+0 
L__stolbik608:
;MyGeiger_NT.mbas,1504 :: 		end if
L__stolbik555:
;MyGeiger_NT.mbas,1505 :: 		PositionLCD(position, 4)         '1     position+12, 1
	MOVF        stolbik_position+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       4
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1506 :: 		NOK_print(byte_high)
	MOVF        _byte_high+0, 0 
	MOVWF       FARG_NOK_Print_poloska+0 
	CALL        _NOK_Print+0, 0
;MyGeiger_NT.mbas,1507 :: 		NOK_print(0x00)
	CLRF        FARG_NOK_Print_poloska+0 
	CALL        _NOK_Print+0, 0
;MyGeiger_NT.mbas,1508 :: 		PositionLCD(position, 5)         '2
	MOVF        stolbik_position+0, 0 
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       5
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1509 :: 		NOK_print(byte_low)
	MOVF        _byte_low+0, 0 
	MOVWF       FARG_NOK_Print_poloska+0 
	CALL        _NOK_Print+0, 0
;MyGeiger_NT.mbas,1510 :: 		NOK_print(0x00)
	CLRF        FARG_NOK_Print_poloska+0 
	CALL        _NOK_Print+0, 0
;MyGeiger_NT.mbas,1511 :: 		position = position + 2
	MOVLW       2
	ADDWF       stolbik_position+0, 1 
;MyGeiger_NT.mbas,1512 :: 		next mesto
	MOVF        stolbik_mesto+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__stolbik552
	MOVLW       255
	ADDWF       stolbik_mesto+0, 1 
	GOTO        L__stolbik549
L__stolbik552:
;MyGeiger_NT.mbas,1514 :: 		end sub
L_end_stolbik:
	RETURN      0
; end of _stolbik

_main:

;MyGeiger_NT.mbas,1521 :: 		main:
;MyGeiger_NT.mbas,1523 :: 		m_period       = 59          ' wait 3 seconds for INT stabilization
	MOVLW       59
	MOVWF       _m_period+0 
;MyGeiger_NT.mbas,1525 :: 		sek_over       = 0
	BCF         _sek_over+0, BitPos(_sek_over+0) 
;MyGeiger_NT.mbas,1526 :: 		sek_counter    = 0
	CLRF        _sek_counter+0 
;MyGeiger_NT.mbas,1527 :: 		alert          = 0
	BCF         _alert+0, BitPos(_alert+0) 
;MyGeiger_NT.mbas,1528 :: 		counts         = 0
	CLRF        _counts+0 
	CLRF        _counts+1 
;MyGeiger_NT.mbas,1529 :: 		cpm            = 0
	CLRF        _cpm+0 
	CLRF        _cpm+1 
	CLRF        _cpm+2 
	CLRF        _cpm+3 
;MyGeiger_NT.mbas,1530 :: 		old_cpm        = 0
	CLRF        _old_cpm+0 
	CLRF        _old_cpm+1 
	CLRF        _old_cpm+2 
	CLRF        _old_cpm+3 
;MyGeiger_NT.mbas,1531 :: 		cpm_total      = 0
	CLRF        _cpm_total+0 
	CLRF        _cpm_total+1 
	CLRF        _cpm_total+2 
	CLRF        _cpm_total+3 
;MyGeiger_NT.mbas,1532 :: 		timer_cnt      = 0
	CLRF        _timer_cnt+0 
;MyGeiger_NT.mbas,1533 :: 		cpm_read_done  = 0
	BCF         _cpm_read_done+0, BitPos(_cpm_read_done+0) 
;MyGeiger_NT.mbas,1534 :: 		ALARM          = 10
	MOVLW       10
	MOVWF       _ALARM+0 
	MOVLW       0
	MOVWF       _ALARM+1 
;MyGeiger_NT.mbas,1535 :: 		n1             = 0
	CLRF        _n1+0 
;MyGeiger_NT.mbas,1536 :: 		graph_pos      = 0
	CLRF        _graph_pos+0 
;MyGeiger_NT.mbas,1537 :: 		display        = 0
	CLRF        _display+0 
;MyGeiger_NT.mbas,1538 :: 		button_check   = 0
	BCF         _button_check+0, BitPos(_button_check+0) 
;MyGeiger_NT.mbas,1539 :: 		b_count        = 0
	CLRF        _b_count+0 
;MyGeiger_NT.mbas,1540 :: 		buzzer_counter = 0
	CLRF        _buzzer_counter+0 
;MyGeiger_NT.mbas,1541 :: 		buzzer_started = 0
	BCF         _buzzer_started+0, BitPos(_buzzer_started+0) 
;MyGeiger_NT.mbas,1542 :: 		byte_low       = %00000000
	CLRF        _byte_low+0 
;MyGeiger_NT.mbas,1543 :: 		byte_high      = %00000000
	CLRF        _byte_high+0 
;MyGeiger_NT.mbas,1544 :: 		sekunds        = 0
	CLRF        _sekunds+0 
;MyGeiger_NT.mbas,1545 :: 		minutes        = 0
	CLRF        _minutes+0 
;MyGeiger_NT.mbas,1546 :: 		hours          = 0
	CLRF        _hours+0 
;MyGeiger_NT.mbas,1547 :: 		probe          = 0x00             ' no probe by default
	CLRF        _probe+0 
;MyGeiger_NT.mbas,1549 :: 		PORTE.3 = 0                       ' PORTE.3 detect 5V rail connected
	BCF         PORTE+0, 3 
;MyGeiger_NT.mbas,1550 :: 		TRISB      = %11100001
	MOVLW       225
	MOVWF       TRISB+0 
;MyGeiger_NT.mbas,1551 :: 		LATB       = %00000001
	MOVLW       1
	MOVWF       LATB+0 
;MyGeiger_NT.mbas,1552 :: 		TRISC      = %00110000
	MOVLW       48
	MOVWF       TRISC+0 
;MyGeiger_NT.mbas,1553 :: 		INTCON     = %00000000
	CLRF        INTCON+0 
;MyGeiger_NT.mbas,1554 :: 		USBEN_bit  = 0                    ' turn off USB module
	BCF         USBEN_bit+0, BitPos(USBEN_bit+0) 
;MyGeiger_NT.mbas,1555 :: 		UTRDIS_bit = 1
	BSF         UTRDIS_bit+0, BitPos(UTRDIS_bit+0) 
;MyGeiger_NT.mbas,1556 :: 		HLVDEN_bit = 0                    ' disable H/L voltage detect
	BCF         HLVDEN_bit+0, BitPos(HLVDEN_bit+0) 
;MyGeiger_NT.mbas,1559 :: 		TRISA.0 = 1                       ' BAT input
	BSF         TRISA+0, 0 
;MyGeiger_NT.mbas,1560 :: 		TRISA.1 = 1                       ' HV input
	BSF         TRISA+0, 1 
;MyGeiger_NT.mbas,1561 :: 		TRISA.2 = 0                       ' LIGHT output
	BCF         TRISA+0, 2 
;MyGeiger_NT.mbas,1562 :: 		TRISA.3 = 1                       ' VREF input
	BSF         TRISA+0, 3 
;MyGeiger_NT.mbas,1563 :: 		TRISA.5 = 0                       ' Podkachka output
	BCF         TRISA+0, 5 
;MyGeiger_NT.mbas,1565 :: 		smartBL    = EEPROM_Read (0x10)   ' smart backlight settings
	MOVLW       16
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _smartBL+0 
;MyGeiger_NT.mbas,1566 :: 		if smartBL = 0x01 then
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main612
;MyGeiger_NT.mbas,1567 :: 		LATA.2   = 1                      ' Turn on the light
	BSF         LATA+0, 2 
	GOTO        L__main613
;MyGeiger_NT.mbas,1568 :: 		else
L__main612:
;MyGeiger_NT.mbas,1569 :: 		LATA.2   = 0
	BCF         LATA+0, 2 
;MyGeiger_NT.mbas,1570 :: 		end if
L__main613:
;MyGeiger_NT.mbas,1572 :: 		LATC.2  = 0                       ' avoid current flow through MPSA44 before PWM
	BCF         LATC+0, 2 
;MyGeiger_NT.mbas,1573 :: 		LATA.5  = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,1576 :: 		ADCON1 = %00011101          ' Vref 1.21V AN3, Vref - VSS, RA0 RA1 analog inputs
	MOVLW       29
	MOVWF       ADCON1+0 
;MyGeiger_NT.mbas,1577 :: 		ADCON0 = %00000001          ' enable AD module, select RA0 channel
	MOVLW       1
	MOVWF       ADCON0+0 
;MyGeiger_NT.mbas,1578 :: 		CCP1IP_bit = 0  ' CCP1 low priority interrupt
	BCF         CCP1IP_bit+0, BitPos(CCP1IP_bit+0) 
;MyGeiger_NT.mbas,1580 :: 		if PORTC.4 = 0 then     ' check external probe DIP#2
	BTFSC       PORTC+0, 4 
	GOTO        L__main615
;MyGeiger_NT.mbas,1581 :: 		probe = 0x00
	CLRF        _probe+0 
;MyGeiger_NT.mbas,1582 :: 		if PORTC.5 = 0 then    ' check DIP#1 to set 400V or 500V range
	BTFSC       PORTC+0, 5 
	GOTO        L__main618
;MyGeiger_NT.mbas,1583 :: 		PR2        = %01111100      ' set PWM 4% 100uS pulse 500Hz for 400V tubes
	MOVLW       124
	MOVWF       PR2+0 
;MyGeiger_NT.mbas,1584 :: 		T2CON      = %00000111
	MOVLW       7
	MOVWF       T2CON+0 
;MyGeiger_NT.mbas,1585 :: 		CCPR1L     = %00000100      '%00000110
	MOVLW       4
	MOVWF       CCPR1L+0 
;MyGeiger_NT.mbas,1586 :: 		CCP1CON    = %00111100      '%00001100
	MOVLW       60
	MOVWF       CCP1CON+0 
;MyGeiger_NT.mbas,1587 :: 		p_one  = 190                ' set HV correction uder load   170
	MOVLW       190
	MOVWF       _p_one+0 
;MyGeiger_NT.mbas,1588 :: 		p_two  = 180                                                 '160
	MOVLW       180
	MOVWF       _p_two+0 
;MyGeiger_NT.mbas,1589 :: 		p_tree = 170                                                  '150
	MOVLW       170
	MOVWF       _p_tree+0 
;MyGeiger_NT.mbas,1590 :: 		p_four = 190
	MOVLW       190
	MOVWF       _p_four+0 
;MyGeiger_NT.mbas,1591 :: 		timer_byte = p_one
	MOVLW       190
	MOVWF       _timer_byte+0 
	GOTO        L__main619
;MyGeiger_NT.mbas,1592 :: 		else
L__main618:
;MyGeiger_NT.mbas,1593 :: 		PR2        = %01111100      ' set PWM 6% 500Hz  500V tubes
	MOVLW       124
	MOVWF       PR2+0 
;MyGeiger_NT.mbas,1594 :: 		T2CON      = %00000111
	MOVLW       7
	MOVWF       T2CON+0 
;MyGeiger_NT.mbas,1595 :: 		CCPR1L     = %00000111
	MOVLW       7
	MOVWF       CCPR1L+0 
;MyGeiger_NT.mbas,1596 :: 		CCP1CON    = %00011100
	MOVLW       28
	MOVWF       CCP1CON+0 
;MyGeiger_NT.mbas,1597 :: 		p_one  = 150
	MOVLW       150
	MOVWF       _p_one+0 
;MyGeiger_NT.mbas,1598 :: 		p_two  = 140
	MOVLW       140
	MOVWF       _p_two+0 
;MyGeiger_NT.mbas,1599 :: 		p_tree = 130
	MOVLW       130
	MOVWF       _p_tree+0 
;MyGeiger_NT.mbas,1600 :: 		p_four = 150
	MOVLW       150
	MOVWF       _p_four+0 
;MyGeiger_NT.mbas,1601 :: 		timer_byte = p_one
	MOVLW       150
	MOVWF       _timer_byte+0 
;MyGeiger_NT.mbas,1602 :: 		end if
L__main619:
L__main615:
;MyGeiger_NT.mbas,1604 :: 		if PORTC.4 = 1 then
	BTFSS       PORTC+0, 4 
	GOTO        L__main621
;MyGeiger_NT.mbas,1605 :: 		probe = 0x01
	MOVLW       1
	MOVWF       _probe+0 
;MyGeiger_NT.mbas,1606 :: 		p_one  = 190
	MOVLW       190
	MOVWF       _p_one+0 
;MyGeiger_NT.mbas,1607 :: 		p_two  = 180
	MOVLW       180
	MOVWF       _p_two+0 
;MyGeiger_NT.mbas,1608 :: 		p_tree = 170
	MOVLW       170
	MOVWF       _p_tree+0 
;MyGeiger_NT.mbas,1609 :: 		p_four = 190
	MOVLW       190
	MOVWF       _p_four+0 
;MyGeiger_NT.mbas,1610 :: 		timer_byte = p_one
	MOVLW       190
	MOVWF       _timer_byte+0 
L__main621:
;MyGeiger_NT.mbas,1614 :: 		CF         = EEPROM_Read (0x00)   ' sievert conversion factor
	CLRF        FARG_EEPROM_Read_address+0 
	CLRF        FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _CF+0 
;MyGeiger_NT.mbas,1615 :: 		vers       = EEPROM_Read (0x01)   ' firmware version, start with 10
	MOVLW       1
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _vers+0 
;MyGeiger_NT.mbas,1616 :: 		ALARM_L    = EEPROM_Read (0x02)   ' ALARM l
	MOVLW       2
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _ALARM_L+0 
;MyGeiger_NT.mbas,1617 :: 		ALARM_H    = EEPROM_Read (0x03)   ' ALARM h
	MOVLW       3
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _ALARM_H+0 
;MyGeiger_NT.mbas,1618 :: 		units      = EEPROM_Read (0x04)   ' display units
	MOVLW       4
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _units+0 
;MyGeiger_NT.mbas,1619 :: 		play_sound = EEPROM_Read (0x05)   ' sound on/off
	MOVLW       5
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _play_sound+0 
;MyGeiger_NT.mbas,1620 :: 		tube_square= EEPROM_Read (0x06)   ' tube square for bq
	MOVLW       6
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _tube_square+0 
;MyGeiger_NT.mbas,1621 :: 		BG         = EEPROM_Read (0x07)   ' tube normal background cpm for bq
	MOVLW       7
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _BG+0 
;MyGeiger_NT.mbas,1622 :: 		DL         = EEPROM_Read (0x08)   ' tube detection limit cpm for bq
	MOVLW       8
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _DL+0 
;MyGeiger_NT.mbas,1623 :: 		becquerel  = EEPROM_Read (0x09)   ' bq flag
	MOVLW       9
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _becquerel+0 
;MyGeiger_NT.mbas,1624 :: 		DT         = EEPROM_Read (0x0A)   ' dead time from eeprom
	MOVLW       10
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _DT+0 
;MyGeiger_NT.mbas,1627 :: 		LOW_BYTE   = EEPROM_Read (0x0C)   ' max cpm
	MOVLW       12
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _LOW_BYTE+0 
;MyGeiger_NT.mbas,1628 :: 		HI_BYTE    = EEPROM_Read (0x0D)
	MOVLW       13
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _HI_BYTE+0 
;MyGeiger_NT.mbas,1629 :: 		HG_BYTE    = EEPROM_Read (0x0E)
	MOVLW       14
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _HG_BYTE+0 
;MyGeiger_NT.mbas,1630 :: 		HS_BYTE    = EEPROM_Read (0x0F)
	MOVLW       15
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _HS_BYTE+0 
;MyGeiger_NT.mbas,1633 :: 		delitel            = tube_square * 6
	MOVF        _tube_square+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       6
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _delitel+0 
	MOVF        R1, 0 
	MOVWF       _delitel+1 
;MyGeiger_NT.mbas,1634 :: 		G_cpm_max          = BG
	MOVF        _BG+0, 0 
	MOVWF       _G_cpm_max+0 
	MOVLW       0
	MOVWF       _G_cpm_max+1 
	MOVWF       _G_cpm_max+2 
	MOVWF       _G_cpm_max+3 
;MyGeiger_NT.mbas,1635 :: 		Lo(cpm_max)        = LOW_BYTE
	MOVF        _LOW_BYTE+0, 0 
	MOVWF       _cpm_max+0 
;MyGeiger_NT.mbas,1636 :: 		Hi(cpm_max)        = HI_BYTE
	MOVF        _HI_BYTE+0, 0 
	MOVWF       _cpm_max+1 
;MyGeiger_NT.mbas,1637 :: 		Higher(cpm_max)    = HG_BYTE
	MOVF        _HG_BYTE+0, 0 
	MOVWF       _cpm_max+2 
;MyGeiger_NT.mbas,1638 :: 		Highest(cpm_max)   = HS_BYTE
	MOVF        _HS_BYTE+0, 0 
	MOVWF       _cpm_max+3 
;MyGeiger_NT.mbas,1640 :: 		dead_time          = DT
	MOVF        _DT+0, 0 
	MOVWF       _dead_time+0 
	MOVLW       0
	MOVWF       _dead_time+1 
;MyGeiger_NT.mbas,1641 :: 		c_factor  = dead_time / 1000000
	MOVF        _dead_time+0, 0 
	MOVWF       R0 
	MOVF        _dead_time+1, 0 
	MOVWF       R1 
	CALL        _Int2Double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       36
	MOVWF       R5 
	MOVLW       116
	MOVWF       R6 
	MOVLW       146
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _c_factor+0 
	MOVF        R1, 0 
	MOVWF       _c_factor+1 
	MOVF        R2, 0 
	MOVWF       _c_factor+2 
	MOVF        R3, 0 
	MOVWF       _c_factor+3 
;MyGeiger_NT.mbas,1642 :: 		c_factor  = c_factor / 60
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       112
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _c_factor+0 
	MOVF        R1, 0 
	MOVWF       _c_factor+1 
	MOVF        R2, 0 
	MOVWF       _c_factor+2 
	MOVF        R3, 0 
	MOVWF       _c_factor+3 
;MyGeiger_NT.mbas,1645 :: 		if play_sound = 0x00 then
	MOVF        _play_sound+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main624
;MyGeiger_NT.mbas,1646 :: 		sound = 0
	BCF         _sound+0, BitPos(_sound+0) 
	GOTO        L__main625
;MyGeiger_NT.mbas,1647 :: 		else
L__main624:
;MyGeiger_NT.mbas,1648 :: 		sound = 1
	BSF         _sound+0, BitPos(_sound+0) 
;MyGeiger_NT.mbas,1649 :: 		end if
L__main625:
;MyGeiger_NT.mbas,1652 :: 		ALARM = ALARM_L + ALARM_H*256
	MOVF        _ALARM_H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        _ALARM_L+0, 0 
	ADDWF       R0, 0 
	MOVWF       _ALARM+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       _ALARM+1 
;MyGeiger_NT.mbas,1653 :: 		CF2 = (CF * 1000)/877          ' Conversion constant from uSv to uRn
	MOVF        _CF+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       109
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _CF2+0 
	MOVF        R1, 0 
	MOVWF       _CF2+1 
	MOVF        R2, 0 
	MOVWF       _CF2+2 
	MOVF        R3, 0 
	MOVWF       _CF2+3 
;MyGeiger_NT.mbas,1656 :: 		Chip_Select = 1
	BSF         RB4_bit+0, BitPos(RB4_bit+0) 
;MyGeiger_NT.mbas,1657 :: 		Chip_Select_Direction = 0              ' Set CS# pin as Output
	BCF         TRISB4_bit+0, BitPos(TRISB4_bit+0) 
;MyGeiger_NT.mbas,1658 :: 		Soft_SPI_Init()
	CALL        _Soft_SPI_Init+0, 0
;MyGeiger_NT.mbas,1659 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__main626:
	DECFSZ      R13, 1, 1
	BRA         L__main626
	DECFSZ      R12, 1, 1
	BRA         L__main626
	NOP
	NOP
;MyGeiger_NT.mbas,1662 :: 		InitLCD()
	CALL        _InitLCD+0, 0
;MyGeiger_NT.mbas,1663 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__main627:
	DECFSZ      R13, 1, 1
	BRA         L__main627
	DECFSZ      R12, 1, 1
	BRA         L__main627
	NOP
	NOP
;MyGeiger_NT.mbas,1664 :: 		ClearLCD()
	CALL        _ClearLCD+0, 0
;MyGeiger_NT.mbas,1665 :: 		Display_Logo()
	CALL        _Display_Logo+0, 0
;MyGeiger_NT.mbas,1666 :: 		ByteToStr(vers, ver_disp)           ' firmware version display
	MOVF        _vers+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _ver_disp+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_ver_disp+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyGeiger_NT.mbas,1667 :: 		Text_LCD(55,7, ver_disp)
	MOVLW       55
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       _ver_disp+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(_ver_disp+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1668 :: 		Text_LCD(50,7, "2/")
	MOVLW       50
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       50
	MOVWF       ?LocalText_main+0 
	MOVLW       47
	MOVWF       ?LocalText_main+1 
	CLRF        ?LocalText_main+2 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1672 :: 		Soft_UART_Init(PORTB, 2, 1, 2400, 1)  '  sub procedure Soft_UART_Init(dim byref port as byte, dim rx_pin, tx_pin, baud_rate, inverted as byte)
	MOVLW       PORTB+0
	MOVWF       FARG_Soft_UART_Init_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Soft_UART_Init_port+1 
	MOVLW       2
	MOVWF       FARG_Soft_UART_Init_rx_pin+0 
	MOVLW       1
	MOVWF       FARG_Soft_UART_Init_tx_pin+0 
	MOVLW       96
	MOVWF       FARG_Soft_UART_Init_baud_rate+0 
	MOVLW       9
	MOVWF       FARG_Soft_UART_Init_baud_rate+1 
	MOVLW       0
	MOVWF       FARG_Soft_UART_Init_baud_rate+2 
	MOVWF       FARG_Soft_UART_Init_baud_rate+3 
	MOVLW       1
	MOVWF       FARG_Soft_UART_Init_inverted+0 
	CALL        _Soft_UART_Init+0, 0
;MyGeiger_NT.mbas,1673 :: 		delay_ms(2000)                        ' inverted data
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L__main628:
	DECFSZ      R13, 1, 1
	BRA         L__main628
	DECFSZ      R12, 1, 1
	BRA         L__main628
	DECFSZ      R11, 1, 1
	BRA         L__main628
	NOP
	NOP
;MyGeiger_NT.mbas,1677 :: 		signalization()
	CALL        _signalization+0, 0
;MyGeiger_NT.mbas,1680 :: 		parameters()
	CALL        _parameters+0, 0
;MyGeiger_NT.mbas,1684 :: 		counts = 0
	CLRF        _counts+0 
	CLRF        _counts+1 
;MyGeiger_NT.mbas,1685 :: 		cpm = 0
	CLRF        _cpm+0 
	CLRF        _cpm+1 
	CLRF        _cpm+2 
	CLRF        _cpm+3 
;MyGeiger_NT.mbas,1686 :: 		timer_cnt = 0
	CLRF        _timer_cnt+0 
;MyGeiger_NT.mbas,1687 :: 		cpm_read_done = 0
	BCF         _cpm_read_done+0, BitPos(_cpm_read_done+0) 
;MyGeiger_NT.mbas,1689 :: 		TMR1H = 0xE7                         ' First write higher byte to TMR1
	MOVLW       231
	MOVWF       TMR1H+0 
;MyGeiger_NT.mbas,1690 :: 		TMR1L = 0x96                         ' Write lower byte to TMR1
	MOVLW       150
	MOVWF       TMR1L+0 
;MyGeiger_NT.mbas,1691 :: 		T1CON = 0x35                         ' Timer1 prescaler settings
	MOVLW       53
	MOVWF       T1CON+0 
;MyGeiger_NT.mbas,1693 :: 		PIE1 = %00000001
	MOVLW       1
	MOVWF       PIE1+0 
;MyGeiger_NT.mbas,1694 :: 		TMR1IE_bit = 1                       ' Enable Timer1 overflow interrupt
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;MyGeiger_NT.mbas,1695 :: 		TMR1IF_bit = 0
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;MyGeiger_NT.mbas,1699 :: 		for xx = 0 to 11              ' 1 minute array                          '5
	CLRF        _xx+0 
L__main632:
;MyGeiger_NT.mbas,1700 :: 		CX[xx] = 0
	MOVF        _xx+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _CX+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_CX+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;MyGeiger_NT.mbas,1701 :: 		next xx
	MOVF        _xx+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__main635
	INCF        _xx+0, 1 
	GOTO        L__main632
L__main635:
;MyGeiger_NT.mbas,1703 :: 		for xx = 0 to 63            ' 5 minutes array for graph    29
	CLRF        _xx+0 
L__main637:
;MyGeiger_NT.mbas,1704 :: 		G_cpm[xx] = 0
	MOVF        _xx+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _G_cpm+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_G_cpm+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;MyGeiger_NT.mbas,1705 :: 		next xx
	MOVF        _xx+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L__main640
	INCF        _xx+0, 1 
	GOTO        L__main637
L__main640:
;MyGeiger_NT.mbas,1706 :: 		G_cpm_max = 0
	CLRF        _G_cpm_max+0 
	CLRF        _G_cpm_max+1 
	CLRF        _G_cpm_max+2 
	CLRF        _G_cpm_max+3 
;MyGeiger_NT.mbas,1709 :: 		if units = 0 then
	MOVF        _units+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main643
;MyGeiger_NT.mbas,1710 :: 		printSV()
	CALL        _printSV+0, 0
	GOTO        L__main644
;MyGeiger_NT.mbas,1711 :: 		else
L__main643:
;MyGeiger_NT.mbas,1712 :: 		printRN()
	CALL        _printRN+0, 0
;MyGeiger_NT.mbas,1713 :: 		end if
L__main644:
;MyGeiger_NT.mbas,1715 :: 		if sound = 1 then
	BTFSS       _sound+0, BitPos(_sound+0) 
	GOTO        L__main646
;MyGeiger_NT.mbas,1716 :: 		Text_LCD (97, 0, "(")
	MOVLW       97
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       40
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
L__main646:
;MyGeiger_NT.mbas,1719 :: 		if becquerel = 0x01 then
	MOVF        _becquerel+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main649
;MyGeiger_NT.mbas,1720 :: 		MyText_LCD(17,0,"Bq")
	MOVLW       17
	MOVWF       FARG_MyText_LCD_x+0 
	CLRF        FARG_MyText_LCD_y+0 
	MOVLW       66
	MOVWF       ?LocalText_main+0 
	MOVLW       113
	MOVWF       ?LocalText_main+1 
	CLRF        ?LocalText_main+2 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
L__main649:
;MyGeiger_NT.mbas,1727 :: 		PositionLCD (0, 7)
	CLRF        FARG_PositionLCD_x+0 
	MOVLW       7
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1728 :: 		for nn = 0 to 19
	CLRF        _nn+0 
	CLRF        _nn+1 
L__main652:
;MyGeiger_NT.mbas,1729 :: 		Soft_SPI_Write (cpm_label[nn])
	MOVLW       _cpm_label+0
	ADDWF       _nn+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_cpm_label+0)
	ADDWFC      _nn+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_cpm_label+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1730 :: 		next nn
	MOVLW       0
	XORWF       _nn+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main870
	MOVLW       19
	XORWF       _nn+0, 0 
L__main870:
	BTFSC       STATUS+0, 2 
	GOTO        L__main655
	INFSNZ      _nn+0, 1 
	INCF        _nn+1, 1 
	GOTO        L__main652
L__main655:
;MyGeiger_NT.mbas,1731 :: 		if probe = 0x00 then
	MOVF        _probe+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main657
;MyGeiger_NT.mbas,1732 :: 		Text_LCD (122, 0, "!")        '78
	MOVLW       122
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       33
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
	GOTO        L__main658
;MyGeiger_NT.mbas,1733 :: 		else
L__main657:
;MyGeiger_NT.mbas,1734 :: 		MyText_LCD(103,0, " XLR")                 '103
	MOVLW       103
	MOVWF       FARG_MyText_LCD_x+0 
	CLRF        FARG_MyText_LCD_y+0 
	MOVLW       32
	MOVWF       ?LocalText_main+0 
	MOVLW       88
	MOVWF       ?LocalText_main+1 
	MOVLW       76
	MOVWF       ?LocalText_main+2 
	MOVLW       82
	MOVWF       ?LocalText_main+3 
	CLRF        ?LocalText_main+4 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_MyText_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_MyText_LCD_sentance+1 
	CALL        _MyText_LCD+0, 0
;MyGeiger_NT.mbas,1739 :: 		end if
L__main658:
;MyGeiger_NT.mbas,1742 :: 		cpm_read_done = 0
	BCF         _cpm_read_done+0, BitPos(_cpm_read_done+0) 
;MyGeiger_NT.mbas,1743 :: 		counts = 0
	CLRF        _counts+0 
	CLRF        _counts+1 
;MyGeiger_NT.mbas,1744 :: 		xx   = 0
	CLRF        _xx+0 
;MyGeiger_NT.mbas,1745 :: 		G_xx = 0
	CLRF        _G_xx+0 
;MyGeiger_NT.mbas,1748 :: 		TMR3ON_bit = 0                        ' stop timer
	BCF         TMR3ON_bit+0, BitPos(TMR3ON_bit+0) 
;MyGeiger_NT.mbas,1749 :: 		TMR3CS_bit = 0                        ' internal clock
	BCF         TMR3CS_bit+0, BitPos(TMR3CS_bit+0) 
;MyGeiger_NT.mbas,1750 :: 		T3CKPS0_bit = 0                       ' prescaler 1:1
	BCF         T3CKPS0_bit+0, BitPos(T3CKPS0_bit+0) 
;MyGeiger_NT.mbas,1751 :: 		T3CKPS1_bit = 0
	BCF         T3CKPS1_bit+0, BitPos(T3CKPS1_bit+0) 
;MyGeiger_NT.mbas,1752 :: 		RD16_bit    = 0                       ' 8 bit write
	BCF         RD16_bit+0, BitPos(RD16_bit+0) 
;MyGeiger_NT.mbas,1753 :: 		TMR3IE_bit  = 1                       ' enable TMR3 overflow interrupt
	BSF         TMR3IE_bit+0, BitPos(TMR3IE_bit+0) 
;MyGeiger_NT.mbas,1754 :: 		TMR3IF_bit  = 0
	BCF         TMR3IF_bit+0, BitPos(TMR3IF_bit+0) 
;MyGeiger_NT.mbas,1755 :: 		TMR3L = 0x00
	CLRF        TMR3L+0 
;MyGeiger_NT.mbas,1756 :: 		TMR3H = 0x00
	CLRF        TMR3H+0 
;MyGeiger_NT.mbas,1758 :: 		T0CON = %01001000                ' 8 bit timer 0
	MOVLW       72
	MOVWF       T0CON+0 
;MyGeiger_NT.mbas,1759 :: 		TMR0L      = timer_byte                                 '
	MOVF        _timer_byte+0, 0 
	MOVWF       TMR0L+0 
;MyGeiger_NT.mbas,1760 :: 		TMR0IE_bit = 1
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;MyGeiger_NT.mbas,1761 :: 		TMR0IF_bit = 0
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyGeiger_NT.mbas,1763 :: 		IPEN_bit   = 1                        ' enable interrupt priority
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;MyGeiger_NT.mbas,1764 :: 		TMR2IP_bit  = 0                       ' TMR2 low priority interrupt
	BCF         TMR2IP_bit+0, BitPos(TMR2IP_bit+0) 
;MyGeiger_NT.mbas,1765 :: 		TMR1IP_bit  = 1                       ' TMR1 high priority interrupt
	BSF         TMR1IP_bit+0, BitPos(TMR1IP_bit+0) 
;MyGeiger_NT.mbas,1766 :: 		TMR0IP_bit  = 1                       ' TMR0 high priority interrupt
	BSF         TMR0IP_bit+0, BitPos(TMR0IP_bit+0) 
;MyGeiger_NT.mbas,1767 :: 		RBPU_bit    = 1                       ' disable pull ups on RB port
	BSF         RBPU_bit+0, BitPos(RBPU_bit+0) 
;MyGeiger_NT.mbas,1769 :: 		INTCON = %11110000
	MOVLW       240
	MOVWF       INTCON+0 
;MyGeiger_NT.mbas,1770 :: 		INTEDG0_bit = 0                       ' Interrupt on RB0/INT pin is edge triggered, setting it on low edge
	BCF         INTEDG0_bit+0, BitPos(INTEDG0_bit+0) 
;MyGeiger_NT.mbas,1773 :: 		while(1)
L__main660:
;MyGeiger_NT.mbas,1775 :: 		if button_check = 1 then
	BTFSS       _button_check+0, BitPos(_button_check+0) 
	GOTO        L__main665
;MyGeiger_NT.mbas,1776 :: 		if alert = 0 then
	BTFSC       _alert+0, BitPos(_alert+0) 
	GOTO        L__main668
;MyGeiger_NT.mbas,1777 :: 		LATB.7  = 0             ' turn off alert on portb.7 and wait for button
	BCF         LATB+0, 7 
;MyGeiger_NT.mbas,1778 :: 		TRISB.7 = 1             ' input
	BSF         TRISB+0, 7 
;MyGeiger_NT.mbas,1779 :: 		if Button (PORTB, 7, 100, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       7
	MOVWF       FARG_Button_pin+0 
	MOVLW       100
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__main671
;MyGeiger_NT.mbas,1781 :: 		sound = not sound
	BTG         _sound+0, BitPos(_sound+0) 
;MyGeiger_NT.mbas,1782 :: 		if sound = 1 then
	BTFSS       _sound+0, BitPos(_sound+0) 
	GOTO        L__main674
;MyGeiger_NT.mbas,1783 :: 		play_sound = 0x01
	MOVLW       1
	MOVWF       _play_sound+0 
;MyGeiger_NT.mbas,1784 :: 		Text_LCD (97, 0, "(")
	MOVLW       97
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       40
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
	GOTO        L__main675
;MyGeiger_NT.mbas,1785 :: 		else
L__main674:
;MyGeiger_NT.mbas,1786 :: 		play_sound = 0x00
	CLRF        _play_sound+0 
;MyGeiger_NT.mbas,1787 :: 		Text_LCD (97, 0, " ")
	MOVLW       97
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       32
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1788 :: 		end if
L__main675:
;MyGeiger_NT.mbas,1789 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__main676:
	DECFSZ      R13, 1, 1
	BRA         L__main676
	DECFSZ      R12, 1, 1
	BRA         L__main676
	NOP
	NOP
;MyGeiger_NT.mbas,1790 :: 		EEPROM_Write(0x05, play_sound)
	MOVLW       5
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _play_sound+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
L__main671:
;MyGeiger_NT.mbas,1791 :: 		end if
L__main668:
;MyGeiger_NT.mbas,1794 :: 		if Button (PORTB, 5, 100, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       5
	MOVWF       FARG_Button_pin+0 
	MOVLW       100
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__main678
;MyGeiger_NT.mbas,1795 :: 		if smartBL = 0x01 then
	MOVF        _smartBL+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main681
;MyGeiger_NT.mbas,1796 :: 		LATA.2   = 1 ' light
	BSF         LATA+0, 2 
	GOTO        L__main682
;MyGeiger_NT.mbas,1797 :: 		else
L__main681:
;MyGeiger_NT.mbas,1798 :: 		LATA.2 = not LATA.2
	BTG         LATA+0, 2 
;MyGeiger_NT.mbas,1799 :: 		end if
L__main682:
L__main678:
;MyGeiger_NT.mbas,1816 :: 		if Button (PORTB, 6, 100, 1) then
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       6
	MOVWF       FARG_Button_pin+0 
	MOVLW       100
	MOVWF       FARG_Button_time+0 
	MOVLW       1
	MOVWF       FARG_Button_activeState+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__main684
;MyGeiger_NT.mbas,1817 :: 		delay_ms(1000)
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L__main686:
	DECFSZ      R13, 1, 1
	BRA         L__main686
	DECFSZ      R12, 1, 1
	BRA         L__main686
	DECFSZ      R11, 1, 1
	BRA         L__main686
	NOP
	NOP
;MyGeiger_NT.mbas,1818 :: 		if PORTB.6 = 1 then
	BTFSS       PORTB+0, 6 
	GOTO        L__main688
;MyGeiger_NT.mbas,1819 :: 		calibration()
	CALL        _calibration+0, 0
	GOTO        L__main689
;MyGeiger_NT.mbas,1820 :: 		else
L__main688:
;MyGeiger_NT.mbas,1821 :: 		units = 1 - units
	MOVF        _units+0, 0 
	SUBLW       1
	MOVWF       _units+0 
;MyGeiger_NT.mbas,1822 :: 		EEPROM_Write (0x04, units)
	MOVLW       4
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _units+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1823 :: 		Text_LCD(0, 1, "              ")
	CLRF        FARG_Text_LCD_x+0 
	MOVLW       1
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       32
	MOVWF       ?LocalText_main+0 
	MOVLW       32
	MOVWF       ?LocalText_main+1 
	MOVLW       32
	MOVWF       ?LocalText_main+2 
	MOVLW       32
	MOVWF       ?LocalText_main+3 
	MOVLW       32
	MOVWF       ?LocalText_main+4 
	MOVLW       32
	MOVWF       ?LocalText_main+5 
	MOVLW       32
	MOVWF       ?LocalText_main+6 
	MOVLW       32
	MOVWF       ?LocalText_main+7 
	MOVLW       32
	MOVWF       ?LocalText_main+8 
	MOVLW       32
	MOVWF       ?LocalText_main+9 
	MOVLW       32
	MOVWF       ?LocalText_main+10 
	MOVLW       32
	MOVWF       ?LocalText_main+11 
	MOVLW       32
	MOVWF       ?LocalText_main+12 
	MOVLW       32
	MOVWF       ?LocalText_main+13 
	CLRF        ?LocalText_main+14 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1824 :: 		Text_LCD(0, 2, "              ")
	CLRF        FARG_Text_LCD_x+0 
	MOVLW       2
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       32
	MOVWF       ?LocalText_main+0 
	MOVLW       32
	MOVWF       ?LocalText_main+1 
	MOVLW       32
	MOVWF       ?LocalText_main+2 
	MOVLW       32
	MOVWF       ?LocalText_main+3 
	MOVLW       32
	MOVWF       ?LocalText_main+4 
	MOVLW       32
	MOVWF       ?LocalText_main+5 
	MOVLW       32
	MOVWF       ?LocalText_main+6 
	MOVLW       32
	MOVWF       ?LocalText_main+7 
	MOVLW       32
	MOVWF       ?LocalText_main+8 
	MOVLW       32
	MOVWF       ?LocalText_main+9 
	MOVLW       32
	MOVWF       ?LocalText_main+10 
	MOVLW       32
	MOVWF       ?LocalText_main+11 
	MOVLW       32
	MOVWF       ?LocalText_main+12 
	MOVLW       32
	MOVWF       ?LocalText_main+13 
	CLRF        ?LocalText_main+14 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1825 :: 		if units = 0 then
	MOVF        _units+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main691
;MyGeiger_NT.mbas,1826 :: 		printSV()
	CALL        _printSV+0, 0
	GOTO        L__main692
;MyGeiger_NT.mbas,1827 :: 		else
L__main691:
;MyGeiger_NT.mbas,1828 :: 		printRN()
	CALL        _printRN+0, 0
;MyGeiger_NT.mbas,1829 :: 		end if
L__main692:
;MyGeiger_NT.mbas,1830 :: 		end if
L__main689:
L__main684:
;MyGeiger_NT.mbas,1835 :: 		button_check = 0
	BCF         _button_check+0, BitPos(_button_check+0) 
L__main665:
;MyGeiger_NT.mbas,1839 :: 		if sek_over = 1 then
	BTFSS       _sek_over+0, BitPos(_sek_over+0) 
	GOTO        L__main694
;MyGeiger_NT.mbas,1840 :: 		TMR1IE_bit = 0
	BCF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;MyGeiger_NT.mbas,1841 :: 		LATA.5  = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,1843 :: 		if probe = 0x00 then                  ' measure HV if no probe connected
	MOVF        _probe+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main697
;MyGeiger_NT.mbas,1844 :: 		adc_rd = ADC_Read(1)              ' read HV
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _adc_rd+0 
	MOVF        R1, 0 
	MOVWF       _adc_rd+1 
;MyGeiger_NT.mbas,1845 :: 		tlong = adc_rd * 1.21             '1.21 for 1.25V ; 2.44 for 2.5V
	CALL        _Int2Double+0, 0
	MOVLW       72
	MOVWF       R4 
	MOVLW       225
	MOVWF       R5 
	MOVLW       26
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _Double2Int+0, 0
	MOVF        R0, 0 
	MOVWF       _tlong+0 
	MOVF        R1, 0 
	MOVWF       _tlong+1 
;MyGeiger_NT.mbas,1846 :: 		IntToStr (tlong, Dispv)
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _DispV+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_DispV+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;MyGeiger_NT.mbas,1847 :: 		ltrim (Dispv)
	MOVLW       _DispV+0
	MOVWF       FARG_ltrim_astring+0 
	MOVLW       hi_addr(_DispV+0)
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,1848 :: 		Text_LCD (104, 0, Dispv)
	MOVLW       104
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       _DispV+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(_DispV+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,1850 :: 		if sek_cnt <= 31 then
	MOVLW       0
	MOVWF       R0 
	MOVF        _sek_cnt+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main871
	MOVF        _sek_cnt+0, 0 
	SUBLW       31
L__main871:
	BTFSS       STATUS+0, 0 
	GOTO        L__main700
;MyGeiger_NT.mbas,1851 :: 		timer_byte = p_one
	MOVF        _p_one+0, 0 
	MOVWF       _timer_byte+0 
	GOTO        L__main701
;MyGeiger_NT.mbas,1852 :: 		else
L__main700:
;MyGeiger_NT.mbas,1853 :: 		timer_byte = p_two
	MOVF        _p_two+0, 0 
	MOVWF       _timer_byte+0 
;MyGeiger_NT.mbas,1854 :: 		end if
L__main701:
;MyGeiger_NT.mbas,1856 :: 		if sek_cnt >= 800 then
	MOVLW       3
	SUBWF       _sek_cnt+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main872
	MOVLW       32
	SUBWF       _sek_cnt+0, 0 
L__main872:
	BTFSS       STATUS+0, 0 
	GOTO        L__main703
;MyGeiger_NT.mbas,1857 :: 		timer_byte = p_tree
	MOVF        _p_tree+0, 0 
	MOVWF       _timer_byte+0 
L__main703:
;MyGeiger_NT.mbas,1860 :: 		if sek_cnt >=4000 then             ' 4200 control of podka4ka not to overdrive the HV!!
	MOVLW       15
	SUBWF       _sek_cnt+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main873
	MOVLW       160
	SUBWF       _sek_cnt+0, 0 
L__main873:
	BTFSS       STATUS+0, 0 
	GOTO        L__main706
;MyGeiger_NT.mbas,1861 :: 		timer_byte = p_four               ' reduce podka4ka to the minimum when CPM>250000
	MOVF        _p_four+0, 0 
	MOVWF       _timer_byte+0 
L__main706:
;MyGeiger_NT.mbas,1862 :: 		end if
L__main697:
;MyGeiger_NT.mbas,1865 :: 		PositionLCD (90,2)                  ' PositionLCD (25,3)
	MOVLW       90
	MOVWF       FARG_PositionLCD_x+0 
	MOVLW       2
	MOVWF       FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,1866 :: 		if sek_cnt > ALARM then
	MOVF        _sek_cnt+1, 0 
	SUBWF       _ALARM+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main874
	MOVF        _sek_cnt+0, 0 
	SUBWF       _ALARM+0, 0 
L__main874:
	BTFSC       STATUS+0, 0 
	GOTO        L__main709
;MyGeiger_NT.mbas,1868 :: 		if smartBL=0x01 then
	MOVF        _smartBL+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main712
;MyGeiger_NT.mbas,1869 :: 		LATA.2   = 1 ' light
	BSF         LATA+0, 2 
L__main712:
;MyGeiger_NT.mbas,1871 :: 		alert = 1
	BSF         _alert+0, BitPos(_alert+0) 
;MyGeiger_NT.mbas,1872 :: 		TRISB.7 = 0          ' portb.7 output again
	BCF         TRISB+0, 7 
;MyGeiger_NT.mbas,1873 :: 		LATB.7  = 1          ' turn alert on
	BSF         LATB+0, 7 
;MyGeiger_NT.mbas,1874 :: 		for hh = 0 to 34
	CLRF        _hh+0 
L__main715:
;MyGeiger_NT.mbas,1875 :: 		Soft_SPI_Write(message2[hh])
	MOVLW       _message2+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_message2+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_message2+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1876 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       34
	BTFSC       STATUS+0, 2 
	GOTO        L__main718
	INCF        _hh+0, 1 
	GOTO        L__main715
L__main718:
	GOTO        L__main710
;MyGeiger_NT.mbas,1880 :: 		else
L__main709:
;MyGeiger_NT.mbas,1881 :: 		alert = 0
	BCF         _alert+0, BitPos(_alert+0) 
;MyGeiger_NT.mbas,1883 :: 		for hh = 0 to 34
	CLRF        _hh+0 
L__main720:
;MyGeiger_NT.mbas,1884 :: 		Soft_SPI_Write(message1[hh])
	MOVLW       _message1+0
	ADDWF       _hh+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_message1+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_message1+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,1885 :: 		next hh
	MOVF        _hh+0, 0 
	XORLW       34
	BTFSC       STATUS+0, 2 
	GOTO        L__main723
	INCF        _hh+0, 1 
	GOTO        L__main720
L__main723:
;MyGeiger_NT.mbas,1886 :: 		end if
L__main710:
;MyGeiger_NT.mbas,1889 :: 		sek_over = 0
	BCF         _sek_over+0, BitPos(_sek_over+0) 
;MyGeiger_NT.mbas,1890 :: 		INT0IE_bit = 1
	BSF         INT0IE_bit+0, BitPos(INT0IE_bit+0) 
;MyGeiger_NT.mbas,1891 :: 		TMR1IE_bit = 1
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
L__main694:
;MyGeiger_NT.mbas,1896 :: 		if cpm_read_done = 1 then           ' When interrupt occur
	BTFSS       _cpm_read_done+0, BitPos(_cpm_read_done+0) 
	GOTO        L__main725
;MyGeiger_NT.mbas,1898 :: 		TMR1IE_bit = 0
	BCF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;MyGeiger_NT.mbas,1899 :: 		LATA.5  = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,1901 :: 		if n1 = 0 then                   'jjjjj
	MOVF        _n1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main728
;MyGeiger_NT.mbas,1902 :: 		LATA.5  = 1                  ' podkachaem HV a vdrug u nas pizdec
	BSF         LATA+0, 5 
;MyGeiger_NT.mbas,1903 :: 		delay_us(500)
	MOVLW       166
	MOVWF       R13, 0
L__main730:
	DECFSZ      R13, 1, 1
	BRA         L__main730
	NOP
;MyGeiger_NT.mbas,1904 :: 		LATA.5  = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,1905 :: 		delay_us(500)
	MOVLW       166
	MOVWF       R13, 0
L__main731:
	DECFSZ      R13, 1, 1
	BRA         L__main731
	NOP
;MyGeiger_NT.mbas,1906 :: 		LATA.5  = 1
	BSF         LATA+0, 5 
;MyGeiger_NT.mbas,1907 :: 		delay_us(500)
	MOVLW       166
	MOVWF       R13, 0
L__main732:
	DECFSZ      R13, 1, 1
	BRA         L__main732
	NOP
;MyGeiger_NT.mbas,1908 :: 		LATA.5  = 0
	BCF         LATA+0, 5 
;MyGeiger_NT.mbas,1909 :: 		n1 = 1
	MOVLW       1
	MOVWF       _n1+0 
;MyGeiger_NT.mbas,1910 :: 		m_period = 99
	MOVLW       99
	MOVWF       _m_period+0 
;MyGeiger_NT.mbas,1912 :: 		cpm = sek_cnt
	MOVF        _sek_cnt+0, 0 
	MOVWF       _cpm+0 
	MOVF        _sek_cnt+1, 0 
	MOVWF       _cpm+1 
	MOVLW       0
	MOVWF       _cpm+2 
	MOVWF       _cpm+3 
;MyGeiger_NT.mbas,1916 :: 		goto DD
	GOTO        L__main_dd
;MyGeiger_NT.mbas,1917 :: 		else
L__main728:
;MyGeiger_NT.mbas,1919 :: 		CX[xx]      = counts
	MOVF        _xx+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _CX+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_CX+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _counts+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _counts+1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
;MyGeiger_NT.mbas,1920 :: 		cpm_total   = cpm_total + counts
	MOVF        _counts+0, 0 
	ADDWF       _cpm_total+0, 0 
	MOVWF       R1 
	MOVF        _counts+1, 0 
	ADDWFC      _cpm_total+1, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      _cpm_total+2, 0 
	MOVWF       R3 
	MOVLW       0
	ADDWFC      _cpm_total+3, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       _cpm_total+0 
	MOVF        R2, 0 
	MOVWF       _cpm_total+1 
	MOVF        R3, 0 
	MOVWF       _cpm_total+2 
	MOVF        R4, 0 
	MOVWF       _cpm_total+3 
;MyGeiger_NT.mbas,1921 :: 		if cpm_total>23000000 then     ' limit max absorbed cpm for One session
	MOVF        R4, 0 
	SUBLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main875
	MOVF        R3, 0 
	SUBLW       94
	BTFSS       STATUS+0, 2 
	GOTO        L__main875
	MOVF        R2, 0 
	SUBLW       243
	BTFSS       STATUS+0, 2 
	GOTO        L__main875
	MOVF        R1, 0 
	SUBLW       192
L__main875:
	BTFSC       STATUS+0, 0 
	GOTO        L__main735
;MyGeiger_NT.mbas,1922 :: 		cpm_total = 23000000
	MOVLW       192
	MOVWF       _cpm_total+0 
	MOVLW       243
	MOVWF       _cpm_total+1 
	MOVLW       94
	MOVWF       _cpm_total+2 
	MOVLW       1
	MOVWF       _cpm_total+3 
L__main735:
;MyGeiger_NT.mbas,1925 :: 		xx = xx + 1
	INCF        _xx+0, 1 
;MyGeiger_NT.mbas,1926 :: 		if xx>11 then
	MOVF        _xx+0, 0 
	SUBLW       11
	BTFSC       STATUS+0, 0 
	GOTO        L__main738
;MyGeiger_NT.mbas,1927 :: 		xx=0
	CLRF        _xx+0 
L__main738:
;MyGeiger_NT.mbas,1930 :: 		old_cpm = cpm
	MOVF        _cpm+0, 0 
	MOVWF       _old_cpm+0 
	MOVF        _cpm+1, 0 
	MOVWF       _old_cpm+1 
	MOVF        _cpm+2, 0 
	MOVWF       _old_cpm+2 
	MOVF        _cpm+3, 0 
	MOVWF       _old_cpm+3 
;MyGeiger_NT.mbas,1931 :: 		cpm = CX[0] + CX[1] + CX[2] + CX[3] + CX[4] + CX[5] +  CX[6] + CX[7] + CX[8] + CX[9] + CX[10] + CX[11]
	MOVF        _CX+4, 0 
	ADDWF       _CX+0, 0 
	MOVWF       R0 
	MOVF        _CX+5, 0 
	ADDWFC      _CX+1, 0 
	MOVWF       R1 
	MOVF        _CX+6, 0 
	ADDWFC      _CX+2, 0 
	MOVWF       R2 
	MOVF        _CX+7, 0 
	ADDWFC      _CX+3, 0 
	MOVWF       R3 
	MOVF        _CX+8, 0 
	ADDWF       R0, 1 
	MOVF        _CX+9, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+10, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+11, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+12, 0 
	ADDWF       R0, 1 
	MOVF        _CX+13, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+14, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+15, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+16, 0 
	ADDWF       R0, 1 
	MOVF        _CX+17, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+18, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+19, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+20, 0 
	ADDWF       R0, 1 
	MOVF        _CX+21, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+22, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+23, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+24, 0 
	ADDWF       R0, 1 
	MOVF        _CX+25, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+26, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+27, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+28, 0 
	ADDWF       R0, 1 
	MOVF        _CX+29, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+30, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+31, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+32, 0 
	ADDWF       R0, 1 
	MOVF        _CX+33, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+34, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+35, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+36, 0 
	ADDWF       R0, 1 
	MOVF        _CX+37, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+38, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+39, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+40, 0 
	ADDWF       R0, 1 
	MOVF        _CX+41, 0 
	ADDWFC      R1, 1 
	MOVF        _CX+42, 0 
	ADDWFC      R2, 1 
	MOVF        _CX+43, 0 
	ADDWFC      R3, 1 
	MOVF        _CX+44, 0 
	ADDWF       R0, 0 
	MOVWF       R4 
	MOVF        _CX+45, 0 
	ADDWFC      R1, 0 
	MOVWF       R5 
	MOVF        _CX+46, 0 
	ADDWFC      R2, 0 
	MOVWF       R6 
	MOVF        _CX+47, 0 
	ADDWFC      R3, 0 
	MOVWF       R7 
	MOVF        R4, 0 
	MOVWF       _cpm+0 
	MOVF        R5, 0 
	MOVWF       _cpm+1 
	MOVF        R6, 0 
	MOVWF       _cpm+2 
	MOVF        R7, 0 
	MOVWF       _cpm+3 
;MyGeiger_NT.mbas,1934 :: 		if old_cpm >= cpm then
	MOVF        R7, 0 
	SUBWF       _old_cpm+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main876
	MOVF        R6, 0 
	SUBWF       _old_cpm+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main876
	MOVF        R5, 0 
	SUBWF       _old_cpm+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main876
	MOVF        R4, 0 
	SUBWF       _old_cpm+0, 0 
L__main876:
	BTFSS       STATUS+0, 0 
	GOTO        L__main741
;MyGeiger_NT.mbas,1935 :: 		parid_cpm = old_cpm - cpm
	MOVF        _cpm+0, 0 
	SUBWF       _old_cpm+0, 0 
	MOVWF       _parid_cpm+0 
	MOVF        _cpm+1, 0 
	SUBWFB      _old_cpm+1, 0 
	MOVWF       _parid_cpm+1 
	GOTO        L__main742
;MyGeiger_NT.mbas,1936 :: 		else
L__main741:
;MyGeiger_NT.mbas,1937 :: 		parid_cpm = cpm - old_cpm
	MOVF        _old_cpm+0, 0 
	SUBWF       _cpm+0, 0 
	MOVWF       _parid_cpm+0 
	MOVF        _old_cpm+1, 0 
	SUBWFB      _cpm+1, 0 
	MOVWF       _parid_cpm+1 
;MyGeiger_NT.mbas,1938 :: 		end if
L__main742:
;MyGeiger_NT.mbas,1940 :: 		if parid_cpm >=50 then
	MOVLW       0
	SUBWF       _parid_cpm+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main877
	MOVLW       50
	SUBWF       _parid_cpm+0, 0 
L__main877:
	BTFSS       STATUS+0, 0 
	GOTO        L__main744
;MyGeiger_NT.mbas,1941 :: 		cpm = counts * 12                    '6
	MOVF        _counts+0, 0 
	MOVWF       R0 
	MOVF        _counts+1, 0 
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       12
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _cpm+0 
	MOVF        R1, 0 
	MOVWF       _cpm+1 
	MOVF        R2, 0 
	MOVWF       _cpm+2 
	MOVF        R3, 0 
	MOVWF       _cpm+3 
;MyGeiger_NT.mbas,1942 :: 		for xx = 0 to 11
	CLRF        _xx+0 
L__main747:
;MyGeiger_NT.mbas,1943 :: 		CX[xx] = counts
	MOVF        _xx+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _CX+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_CX+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _counts+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _counts+1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
;MyGeiger_NT.mbas,1944 :: 		next xx
	MOVF        _xx+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__main750
	INCF        _xx+0, 1 
	GOTO        L__main747
L__main750:
;MyGeiger_NT.mbas,1945 :: 		xx = 0
	CLRF        _xx+0 
L__main744:
;MyGeiger_NT.mbas,1949 :: 		if cpm > cpm_max then        ' safe max cpm to eeprom if need
	MOVF        _cpm+3, 0 
	SUBWF       _cpm_max+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main878
	MOVF        _cpm+2, 0 
	SUBWF       _cpm_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main878
	MOVF        _cpm+1, 0 
	SUBWF       _cpm_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main878
	MOVF        _cpm+0, 0 
	SUBWF       _cpm_max+0, 0 
L__main878:
	BTFSC       STATUS+0, 0 
	GOTO        L__main752
;MyGeiger_NT.mbas,1950 :: 		cpm_max = cpm
	MOVF        _cpm+0, 0 
	MOVWF       _cpm_max+0 
	MOVF        _cpm+1, 0 
	MOVWF       _cpm_max+1 
	MOVF        _cpm+2, 0 
	MOVWF       _cpm_max+2 
	MOVF        _cpm+3, 0 
	MOVWF       _cpm_max+3 
;MyGeiger_NT.mbas,1951 :: 		EEPROM_Write(0x0C, Lo(cpm))
	MOVLW       12
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _cpm+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1952 :: 		EEPROM_Write(0x0D, Hi(cpm))
	MOVLW       13
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _cpm+1, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1953 :: 		EEPROM_Write(0x0E, Higher(cpm))
	MOVLW       14
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _cpm+2, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyGeiger_NT.mbas,1954 :: 		EEPROM_Write(0x0F, Highest(cpm))
	MOVLW       15
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _cpm+3, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
L__main752:
;MyGeiger_NT.mbas,1959 :: 		DD:
L__main_dd:
;MyGeiger_NT.mbas,1964 :: 		G_cpm_max   = cpm                  '
	MOVF        _cpm+0, 0 
	MOVWF       _G_cpm_max+0 
	MOVF        _cpm+1, 0 
	MOVWF       _G_cpm_max+1 
	MOVF        _cpm+2, 0 
	MOVWF       _G_cpm_max+2 
	MOVF        _cpm+3, 0 
	MOVWF       _G_cpm_max+3 
;MyGeiger_NT.mbas,1965 :: 		for G_xx=0 to 62
	CLRF        _G_xx+0 
L__main755:
;MyGeiger_NT.mbas,1966 :: 		G_cpm[G_xx] = G_cpm[G_xx+1]
	MOVF        _G_xx+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _G_cpm+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_G_cpm+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _G_xx+0, 0 
	ADDLW       1
	MOVWF       R3 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _G_cpm+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_G_cpm+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;MyGeiger_NT.mbas,1967 :: 		if G_cpm[G_xx] >= G_cpm_max then
	MOVF        _G_xx+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _G_cpm+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_G_cpm+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        _G_cpm_max+3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main879
	MOVF        _G_cpm_max+2, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main879
	MOVF        _G_cpm_max+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main879
	MOVF        _G_cpm_max+0, 0 
	SUBWF       R1, 0 
L__main879:
	BTFSS       STATUS+0, 0 
	GOTO        L__main760
;MyGeiger_NT.mbas,1968 :: 		G_cpm_max = G_cpm[G_xx]
	MOVF        _G_xx+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _G_cpm+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_G_cpm+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _G_cpm_max+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _G_cpm_max+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       _G_cpm_max+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       _G_cpm_max+3 
L__main760:
;MyGeiger_NT.mbas,1970 :: 		next G_xx
	MOVF        _G_xx+0, 0 
	XORLW       62
	BTFSC       STATUS+0, 2 
	GOTO        L__main758
	INCF        _G_xx+0, 1 
	GOTO        L__main755
L__main758:
;MyGeiger_NT.mbas,1971 :: 		G_cpm[63] = cpm
	MOVF        _cpm+0, 0 
	MOVWF       _G_cpm+252 
	MOVF        _cpm+1, 0 
	MOVWF       _G_cpm+253 
	MOVF        _cpm+2, 0 
	MOVWF       _G_cpm+254 
	MOVF        _cpm+3, 0 
	MOVWF       _G_cpm+255 
;MyGeiger_NT.mbas,1972 :: 		stolbik()
	CALL        _stolbik+0, 0
;MyGeiger_NT.mbas,1974 :: 		LongWordToStr (cpm, CPM_Display)
	MOVF        _cpm+0, 0 
	MOVWF       FARG_LongWordToStr_input+0 
	MOVF        _cpm+1, 0 
	MOVWF       FARG_LongWordToStr_input+1 
	MOVF        _cpm+2, 0 
	MOVWF       FARG_LongWordToStr_input+2 
	MOVF        _cpm+3, 0 
	MOVWF       FARG_LongWordToStr_input+3 
	MOVLW       _CPM_Display+0
	MOVWF       FARG_LongWordToStr_output+0 
	MOVLW       hi_addr(_CPM_Display+0)
	MOVWF       FARG_LongWordToStr_output+1 
	CALL        _LongWordToStr+0, 0
;MyGeiger_NT.mbas,1975 :: 		ltrim (CPM_Display)
	MOVLW       _CPM_Display+0
	MOVWF       FARG_ltrim_astring+0 
	MOVLW       hi_addr(_CPM_Display+0)
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,1976 :: 		sendcpm (CPM_Display)
	MOVLW       _CPM_Display+0
	MOVWF       FARG_sendcpm_cpms+0 
	MOVLW       hi_addr(_CPM_Display+0)
	MOVWF       FARG_sendcpm_cpms+1 
	CALL        _sendcpm+0, 0
;MyGeiger_NT.mbas,1978 :: 		if becquerel = 0x01 then         ' send Bq to uart
	MOVF        _becquerel+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main763
;MyGeiger_NT.mbas,1979 :: 		if cpm > BG+DL then
	MOVF        _DL+0, 0 
	ADDWF       _BG+0, 0 
	MOVWF       R1 
	MOVF        _cpm+3, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main880
	MOVF        _cpm+2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main880
	MOVF        _cpm+1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main880
	MOVF        _cpm+0, 0 
	SUBWF       R1, 0 
L__main880:
	BTFSC       STATUS+0, 0 
	GOTO        L__main766
;MyGeiger_NT.mbas,1980 :: 		dose_Bq     = (cpm - BG) / delitel
	MOVF        _cpm+0, 0 
	MOVWF       R0 
	MOVF        _cpm+1, 0 
	MOVWF       R1 
	MOVF        _cpm+2, 0 
	MOVWF       R2 
	MOVF        _cpm+3, 0 
	MOVWF       R3 
	CALL        _Longword2Double+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVF        _BG+0, 0 
	MOVWF       R0 
	CALL        _Byte2Double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	MOVF        FLOC__main+2, 0 
	MOVWF       R2 
	MOVF        FLOC__main+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVF        _delitel+0, 0 
	MOVWF       R0 
	MOVF        _delitel+1, 0 
	MOVWF       R1 
	CALL        _Word2Double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	MOVF        FLOC__main+2, 0 
	MOVWF       R2 
	MOVF        FLOC__main+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _dose_Bq+0 
	MOVF        R1, 0 
	MOVWF       _dose_Bq+1 
	MOVF        R2, 0 
	MOVWF       _dose_Bq+2 
	MOVF        R3, 0 
	MOVWF       _dose_Bq+3 
	GOTO        L__main767
;MyGeiger_NT.mbas,1981 :: 		else
L__main766:
;MyGeiger_NT.mbas,1982 :: 		dose_Bq = DL*100 / delitel
	MOVF        _DL+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        _delitel+0, 0 
	MOVWF       R4 
	MOVF        _delitel+1, 0 
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	CALL        _Word2Double+0, 0
	MOVF        R0, 0 
	MOVWF       _dose_Bq+0 
	MOVF        R1, 0 
	MOVWF       _dose_Bq+1 
	MOVF        R2, 0 
	MOVWF       _dose_Bq+2 
	MOVF        R3, 0 
	MOVWF       _dose_Bq+3 
;MyGeiger_NT.mbas,1983 :: 		dose_Bq = dose_Bq / 100
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _dose_Bq+0 
	MOVF        R1, 0 
	MOVWF       _dose_Bq+1 
	MOVF        R2, 0 
	MOVWF       _dose_Bq+2 
	MOVF        R3, 0 
	MOVWF       _dose_Bq+3 
;MyGeiger_NT.mbas,1985 :: 		end if
L__main767:
;MyGeiger_NT.mbas,1986 :: 		floattostr (dose_Bq, dose_Bq_txt)
	MOVF        _dose_Bq+0, 0 
	MOVWF       FARG_FloatToStr_input+0 
	MOVF        _dose_Bq+1, 0 
	MOVWF       FARG_FloatToStr_input+1 
	MOVF        _dose_Bq+2, 0 
	MOVWF       FARG_FloatToStr_input+2 
	MOVF        _dose_Bq+3, 0 
	MOVWF       FARG_FloatToStr_input+3 
	MOVLW       _dose_Bq_txt+0
	MOVWF       FARG_FloatToStr_output+0 
	MOVLW       hi_addr(_dose_Bq_txt+0)
	MOVWF       FARG_FloatToStr_output+1 
	CALL        _FloatToStr+0, 0
;MyGeiger_NT.mbas,1987 :: 		ltrim (dose_Bq_txt)
	MOVLW       _dose_Bq_txt+0
	MOVWF       FARG_ltrim_astring+0 
	MOVLW       hi_addr(_dose_Bq_txt+0)
	MOVWF       FARG_ltrim_astring+1 
	CALL        _ltrim+0, 0
;MyGeiger_NT.mbas,1990 :: 		Soft_UART_Write (32)
	MOVLW       32
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;MyGeiger_NT.mbas,1991 :: 		sendcpm ("cpm, ")
	MOVLW       99
	MOVWF       ?LocalText_main+0 
	MOVLW       112
	MOVWF       ?LocalText_main+1 
	MOVLW       109
	MOVWF       ?LocalText_main+2 
	MOVLW       44
	MOVWF       ?LocalText_main+3 
	MOVLW       32
	MOVWF       ?LocalText_main+4 
	CLRF        ?LocalText_main+5 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_sendcpm_cpms+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_sendcpm_cpms+1 
	CALL        _sendcpm+0, 0
;MyGeiger_NT.mbas,1992 :: 		sendcpm (dose_Bq_txt)
	MOVLW       _dose_Bq_txt+0
	MOVWF       FARG_sendcpm_cpms+0 
	MOVLW       hi_addr(_dose_Bq_txt+0)
	MOVWF       FARG_sendcpm_cpms+1 
	CALL        _sendcpm+0, 0
;MyGeiger_NT.mbas,1993 :: 		Soft_UART_Write (32)
	MOVLW       32
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;MyGeiger_NT.mbas,1994 :: 		sendcpm ("Bq/cm")
	MOVLW       66
	MOVWF       ?LocalText_main+0 
	MOVLW       113
	MOVWF       ?LocalText_main+1 
	MOVLW       47
	MOVWF       ?LocalText_main+2 
	MOVLW       99
	MOVWF       ?LocalText_main+3 
	MOVLW       109
	MOVWF       ?LocalText_main+4 
	CLRF        ?LocalText_main+5 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_sendcpm_cpms+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_sendcpm_cpms+1 
	CALL        _sendcpm+0, 0
;MyGeiger_NT.mbas,1995 :: 		Soft_UART_Write (94)
	MOVLW       94
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;MyGeiger_NT.mbas,1996 :: 		Soft_UART_Write (50)
	MOVLW       50
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;MyGeiger_NT.mbas,1997 :: 		Soft_UART_Write (32)
	MOVLW       32
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
L__main763:
;MyGeiger_NT.mbas,1999 :: 		Soft_UART_Write (13)
	MOVLW       13
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;MyGeiger_NT.mbas,2000 :: 		GIEH_bit = 1
	BSF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;MyGeiger_NT.mbas,2001 :: 		GIEL_bit = 1
	BSF         GIEL_bit+0, BitPos(GIEL_bit+0) 
;MyGeiger_NT.mbas,2003 :: 		Text_LCD (20, 7, "          ")
	MOVLW       20
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       32
	MOVWF       ?LocalText_main+0 
	MOVLW       32
	MOVWF       ?LocalText_main+1 
	MOVLW       32
	MOVWF       ?LocalText_main+2 
	MOVLW       32
	MOVWF       ?LocalText_main+3 
	MOVLW       32
	MOVWF       ?LocalText_main+4 
	MOVLW       32
	MOVWF       ?LocalText_main+5 
	MOVLW       32
	MOVWF       ?LocalText_main+6 
	MOVLW       32
	MOVWF       ?LocalText_main+7 
	MOVLW       32
	MOVWF       ?LocalText_main+8 
	MOVLW       32
	MOVWF       ?LocalText_main+9 
	CLRF        ?LocalText_main+10 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,2004 :: 		Text_LCD (20, 7, CPM_Display)
	MOVLW       20
	MOVWF       FARG_Text_LCD_x+0 
	MOVLW       7
	MOVWF       FARG_Text_LCD_y+0 
	MOVLW       _CPM_Display+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(_CPM_Display+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,2006 :: 		cpm_compensated =  cpm / (1 - cpm * c_factor)
	MOVF        _cpm+0, 0 
	MOVWF       R0 
	MOVF        _cpm+1, 0 
	MOVWF       R1 
	MOVF        _cpm+2, 0 
	MOVWF       R2 
	MOVF        _cpm+3, 0 
	MOVWF       R3 
	CALL        _Longword2Double+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	MOVF        FLOC__main+2, 0 
	MOVWF       R2 
	MOVF        FLOC__main+3, 0 
	MOVWF       R3 
	MOVF        _c_factor+0, 0 
	MOVWF       R4 
	MOVF        _c_factor+1, 0 
	MOVWF       R5 
	MOVF        _c_factor+2, 0 
	MOVWF       R6 
	MOVF        _c_factor+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVLW       127
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	MOVF        FLOC__main+2, 0 
	MOVWF       R2 
	MOVF        FLOC__main+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _cpm_compensated+0 
	MOVF        R1, 0 
	MOVWF       _cpm_compensated+1 
	MOVF        R2, 0 
	MOVWF       _cpm_compensated+2 
	MOVF        R3, 0 
	MOVWF       _cpm_compensated+3 
;MyGeiger_NT.mbas,2007 :: 		cpm_compensated = floor(cpm_compensated)
	MOVF        R0, 0 
	MOVWF       FARG_floor_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_floor_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_floor_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_floor_x+3 
	CALL        _floor+0, 0
	MOVF        R0, 0 
	MOVWF       _cpm_compensated+0 
	MOVF        R1, 0 
	MOVWF       _cpm_compensated+1 
	MOVF        R2, 0 
	MOVWF       _cpm_compensated+2 
	MOVF        R3, 0 
	MOVWF       _cpm_compensated+3 
;MyGeiger_NT.mbas,2009 :: 		if units = 0 then
	MOVF        _units+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main770
;MyGeiger_NT.mbas,2010 :: 		dose = cpm_compensated * CF                  ' Convert CPM to uSv/h
	MOVF        _CF+0, 0 
	MOVWF       R0 
	CALL        _Byte2Double+0, 0
	MOVF        _cpm_compensated+0, 0 
	MOVWF       R4 
	MOVF        _cpm_compensated+1, 0 
	MOVWF       R5 
	MOVF        _cpm_compensated+2, 0 
	MOVWF       R6 
	MOVF        _cpm_compensated+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _Double2Longword+0, 0
	MOVF        R0, 0 
	MOVWF       _dose+0 
	MOVF        R1, 0 
	MOVWF       _dose+1 
	MOVF        R2, 0 
	MOVWF       _dose+2 
	MOVF        R3, 0 
	MOVWF       _dose+3 
;MyGeiger_NT.mbas,2011 :: 		dosextract()
	CALL        _dosextract+0, 0
	GOTO        L__main771
;MyGeiger_NT.mbas,2012 :: 		else
L__main770:
;MyGeiger_NT.mbas,2013 :: 		dose = cpm_compensated * CF2                 ' Convert CPM to uRn/h
	MOVF        _CF2+0, 0 
	MOVWF       R0 
	MOVF        _CF2+1, 0 
	MOVWF       R1 
	MOVF        _CF2+2, 0 
	MOVWF       R2 
	MOVF        _CF2+3, 0 
	MOVWF       R3 
	CALL        _Longint2Double+0, 0
	MOVF        _cpm_compensated+0, 0 
	MOVWF       R4 
	MOVF        _cpm_compensated+1, 0 
	MOVWF       R5 
	MOVF        _cpm_compensated+2, 0 
	MOVWF       R6 
	MOVF        _cpm_compensated+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _Double2Longword+0, 0
	MOVF        R0, 0 
	MOVWF       _dose+0 
	MOVF        R1, 0 
	MOVWF       _dose+1 
	MOVF        R2, 0 
	MOVWF       _dose+2 
	MOVF        R3, 0 
	MOVWF       _dose+3 
;MyGeiger_NT.mbas,2014 :: 		dosextract2()
	CALL        _dosextract2+0, 0
;MyGeiger_NT.mbas,2015 :: 		end if
L__main771:
;MyGeiger_NT.mbas,2017 :: 		dose = cpm_total* CF              ' print absorbed dose
	MOVF        _cpm_total+0, 0 
	MOVWF       R0 
	MOVF        _cpm_total+1, 0 
	MOVWF       R1 
	MOVF        _cpm_total+2, 0 
	MOVWF       R2 
	MOVF        _cpm_total+3, 0 
	MOVWF       R3 
	MOVF        _CF+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _dose+0 
	MOVF        R1, 0 
	MOVWF       _dose+1 
	MOVF        R2, 0 
	MOVWF       _dose+2 
	MOVF        R3, 0 
	MOVWF       _dose+3 
;MyGeiger_NT.mbas,2018 :: 		dose = dose div 60
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _dose+0 
	MOVF        R1, 0 
	MOVWF       _dose+1 
	MOVF        R2, 0 
	MOVWF       _dose+2 
	MOVF        R3, 0 
	MOVWF       _dose+3 
;MyGeiger_NT.mbas,2019 :: 		dosextract3()
	CALL        _dosextract3+0, 0
;MyGeiger_NT.mbas,2022 :: 		m_period = 99                         '5 seconds period
	MOVLW       99
	MOVWF       _m_period+0 
;MyGeiger_NT.mbas,2025 :: 		if alert = 0 then
	BTFSC       _alert+0, BitPos(_alert+0) 
	GOTO        L__main773
;MyGeiger_NT.mbas,2026 :: 		if smartBL = 0x01 then
	MOVF        _smartBL+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main776
;MyGeiger_NT.mbas,2027 :: 		LATA.2   = 0 ' light
	BCF         LATA+0, 2 
L__main776:
;MyGeiger_NT.mbas,2029 :: 		LATB.7  = 0          ' turn alert off
	BCF         LATB+0, 7 
L__main773:
;MyGeiger_NT.mbas,2042 :: 		if PORTE = 0 then
	MOVF        PORTE+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main779
;MyGeiger_NT.mbas,2043 :: 		batlong = ADC_Read(0)           ' read BAT voltage
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _batlong+0 
	MOVF        R1, 0 
	MOVWF       _batlong+1 
;MyGeiger_NT.mbas,2044 :: 		if batlong <= 677 then      '3.3V
	MOVLW       128
	XORLW       2
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main881
	MOVF        R0, 0 
	SUBLW       165
L__main881:
	BTFSS       STATUS+0, 0 
	GOTO        L__main782
;MyGeiger_NT.mbas,2045 :: 		Text_LCD(0, 0, "$")       'BATT 25%
	CLRF        FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       36
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,2046 :: 		Text_LCD(5, 0, "#")
	MOVLW       5
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       35
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
	GOTO        L__main783
;MyGeiger_NT.mbas,2047 :: 		else
L__main782:
;MyGeiger_NT.mbas,2048 :: 		Text_LCD(0, 0, "-")       'BATT 50%
	CLRF        FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       45
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,2049 :: 		Text_LCD(5, 0, "#")
	MOVLW       5
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       35
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,2050 :: 		end if
L__main783:
;MyGeiger_NT.mbas,2052 :: 		if batlong >= 799 then      '3.9V
	MOVLW       128
	XORWF       _batlong+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main882
	MOVLW       31
	SUBWF       _batlong+0, 0 
L__main882:
	BTFSS       STATUS+0, 0 
	GOTO        L__main785
;MyGeiger_NT.mbas,2053 :: 		Text_LCD(0, 0, "-")       'BATT 100%
	CLRF        FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       45
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
;MyGeiger_NT.mbas,2054 :: 		Text_LCD(5, 0, ".")
	MOVLW       5
	MOVWF       FARG_Text_LCD_x+0 
	CLRF        FARG_Text_LCD_y+0 
	MOVLW       46
	MOVWF       ?LocalText_main+0 
	CLRF        ?LocalText_main+1 
	MOVLW       ?LocalText_main+0
	MOVWF       FARG_Text_LCD_sentance+0 
	MOVLW       hi_addr(?LocalText_main+0)
	MOVWF       FARG_Text_LCD_sentance+1 
	CALL        _Text_LCD+0, 0
L__main785:
;MyGeiger_NT.mbas,2056 :: 		for nn = 0 to 5
	CLRF        _nn+0 
	CLRF        _nn+1 
L__main788:
;MyGeiger_NT.mbas,2057 :: 		Soft_SPI_Write(0x00)
	CLRF        FARG_Soft_SPI_Write_sdata+0 
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,2058 :: 		next nn
	MOVLW       0
	XORWF       _nn+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main883
	MOVLW       5
	XORWF       _nn+0, 0 
L__main883:
	BTFSC       STATUS+0, 2 
	GOTO        L__main791
	INFSNZ      _nn+0, 1 
	INCF        _nn+1, 1 
	GOTO        L__main788
L__main791:
;MyGeiger_NT.mbas,2059 :: 		if batlong <=615 then     '750mV / 1.22    3.00V bat cut off
	MOVLW       128
	XORLW       2
	MOVWF       R0 
	MOVLW       128
	XORWF       _batlong+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main884
	MOVF        _batlong+0, 0 
	SUBLW       103
L__main884:
	BTFSS       STATUS+0, 0 
	GOTO        L__main793
;MyGeiger_NT.mbas,2060 :: 		delay_ms(100)
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L__main795:
	DECFSZ      R13, 1, 1
	BRA         L__main795
	DECFSZ      R12, 1, 1
	BRA         L__main795
	NOP
	NOP
;MyGeiger_NT.mbas,2061 :: 		batlong = ADC_Read(0)           ' read BAT voltage again
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _batlong+0 
	MOVF        R1, 0 
	MOVWF       _batlong+1 
;MyGeiger_NT.mbas,2062 :: 		if batlong <=615 then
	MOVLW       128
	XORLW       2
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main885
	MOVF        R0, 0 
	SUBLW       103
L__main885:
	BTFSS       STATUS+0, 0 
	GOTO        L__main797
;MyGeiger_NT.mbas,2063 :: 		halt_system()
	CALL        _halt_system+0, 0
L__main797:
;MyGeiger_NT.mbas,2064 :: 		end if
L__main793:
;MyGeiger_NT.mbas,2065 :: 		end if
	GOTO        L__main780
;MyGeiger_NT.mbas,2066 :: 		else
L__main779:
;MyGeiger_NT.mbas,2067 :: 		PositionLCD(0,0)
	CLRF        FARG_PositionLCD_x+0 
	CLRF        FARG_PositionLCD_y+0 
	CALL        _PositionLCD+0, 0
;MyGeiger_NT.mbas,2068 :: 		for nn = 0 to 15
	CLRF        _nn+0 
	CLRF        _nn+1 
L__main800:
;MyGeiger_NT.mbas,2069 :: 		Soft_SPI_Write (plug[nn])
	MOVLW       _plug+0
	ADDWF       _nn+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_plug+0)
	ADDWFC      _nn+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_plug+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Soft_SPI_Write_sdata+0
	CALL        _Soft_SPI_Write+0, 0
;MyGeiger_NT.mbas,2070 :: 		next nn
	MOVLW       0
	XORWF       _nn+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main886
	MOVLW       15
	XORWF       _nn+0, 0 
L__main886:
	BTFSC       STATUS+0, 2 
	GOTO        L__main803
	INFSNZ      _nn+0, 1 
	INCF        _nn+1, 1 
	GOTO        L__main800
L__main803:
;MyGeiger_NT.mbas,2071 :: 		end if
L__main780:
;MyGeiger_NT.mbas,2077 :: 		cpm_read_done = 0
	BCF         _cpm_read_done+0, BitPos(_cpm_read_done+0) 
;MyGeiger_NT.mbas,2079 :: 		TMR1IE_bit = 1
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
L__main725:
;MyGeiger_NT.mbas,2082 :: 		wend
	GOTO        L__main660
L_end_main:
	GOTO        $+0
; end of _main
