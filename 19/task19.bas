'PIC16F876
'open Tools->7-Srgment LED Displays
'open Tools->Microcontroller View
'open Tools->Oscilloscope
'Simulation->start
'������� F1 ����� �������� ���������� � ����� Basic


TRISA = 0  '����� ����� � �� ����� '0'- output
PORTA = 255  '����� ����� � �� �������� ���������� �������
'� ������� ����� PORT� , ��� � - �������� �����, �� ����� ������������� ���������� ������ �� ��� (0 � 1)

TRISB = %00000111  '����� ����� B �� ����� '0'- output � "1" - input
PORTB = 0  '����� ����� B �� ��������� � ���������� ����

'���������� ���� Byte (0-255)
Dim f_segm As Byte  'f,a,s,i,n ��� ����������, ������� ������������ ��� ������ ���� �� 7-segment LED
f_segm = %01110001  '������ ���� % �������� ������ ����� � ������� ����

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

Dim mod_signal As Byte  '���������� ��� ������������ ����� ������� (�������� 255)
mod_signal = 2

Dim amplituda As Byte  '���������� ���������� �������� �������
amplituda = 100  '1 = 0.02 �����

Dim frequency As Byte  '���������� ���������� ������� �������
frequency = 100  '1 Hz �� 1 ��� � �������

Dim wait As Long  '���������� ���������� ������������ ������� �������
wait = 1000 / frequency

Dim two_pi As Single  '���������� ��� sin
two_pi = 2 * 3.141592

Dim act_change_mod As Byte
act_change_mod = 0

INTCON.INTE = 1  '�������� ���������� RB0/INT
INTCON.GIE = 1  '�������� ��� ����������

main:  '���������

	Gosub show_mod_signal  '�������� ��� � ��������� show_mod_signal

	Select Case mod_signal  '� ����������� �� ���� ������� ����� � ���������� ������ ������ ����������
	Case 0
		Gosub sin_mod  '�������� ��� � ��������� sin_mod
	Case 1
		Gosub ramp_mod  '�������� ��� � ��������� ramp_mod
	Case 2
		Gosub pryamougol_mod  '�������� ��� � ��������� pryamougol_mod
	EndSelect

	Goto main  '��������� �� ��������� main
End                                               

On Interrupt  '��������� ����������

While PORTB.0  '���� while ����� ����������� ���� �� ����� B0 ����� ���������� �������
	Select Case act_change_mod  '� ����������� �� �������� ���������� act_change_mod ���������� ������ CASE
	Case 0
		Gosub show_ampl_signal  '�������� ��� � ��������� show_ampl_signal
		'������ B2 � �1 ��������� ������� ��������� � ������� � ����������� �� ����, ��� ������������ �� ������� ����������
		If PORTB.2 Then
		amplituda = amplituda + 1  '���� ������ ������ B2, ����� �������� ������������� �� 1
		Endif
		If PORTB.1 Then
		amplituda = amplituda - 1  '���� ������ ������ B1, ����� �������� ����������� �� 1
		Endif
	Case 1
		Gosub show_freq_signal  '�������� ��� � ��������� show_freq_signal
		If PORTB.2 Then
		frequency = frequency + 1  '���� ������ ������ B2, ����� ������� ������������� �� 1
		Endif
		If PORTB.1 Then
		frequency = frequency - 1  '���� ������ ������ B1, ����� ������� ����������� �� 1
		Endif
	Case 2
		Gosub show_mod_signal  '�������� ��� � ��������� show_mod_signal
		If PORTB.2 Then  '����� ����� ������� ������ ��� ������� �� 3-� ������������
		mod_signal = mod_signal + 1
		Endif
		If PORTB.1 Then
		mod_signal = mod_signal - 1
		Endif
		If mod_signal > 2 Then
		mod_signal = 0
		Endif
	EndSelect
Wend  '����� ����� while
act_change_mod = act_change_mod + 1  '��������� ���� ���������� �������� � ��������� ���������� �� 7-segment ����������
If act_change_mod > 2 Then  '����������� �������� 3(����,�������, sin) act_change_mod ���������� � 0
act_change_mod = 0  '������������� ����� ���������� �� ������ ��������
Endif
Gosub show_mod_signal  '�������� ��� � ��������� show_mod_signal
INTCON.INTF = 0  '�������� ������ ���������� RB0/INT
Resume  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���

show_mod_signal:  '������ �� ������� ����� ���������� ���������� ���������
Dim portb_help As Byte  '���������� �������� ����������� ���������� �������� �� ������� ����������
PORTB = 0
Select Case mod_signal  '� Case-�� ���������� ����� ���������� � ���� ������� �� LED ���������
	Case 0
