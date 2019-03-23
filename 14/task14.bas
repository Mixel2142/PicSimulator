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


'Single - переменная с плавающей точкой

Dim power As Single  'напряжение питания
power = 5  'вольт

Dim resistance_r1 As Single  'сопротивление резистора R1
resistance_r1 = 250  'Om
Dim voltage_r1 As Single  'напряжение на резисторе R1

Dim resistance_r2 As Single  'сопротивление резистора R2
Dim voltage_r2 As Single  'напряжение на резисторе R2

TRISA = %11111111 ' настройка порта А на ввод
Dim an0 As Long ' переменная для записи с АЦП А0

Lcdinit 1 ' инициализация коретки на LCD

loop:

Adcin 0, an0 'Запись с АЦП в переменную
voltage_r2 = power * an0 / 1024 ' расчет напряжения на Р2
Lcdout "Voltage:", #voltage_r2, "V" ' вывод на LCD значения напряжения
Lcdcmdout LcdLine2Home 'коретку на 2 строчку
voltage_r1 = power - voltage_r2 ' расчет напряжения на Р1
resistance_r2 = voltage_r2 * resistance_r1 / voltage_r1 ' расчет сопротивления Р2
Lcdout "Resis:", #resistance_r2, "Om" ' вывод на LCD значения сопротивления

WaitMs 100
Lcdcmdout LcdClear ' очистка  LCD

Goto loop
