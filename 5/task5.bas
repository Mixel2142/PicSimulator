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

Dim power As Single  'напряжение питания
power = 5  'voltage
Dim an0 As Long  'Объявили переменную для записи в неё значения из АЦП порта А0
Dim voltage_vd As Single  'напряжение на диоде

Lcdinit 1  'Инициализировали коретку на ЛСД модуле

loop:  'указатель для GOTO
	Adcin 0, an0  'записали значения из АЦП в переменную
	voltage_vd = power * an0 / 1024  'расчет напряжения на диоде
	Lcdout "voltage:", #voltage_vd, "V"  'выведи на ЛСД экран надпись с значением переменной
	Lcdcmdout LcdLine2Home  'переместили каретку на 2 строку

	If voltage_vd < 1.6 Then
		Lcdout "VD is INFRARED!"
	Endif
	If voltage_vd > 1.6 And voltage_vd < 2.03 Then
		Lcdout "VD is RED!"
	Endif
	If voltage_vd > 2.03 And voltage_vd < 2.1 Then
		Lcdout "VD is ORANGE!"
	Endif
	If voltage_vd > 2.1 And voltage_vd < 2.2 Then
		Lcdout "VD is YELLOW!"
	Endif
	If voltage_vd > 2.2 And voltage_vd < 3.5 Then
		Lcdout "VD is GREEN!"
	Endif
	
	
	WaitMs 200
	Lcdcmdout LcdClear  'очистка  LCD
Goto loop  'вернулись на указатель loop
