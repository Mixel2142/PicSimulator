'PIC16F877
'open Tools->Hardware UART Simulation Interface
Dim l(8) As Byte

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

Dim i As Byte
'объявим переменную I как байт
Hseropen 9600
'откроем порт hardware UART:
'скорость 9600 бод
'WaitMs 1000
'эта задержка должна быть в ре
'альном устройстве
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
Hserout "An", #i, " = ", #l(i), CrLf
'передаём данные по последова
'тельному порту
'WaitMs 500
'эта задержка должна быть в ре
'альном устройстве
Next i
WaitMs 1000
Hserout Lf, Lf, Lf, Lf, Lf, Lf, Lf, Lf
Goto loop
'бесконечный цикл.