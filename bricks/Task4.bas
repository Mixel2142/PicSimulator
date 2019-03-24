'PIC16F884
'open Tools->Software UART Simulation Interface
Define SEROUT_DELAYUS = 500
Dim l(8) As Byte

TRISA = %11111111

Dim an0 As Word
Dim an1 As Word
Dim an2 As Word
Dim an3 As Word
Dim an4 As Word
Dim an5 As Word
Dim an6 As Word
Dim an7 As Word

Dim i As Byte
'объявим переменную I как байт

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

For i = 0 To 7
'организуем цикл с уменьшением
Serout PORTB.6, 9600, "An", #i, " = ", #l(i), CrLf
'передаём данные ерез вывод PORTB.1
'WaitMs 500
'эта задержка должна быть в ре
'альном устройстве
Next i
WaitMs 1000
Serout PORTB.6, 9600, Lf, Lf, Lf, Lf, Lf, Lf, Lf, Lf, Lf
Goto loop
'бесконечный цикл.