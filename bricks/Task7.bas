'PIC16F84
Dim mask As Byte
Dim digit As Byte
TRISA = %11111111
TRISB = %00000000
PORTB = 0
PORTA = 0
loop:
digit = PORTA
mask = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
PORTB = mask

Goto loop