'PIC16F876
'open Tools->7-Srgment LED Displays
'open Tools->Microcontroller View
'open Tools->Oscilloscope
'Simulation->start
'Нажимая F1 можно получить информацию о языке Basic


TRISA = 0  'задаём порты А на вывод '0'- output
PORTA = 255  'задаём порты А на значение логической единицы
'с помощью слова PORTч , где ч - название порта, мы можем устанавливать логические уровни на них (0 и 1)

TRISB = %00000111  'задаём порты B на вывод '0'- output и "1" - input
PORTB = 0  'задаём порты B на прослушку и логический ноль

'Переменная типа Byte (0-255)
Dim f_segm As Byte  'f,a,s,i,n это переменные, которые используются при выводе букв на 7-segment LED
f_segm = %01110001  'запись вида % означает запись числа в битовом виде

Dim a_segm As Byte
a_segm = %01110111

Dim s_segm As Byte
s_segm = %01101101

Dim i_segm As Byte
i_segm = %00000110

Dim n_segm As Byte
n_segm = %01010100

Dim r_segm As Byte
r_segm = %00110011

Dim p_segm As Byte
p_segm = %01110011

Dim l_segm As Byte
l_segm = %00111000

Dim e_segm As Byte
e_segm = %01111001

Dim c_segm As Byte
c_segm = %00111001

Dim t_segm As Byte
t_segm = %01111000

Dim mod_signal As Byte  'переменная для переключения видов сигнала (максимум 255)
mod_signal = 2

Dim amplituda As Byte  'переменная определяет амлитуду сигнала
amplituda = 100  '1 = 0.02 Вольт

Dim frequency As Byte  'переменная определяет частоту сигнала
frequency = 100  '1 Hz Гц 1 раз в секунду

Dim wait As Long  'переменная определяет длительность периода сигнала
wait = 1000 / frequency

Dim two_pi As Single  'переменная для sin
two_pi = 2 * 3.141592

Dim act_change_mod As Byte
act_change_mod = 0

INTCON.INTE = 1  'Включили прерывания RB0/INT
INTCON.GIE = 1  'Включает все прерывания

main:  'указатель

	Gosub show_mod_signal  'вызывает код с указателя show_mod_signal

	Select Case mod_signal  'в зависимости от типа сигнала порты С генерируют разные уровни напряжения
	Case 0
		Gosub sin_mod  'вызывает код с указателя sin_mod
	Case 1
		Gosub ramp_mod  'вызывает код с указателя ramp_mod
	Case 2
		Gosub pryamougol_mod  'вызывает код с указателя pryamougol_mod
	EndSelect

	Goto main  'переходит на указатель main
End                                               

On Interrupt  'программа прерывания

While PORTB.0  'цикл while будет выполняться пока на порту B0 будет логическая единица
	Select Case act_change_mod  'в зависимости от значения переменной act_change_mod выбирается нужный CASE
	Case 0
		Gosub show_ampl_signal  'вызывает код с указателя show_ampl_signal
		'кнопки B2 и В1 управляют уровнем амплетуды и частоты в зависимости от того, что отображается на диодном индикаторе
		If PORTB.2 Then
		amplituda = amplituda + 1  'если нажата кнопка B2, тогда аплетуда увелисивается на 1
		Endif
		If PORTB.1 Then
		amplituda = amplituda - 1  'если нажата кнопка B1, тогда аплетуда уменьшается на 1
		Endif
	Case 1
		Gosub show_freq_signal  'вызывает код с указателя show_freq_signal
		If PORTB.2 Then
		frequency = frequency + 1  'если нажата кнопка B2, тогда частота увелисивается на 1
		Endif
		If PORTB.1 Then
		frequency = frequency - 1  'если нажата кнопка B1, тогда частота уменьшается на 1
		Endif
	Case 2
		Gosub show_mod_signal  'вызывает код с указателя show_mod_signal
		If PORTB.2 Then  'здесь можно выбрать нужный вид сигнала из 3-х предложенных
		mod_signal = mod_signal + 1
		Endif
		If PORTB.1 Then
		mod_signal = mod_signal - 1
		Endif
		If mod_signal > 2 Then
		mod_signal = 0
		Endif
	EndSelect
Wend  'конец цикла while
act_change_mod = act_change_mod + 1  'изменения этой переменной приводят к изменению информации на 7-segment индекаторе
If act_change_mod > 2 Then  'колличество сигналов 3(пила,прямоуг, sin) act_change_mod начинается с 0
act_change_mod = 0  'предотвращает выход переменной за нужный диапазон
Endif
Gosub show_mod_signal  'вызывает код с указателя show_mod_signal
INTCON.INTF = 0  'Включили заново прерывание RB0/INT
Resume  'выполнение программы возращается обратно к месту откуда была вызван код

show_mod_signal:  'ссылка на которую может переходить выполнение программы
Dim portb_help As Byte  'переменная помогает правильному отобржанию значений на диодном индекаторе
PORTB = 0
Select Case mod_signal  'В Case-ах происходит вывод информации о виде сигнала на LED индекатор
	Case 0
