'PIC16F84

TRISB = %00000000
TRISC = %00000000
PORTC = %00000000
PORTB = 0

TRISA = %11111111
Dim an0 As Long

Dim u As Byte
Dim pp As Byte
u = %00111110
pp = %01110011
Dim dd As Byte
dd = %01011110
Dim nn As Byte
nn = %00110111

Dim oo As Byte
oo = %00111111

Dim procherk As Byte
procherk = %01000000

Dim vol As Long
vol = 0

loop:
Adcin 0, an0

If vol = an0 Then
PORTC = %00001111
PORTB = procherk
Goto looped
Endif

If vol > an0 Then
PORTC = %00000001
PORTB = u
PORTC = %00000010
PORTB = pp
Goto looped
WaitMs 100
Endif

'If vol < an0 Then
'PORTC = %00000001
'PORTB = dd
'PORTC = %00000010
'PORTB = oo
'PORTC = %00000100
'PORTB = u
'PORTC = %00001000
'PORTB = nn
'Goto looped
'Endif

looped:

vol = an0


WaitMs 100
PORTC = %00001111
PORTB = %00000000
Goto loop