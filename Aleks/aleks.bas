'PIC16F876
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0


TRISA = %11111111
PORTA = %00000000

TRISC = %11101110
PORTC = %00110000

Symbol zaryadka = PORTC.0  'Включает и выключает зарядку АКБ.должна быть выкл по умолчанию
Gosub off_zaryadka

Symbol razryad = PORTC.4  'Включает и выключает разрядку АКБ через нагрузку.'должна быть вкл по умолчанию
Gosub on_razryad

Symbol power = PORTC.5  'Кнопка для включения устройства и начала зарядки АКБ(после вставки АКБ)
power = 0

Dim mod_zaryadka As Bit  'Включает и выключает режим зарядки
mod_zaryadka = 0


'Настройка LCD модуля
Define LCD_LINES = 4
Define LCD_CHARS = 16
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTC
Define LCD_RSBIT = 1
Define LCD_EREG = PORTC
Define LCD_EBIT = 3
Define LCD_RWREG = PORTC
Define LCD_RWBIT = 2

'Single эквивалент double
Dim voltage_akb As Single  'хранит напряжение на АКБ
Dim current_akb As Single  'хранит ток через нагрузку на АКБ

Dim old_voltage As Single  'запоменает старое значение напряжения
old_voltage = 0

Dim capacity_r As Long  'переменная для ёмкости
capacity_r = 0

Dim capacity_z As Long  'переменная для ёмкости
capacity_z = 0

Dim capacity_time As Long  'переменная для ёмкости
capacity_time = 0

Dim vol As Word  'Переменная для записи напряжения батареи с AN0
Dim cur As Word  'Переменная для записи тока батареи с AN1

Lcdinit 0

main:

	Adcin 0, vol  'Сняли значение напряжения на АКБ
	Adcin 1, cur  'Сняли значение тока на АКБ
	
	If power Then
						
			voltage_akb = vol * 5 / 1023  'перевели в вольты
			current_akb = cur * 5 / 1023  'перевели в амперы

			Lcdcmdout LcdLine1Home
			Lcdout "U:", #voltage_akb, "V"
		
			Lcdout "I:", #current_akb, "A"
			
			
			If voltage_akb < 2.8 And mod_zaryadka = 0 Then
				mod_zaryadka = 1
				Gosub off_razryad
				Gosub on_zaryadka
				capacity_z = capacity_time * current_akb  'Нужно делить на 1000 т.к. время в милисекундах
				capacity_time = 0
			Endif
				
			If voltage_akb > 2.8 Then
				Gosub on_razryad
			Endif

			If voltage_akb > 4.2 And mod_zaryadka = 1 Then
				mod_zaryadka = 0
				Gosub off_zaryadka
				Gosub on_razryad
				capacity_r = capacity_time * current_akb  'Нужно делить на 1000 т.к. время в милисекундах
				'не делил для наглядности
				capacity_time = 0
			Endif
			
			capacity_time = capacity_time + 100  '+ 100 мс (waitms 100)
			
			Lcdcmdout LcdLine2Home
			If capacity_z = 0 Then
				Lcdout "cap_z: Nun"
			Else
				Lcdout "cap_z: ", #capacity_z, "Ah"
			Endif
			
			Lcdcmdout LcdLine3Home
			If capacity_r = 0 Then
				
				Lcdout "cap_r: Nun"
			Else
				Lcdout "cap_r: ", #capacity_r, "Ah"
			Endif
			
			Lcdcmdout LcdLine4Home
			
			If zaryadka Then
				Lcdout "zar_on "
			Else
				Lcdout "zar_off "
			Endif
			
			If razryad = 0 Then
				Lcdout "raz_on "
			Else
				Lcdout "raz_off "
			Endif
			
	Else  'ввели устройство в изначальное положение
	
		Gosub off_zaryadka
		Gosub on_razryad
		
		If vol > 0 Then
			If cur > 0 Then
				Lcdcmdout LcdLine1Home
				Lcdout "Ready to work!",
				Lcdcmdout LcdLine2Home
				Lcdout "AKB complete!"
				Lcdcmdout LcdLine3Home
				Lcdout "Just press RC5!"
			Else
				Lcdcmdout LcdLine1Home
				Lcdout "Ready to work!",
				Lcdcmdout LcdLine2Home
				Lcdout "AKB complete!"
				Lcdcmdout LcdLine3Home
				Lcdout "AKB is death!"
			Endif
		Else
			Lcdcmdout LcdLine1Home
			Lcdout "Ready to work!",
			Lcdcmdout LcdLine2Home
			Lcdout "Just insert AKB"
			Lcdcmdout LcdLine3Home
			Lcdout "and press RC5!"
		Endif
	Endif

WaitMs 100
Lcdcmdout LcdClear
Goto main
End                                               


'Функции которые включают и выключают зарядку/нагрузку
on_zaryadka:
zaryadka = 1
Return                                            


off_zaryadka:
zaryadka = 0
Return                                            


on_razryad:
razryad = 0
Return                                            

off_razryad:
razryad = 1
Return                                            