'Записали в 1-е знакоместо букву S
		PORTB.7 = 1
		PORTA = s_segm
		portb_help = s_segm And %01000000  'And это побитовая операция сложения
		portb_help = ShiftRight(portb_help, 3)  'ShiftRight смещает значение битов в переменной вправо на 3 позиции
		PORTB = PORTB Or portb_help  'Or это побитовая операция сложения
		PORTB.7 = 0
'Записали во 2-е знакоместо букву i
		PORTB.6 = 1
		PORTA = i_segm
		PORTB.3 = 0
		PORTB.6 = 0
'Записали в 3-е знакоместо букву n
		PORTB.5 = 1
		PORTA = n_segm
		portb_help = n_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.5 = 0
		PORTB.3 = 0
'Записали в 4-е знакоместо ничего
		PORTB.4 = 1
		PORTA = 0
		PORTB.3 = 0
		PORTB.4 = 0
		
	Case 1
	'Записали в 1-е знакоместо букву p
		PORTB.7 = 1
		PORTA = p_segm
		portb_help = p_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.7 = 0
	'Записали во 2-е знакоместо букву i
		PORTB.6 = 1
		PORTA = i_segm
		PORTB.3 = 0
		PORTB.6 = 0
	'Записали в 3-е знакоместо букву l
		PORTB.5 = 1
		PORTA = l_segm
		PORTB.3 = 0
		PORTB.5 = 0
'Записали в 4-е знакоместо букву a
		PORTB.4 = 1
		PORTA = a_segm
		portb_help = a_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.4 = 0

	Case 2
	'Записали в 1-е знакоместо букву r
		PORTB.7 = 1
		PORTA = r_segm
		portb_help = r_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.7 = 0
	'Записали во 2-е знакоместо букву e
		PORTB.6 = 1
		PORTA = e_segm
		portb_help = e_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.6 = 0
	'Записали в 3-е знакоместо букву c
		PORTB.5 = 1
		PORTA = c_segm
		PORTB.3 = 0
		PORTB.5 = 0
'Записали в 4-е знакоместо букву t
		PORTB.4 = 1
		PORTA = t_segm
		portb_help = t_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.4 = 0
		
	EndSelect
Return  'выполнение программы возращается обратно к месту откуда была вызван код


show_freq_signal:  'ссылка на которую может переходить выполнение программы
Dim digit As Byte
Dim portb_help As Byte  'переменная помогает правильному отобржанию значений на диодном индекаторе

'Записали в 1-е знакоместо
PORTB.7 = 1
PORTA = f_segm
portb_help = f_segm And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.7 = 0
PORTB.3 = 0

'Записали во 2-е знакоместо
digit = frequency / 100
PORTB.6 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.6 = 0
PORTB.3 = 0

'Записали в 3-е знакоместо
digit = frequency / 10 Mod 10
PORTB.5 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.5 = 0

'Записали в 4-е знакоместо
digit = frequency Mod 10
PORTB.4 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.4 = 0
PORTB.3 = 0
Return  'выполнение программы возращается обратно к месту откуда была вызван код


show_ampl_signal:  'ссылка на которую может переходить выполнение программы
Dim digit As Byte
Dim portb_help As Byte  'переменная помогает правильному отобржанию значений на диодном индекаторе

'Записали в 1-е знакоместо
PORTB.7 = 1
PORTA = a_segm
portb_help = a_segm And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.7 = 0
PORTB.3 = 0

'Записали во 2-е знакоместо
digit = amplituda / 100
PORTB.6 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.6 = 0
PORTB.3 = 0

'Записали в 3-е знакоместо
digit = amplituda / 10 Mod 10
PORTB.5 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.5 = 0

'Записали в 4-е знакоместо
digit = amplituda Mod 10
PORTB.4 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.4 = 0
PORTB.3 = 0

Return  'выполнение программы возращается обратно к месту откуда была вызван код



sin_mod:  'ссылка на которую может переходить выполнение программы
Dim y As Single
Dim step_y As Single
Dim wait_sin As Long
Dim event_sin_y As Single
y = 0
step_y = two_pi / amplituda
wait_sin = wait / (two_pi / step_y)
While y <= two_pi
	event_sin_y = Cos(y) * amplituda / 2
PORTC = abs(event_sin_y)
	y = y + step_y
	WaitMs wait_sin
Wend
Return  'выполнение программы возращается обратно к месту откуда была вызван код


ramp_mod:  'ссылка на которую может переходить выполнение программы
Dim wait_ramp As Long
Dim x As Byte  'переменная для for
wait_ramp = wait / amplituda
For x = 0 To amplituda Step 1
PORTC = amplituda - x
	WaitMs wait_ramp
Next x
Return  'выполнение программы возращается обратно к месту откуда была вызван код



pryamougol_mod:
Dim wait_rect As Long
wait_rect = wait / 2
PORTC = amplituda
WaitMs wait_rect
PORTC = 0
WaitMs wait_rect
Return  'выполнение программы возращается обратно к месту откуда была вызван код


Function abs(arg1 As Single) As Byte  'функция, которая уже возращает значение
Dim event As Long
event = arg1 + (amplituda / 2)
abs = event.LB  'передали в переменную LowBits (все биты от 0 до 4) 4 - 8 проигнорировали
End Function  'выполнение программы возращается обратно к месту откуда была вызван код





