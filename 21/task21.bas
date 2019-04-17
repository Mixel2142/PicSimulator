'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'open Tools->Software UART
'open Tools->Oscilloscope настроил его и закрыл
'Simulation->start
'подождал пока выполнение программы пройдёт init0
'open Tools->Oscilloscope


TRISD = 0  'порты управляющие формой сигнала
PORTD = 0  'начальное положение лгический 0

TRISA = 0  'отключили не нужные порты
PORTA = 0

TRISE = 0  'отключили не нужные порты
PORTE = 0


'настройка LCD модуля
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTC
Define LCD_RSBIT = 0
Define LCD_EREG = PORTC
Define LCD_EBIT = 1
Define LCD_RWREG = PORTC
Define LCD_RWBIT = 2
Dim mod_signal As Byte  'переменная для переключения видов сигнала (максимум 255)
mod_signal = 2

Dim sinus As Byte  'переменная для кейса
sinus = 0

Dim pila As Byte  'переменная для кейса
pila = 1

Dim pryamougol As Byte  'переменная для кейса
pryamougol = 2

Dim amplituda As Byte  'переменная определяет амлитуду сигнала
amplituda = 100  '1 = 0.02 Вольт

Dim frequency As Byte  'переменная определяет частоту сигнала
frequency = 100  '1 Hz Гц 1 раз в секунду

Dim wait As Long  'переменная определяет длительность периода сигнала
wait = 1000 / frequency

Dim x As Byte  'переменная для for
Dim two_pi As Single  'переменная для sin
two_pi = 2 * 3.141592

Dim add_ampl As Byte
add_ampl = %00001000

Dim sub_ampl As Byte
sub_ampl = %00010000

Dim add_freq As Byte
add_freq = %00100000

Dim sub_freq As Byte
sub_freq = %01000000

Dim change_mod As Byte
change_mod = %10000000

Dim act_change_mod As Byte
act_change_mod = 0

Lcdinit 0
main:
	Lcdcmdout LcdLine1Home
	Lcdout "Active mod:"
	
	Select Case mod_signal
	Case sinus
		Lcdout "sin!"
		Gosub sin_mod
	Case pila
		Lcdout "ramp!"
		Gosub ramp_mod
	Case pryamougol
		Lcdout "rect!"
		Gosub pryamougol_mod
	EndSelect

	Lcdcmdout LcdLine2Home
	Lcdout "amp:"
	Lcdout #amplituda
	Lcdout "freq:"
	Lcdout #frequency
	WaitMs 10

	act_change_mod = PORTC And %11111000
	
	While act_change_mod > 0
	act_change_mod = PORTC And %11111000
	
	Select Case act_change_mod
	Case add_ampl
		amplituda = amplituda + 1
		
	Case sub_ampl
		amplituda = amplituda - 1
		If amplituda < 1 Then
			amplituda = 100
		Endif
		
	Case add_freq
		frequency = frequency + 10

	Case sub_freq
		frequency = frequency - 1
		If frequency < 1 Then
			frequency = 1
		Endif
		
	Case change_mod
		mod_signal = mod_signal + 1
		If mod_signal > 2 Then
			mod_signal = 0
		Endif
	EndSelect
	
	Lcdcmdout LcdLine1Home
	Lcdout "Active mod:"
	
	Select Case mod_signal
	Case sinus
		Lcdout "sin!"
	Case pila
		Lcdout "ramp!"
	Case pryamougol
		Lcdout "rect!"
	EndSelect
	Lcdcmdout LcdLine2Home
	Lcdout "amp:"
	Lcdout #amplituda
	Lcdout "freq:"
	Lcdout #frequency
	WaitMs 20
	Lcdcmdout LcdClear
	Wend
	
	If PORTE.3 = 1 Then
	Serout PORTA.6, 9600, "Input mod signal:", CrLf
	Serout PORTA.6, 9600, "2 - rectangle", CrLf
	Serout PORTA.6, 9600, "1 - ramp", CrLf
	Serout PORTA.6, 9600, "0 - sin", CrLf
	Serin PORTA.7, 9600, mod_signal
	
	If mod_signal > 2 Then
		mod_signal = 0
	Endif
	
	Serout PORTA.6, 9600, "Input freq:", CrLf
	Serin PORTA.7, 9600, frequency
	Serout PORTA.6, 9600, "Input amp:", CrLf
	Serin PORTA.7, 9600, amplituda
	Endif
Lcdcmdout LcdClear
Goto main
End                                               

Dim y As Single
Dim step_y As Single
Dim wait_sin As Long

Dim event_sin_y As Single
sin_mod:
y = 0
step_y = two_pi / amplituda
wait_sin = wait / (two_pi / step_y)
While y <= two_pi
	event_sin_y = Cos(y) * amplituda / 2
	PORTD = abs(event_sin_y)
	y = y + step_y
	WaitMs wait_sin
Wend
Return                                            

Dim wait_ramp As Long
ramp_mod:
wait_ramp = wait / amplituda
For x = 0 To amplituda Step 1
	PORTD = amplituda - x
	WaitMs wait_ramp
Next x
Return                                            

Dim wait_rect As Long
pryamougol_mod:
wait_rect = wait / 2
PORTD = amplituda
WaitMs wait_rect
PORTD = 0
WaitMs wait_rect
Return                                            

Function abs(arg1 As Single) As Byte  'функция, которая уже возращает значение
Dim event As Long
event = arg1 + (amplituda / 2)
abs = event.LB  'передали в переменную LowBits (все биты от 0 до 4) 4 - 8 проигнорировали
End Function                                      




