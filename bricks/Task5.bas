'PIC16F884
'open Tools->Software UART Simulation Interface
'open Tools->LCD Module
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTD
Define LCD_RSBIT = 1
Define LCD_EREG = PORTD
Define LCD_EBIT = 3
Define LCD_RWREG = PORTD
Define LCD_RWBIT = 2

Dim i As Byte
'объ€вим переменную ш как байт
Lcdinit 1

loop:

Serin PORTC.0, 9600, i

Lcdout "I have ", #i, " apple!"
WaitMs 1000
Lcdcmdout LcdClear

Goto loop
'бесконечный цикл.