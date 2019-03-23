'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0

' настройка LCD модуля под порты микроконтроллера
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTD
Define LCD_RSBIT = 1
Define LCD_EREG = PORTD
Define LCD_EBIT = 3
Define LCD_RWREG = PORTD
Define LCD_RWBIT = 2

Dim i As Byte 'создали переменную

TRISA = %11111111 ' настройка портов A на ввод(их 8)

Dim an0 As Long'создали переменную
Dim maxvolt As Long'создали переменную
Dim procent As Long'создали переменную
Dim characters As Byte'создали переменную
Dim fived As Byte'создали переменную
Dim four As Byte'создали переменную

Lcdinit 1 'инициализировали коретку на LCD

characters = 12' LCD 2 X 16 (16-4) 

Lcddefchar 1, %10000, %10000, %10000, %10000, %10000, %10000, %10000, %10000'задаём значение переменной 1
Lcddefchar 2, %11000, %11000, %11000, %11000, %11000, %11000, %11000, %11000'задаём значение переменной 2
Lcddefchar 3, %11100, %11100, %11100, %11100, %11100, %11100, %11100, %11100'задаём значение переменной 3
Lcddefchar 4, %11110, %11110, %11110, %11110, %11110, %11110, %11110, %11110'задаём значение переменной 4
Lcddefchar 5, %11111, %11111, %11111, %11111, %11111, %11111, %11111, %11111'задаём значение переменной 5

Dim five As Byte'создали переменную

loop:'аналог main

Adcin 0, an0 ' сняли значения с аналогового порта A0

Lcdout "Voltage: ", #an0, "mV" ' вывели на экран значение порта

Lcdcmdout LcdLine2Home ' коретка на втору строчку

procent = an0 * 100 / maxvolt ' перевели значение в %

fived = 100 / characters ' посчитали значение в % для одного квадратика 5Х5
five = procent / fived ' посчитали кол-во квадратиков

For i = 1 To five Step 1 ' цикл для заполнения квадратиков 5Х5
Lcdout 5
Next i

four = procent - fived * five ' посчитали оставшиеся проценты, которые не отображены

If four > 4 Then ' отоброзили оставшиеся проценты
Lcdout 4 ' отоброзили значение определённое на строчке 32
Goto loopend
Endif

If four > 3 Then' отоброзили оставшиеся проценты
Lcdout 3	' отоброзили значение определённое на строчке 31
Goto loopend
Endif

If four > 2 Then' отоброзили оставшиеся проценты
Lcdout 2	' отоброзили значение определённое на строчке 30
Goto loopend
Endif

If four > 1 Then' отоброзили оставшиеся проценты
Lcdout 1	' отоброзили значение определённое на строчке 29
Endif

loopend:

Lcdout #procent, "%" ' отобразили значение в процентах
WaitMs 100
Lcdcmdout LcdClear ' очистили экран

Goto loop