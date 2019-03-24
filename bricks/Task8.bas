'PIC16F628
Define LCD_LINES = 2
Define LCD_CHARS = 16
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTA
Define LCD_RSBIT = 6
Define LCD_EREG = PORTA
Define LCD_EBIT = 7
Define LCD_RWREG = PORTA
Define LCD_RWBIT = 5

Lcdinit 1
loop:
	Lcdcmdout LcdClear
	Lcdcmdout LcdLine1Home
	Lcdout "Hello"
	WaitMs 1000
Goto loop