'�������� � 1-� ���������� ����� S
		PORTB.7 = 1
		PORTA = s_segm
		portb_help = s_segm And %01000000  'And ��� ��������� �������� ��������
		portb_help = ShiftRight(portb_help, 3)  'ShiftRight ������� �������� ����� � ���������� ������ �� 3 �������
		PORTB = PORTB Or portb_help  'Or ��� ��������� �������� ��������
		PORTB.7 = 0
'�������� �� 2-� ���������� ����� i
		PORTB.6 = 1
		PORTA = i_segm
		PORTB.3 = 0
		PORTB.6 = 0
'�������� � 3-� ���������� ����� n
		PORTB.5 = 1
		PORTA = n_segm
		portb_help = n_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.5 = 0
		PORTB.3 = 0
'�������� � 4-� ���������� ������
		PORTB.4 = 1
		PORTA = 0
		PORTB.3 = 0
		PORTB.4 = 0
		
	Case 1
	'�������� � 1-� ���������� ����� p
		PORTB.7 = 1
		PORTA = p_segm
		portb_help = p_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.7 = 0
	'�������� �� 2-� ���������� ����� i
		PORTB.6 = 1
		PORTA = i_segm
		PORTB.3 = 0
		PORTB.6 = 0
	'�������� � 3-� ���������� ����� l
		PORTB.5 = 1
		PORTA = l_segm
		PORTB.3 = 0
		PORTB.5 = 0
'�������� � 4-� ���������� ����� a
		PORTB.4 = 1
		PORTA = a_segm
		portb_help = a_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.4 = 0

	Case 2
	'�������� � 1-� ���������� ����� r
		PORTB.7 = 1
		PORTA = r_segm
		portb_help = r_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.7 = 0
	'�������� �� 2-� ���������� ����� e
		PORTB.6 = 1
		PORTA = e_segm
		portb_help = e_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.6 = 0
	'�������� � 3-� ���������� ����� c
		PORTB.5 = 1
		PORTA = c_segm
		PORTB.3 = 0
		PORTB.5 = 0
'�������� � 4-� ���������� ����� t
		PORTB.4 = 1
		PORTA = t_segm
		portb_help = t_segm And %01000000
		portb_help = ShiftRight(portb_help, 3)
		PORTB = PORTB Or portb_help
		PORTB.4 = 0
		
	EndSelect
Return  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���


show_freq_signal:  '������ �� ������� ����� ���������� ���������� ���������
Dim digit As Byte
Dim portb_help As Byte  '���������� �������� ����������� ���������� �������� �� ������� ����������

'�������� � 1-� ����������
PORTB.7 = 1
PORTA = f_segm
portb_help = f_segm And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.7 = 0
PORTB.3 = 0

'�������� �� 2-� ����������
digit = frequency / 100
PORTB.6 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.6 = 0
PORTB.3 = 0

'�������� � 3-� ����������
digit = frequency / 10 Mod 10
PORTB.5 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.5 = 0

'�������� � 4-� ����������
digit = frequency Mod 10
PORTB.4 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.4 = 0
PORTB.3 = 0
Return  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���


show_ampl_signal:  '������ �� ������� ����� ���������� ���������� ���������
Dim digit As Byte
Dim portb_help As Byte  '���������� �������� ����������� ���������� �������� �� ������� ����������

'�������� � 1-� ����������
PORTB.7 = 1
PORTA = a_segm
portb_help = a_segm And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.7 = 0
PORTB.3 = 0

'�������� �� 2-� ����������
digit = amplituda / 100
PORTB.6 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.6 = 0
PORTB.3 = 0

'�������� � 3-� ����������
digit = amplituda / 10 Mod 10
PORTB.5 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.5 = 0

'�������� � 4-� ����������
digit = amplituda Mod 10
PORTB.4 = 1
PORTA = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
portb_help = portb_help And %01000000
portb_help = ShiftRight(portb_help, 3)
PORTB = PORTB Or portb_help
PORTB.4 = 0
PORTB.3 = 0

Return  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���



sin_mod:  '������ �� ������� ����� ���������� ���������� ���������
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
Return  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���


ramp_mod:  '������ �� ������� ����� ���������� ���������� ���������
Dim wait_ramp As Long
Dim x As Byte  '���������� ��� for
wait_ramp = wait / amplituda
For x = 0 To amplituda Step 1
PORTC = amplituda - x
	WaitMs wait_ramp
Next x
Return  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���



pryamougol_mod:
Dim wait_rect As Long
wait_rect = wait / 2
PORTC = amplituda
WaitMs wait_rect
PORTC = 0
WaitMs wait_rect
Return  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���


Function abs(arg1 As Single) As Byte  '�������, ������� ��� ��������� ��������
Dim event As Long
event = arg1 + (amplituda / 2)
abs = event.LB  '�������� � ���������� LowBits (��� ���� �� 0 �� 4) 4 - 8 ���������������
End Function  '���������� ��������� ����������� ������� � ����� ������ ���� ������ ���





