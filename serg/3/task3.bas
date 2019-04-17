'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0
'настройки LCD модуля
'open Tools->Oscilloscope в нужные моменты включать и выключать галочку refresh !
Define LCD_LINES = 4
Define LCD_CHARS = 16
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTD
Define LCD_RSBIT = 1
Define LCD_EREG = PORTD
Define LCD_EBIT = 3
Define LCD_RWREG = PORTD
Define LCD_RWBIT = 2


TRISA = %11111111  'Все порты А на приём (включаем АЦП на них)
TRISD.0 = 0  'Порт Д ноль будет формировать выходной импульс
PORTD.0 = 0  'логический ноль на порте

Dim longh As Word  'Объявили переменную для записи в неё значения из АЦП порта А0
Dim an1 As Word  'Объявили переменную для записи в неё значения из АЦП порта А1
Dim freq As Single  'Объявили переменную для записи в неё значения из АЦП порта А0
Dim longl As Long

Lcdinit 1  'Инициализировали коретку на ЛСД модуле

loop:  'указатель для GOTO

Adcin 0, longh  'записали значения из АЦП в переменную
Adcin 1, an1  'записали значения из АЦП в переменную

Lcdcmdout LcdLine1Home  'переместили каретку на 2 строку
Lcdout "LongH:", #longh, "ms"  'выведи на ЛСД экран надпись с значением переменной

longl = longh - (an1 * longh / 1024)

Lcdcmdout LcdLine2Home  'переместили каретку на 2 строку
Lcdout "LongL:", #longl, "ms"  'выведи на ЛСД экран надпись с значением переменной

If longh > 0 And longl > 0 Then
freq = 1000 / (longh + longl)
Else
freq = 0
Endif

Lcdcmdout LcdLine3Home  'переместили каретку на 2 строку
Lcdout "freq:", #freq, "Hz"  'выведи на ЛСД экран надпись с значением переменной

If longh = 0 Then
WaitMs 100
Lcdcmdout LcdClear  'очистка  LCD
Goto loop  'вернулись на указатель loop
Endif

PORTD.0 = 1  'логическая 1 на порте Д 0
WaitMs longh  'подождали an1 милисек (продолжительность импульса)
PORTD.0 = 0  'логическая 0 на порте Д 0
WaitMs longl  'подождали an0 милисек (расстояние между импульсами)

Lcdcmdout LcdClear  'очистка  LCD

Goto loop  'вернулись на указатель loop
