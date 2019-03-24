'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0
'настройки LCD модуля
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

Dim an0 As Word  'Объявили переменную для записи в неё значения из АЦП порта А0
Dim an1 As Word  'Объявили переменную для записи в неё значения из АЦП порта А1

Lcdinit 1  'Инициализировали коретку на ЛСД модуле

loop:  'указатель для GOTO

Adcin 0, an0  'записали значения из АЦП в переменную
Adcin 1, an1  'записали значения из АЦП в переменную

Lcdout "LongH:", #an1, "ms"  'выведи на ЛСД экран надпись с значением переменной

Lcdcmdout LcdLine2Home  'переместили каретку на 2 строку

Lcdout "LongL:", #an0, "ms"  'выведи на ЛСД экран надпись с значением переменной

If an1 = 0 Then
WaitMs 100
Lcdcmdout LcdClear  'очистка  LCD
Goto loop  'вернулись на указатель loop
Endif

PORTD.0 = 1  'логическая 1 на порте Д 0
WaitMs an1  'подождали an1 милисек (продолжительность импульса)
PORTD.0 = 0  'логическая 0 на порте Д 0
WaitMs an0  'подождали an0 милисек (расстояние между импульсами)

Lcdcmdout LcdClear  'очистка  LCD

Goto loop  'вернулись на указатель loop
