'PIC16F884
Dim a As Byte  'eeprom address
Dim b As Byte  'eeprom data
Dim l(6) As Byte
TRISA = %11111111
TRISC = %11111111

Dim an0 As Word
Dim an1 As Word
Dim an2 As Word
Dim an3 As Word
Dim an4 As Word
Dim an5 As Word
Dim an6 As Word
Dim an7 As Word




loop:
Adcin 0, an0
Adcin 1, an1
Adcin 2, an2
Adcin 3, an3
Adcin 4, an4
Adcin 5, an5
Adcin 6, an6
Adcin 7, an7


l(0) = an0
l(1) = an1
l(2) = an2
l(3) = an3
l(4) = an4
l(5) = an5
l(6) = an6
l(7) = an7


For a = 0 To 9  'go through whole eeprom memory
b = l(a)  'set the data value to be written
Write a, b  'perform the writing to eeprom
Next a
Goto loop