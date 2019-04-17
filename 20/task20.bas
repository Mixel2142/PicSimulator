'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0

Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = portd
Define LCD_RSBIT = 1
Define LCD_EREG = portd
Define LCD_EBIT = 3
Define LCD_RWREG = portd
Define LCD_RWBIT = 2

Dim i As Byte

TRISA = %11111111

Dim an0 As Long


Lcdinit 0

characters = 12  'LCD 2 X 16 (16-4)


Dim five As Byte

loop:

Adcin 0, an0

Lcdout "Voltage: ", #an0, "mV"

Lcdcmdout LcdLine2Home



'Lcdout #procent, "%"
WaitMs 100
Lcdcmdout LcdClear

Goto loop