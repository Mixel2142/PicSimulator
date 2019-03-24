'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0
'��������� LCD ������
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTD
Define LCD_RSBIT = 1
Define LCD_EREG = PORTD
Define LCD_EBIT = 3
Define LCD_RWREG = PORTD
Define LCD_RWBIT = 2

TRISA = %11111111  '��� ����� � �� ���� (�������� ��� �� ���)

Dim power As Single  '���������� �������
power = 5  'voltage
Dim an0 As Long  '�������� ���������� ��� ������ � �� �������� �� ��� ����� �0
Dim voltage_vd As Single  '���������� �� �����

Lcdinit 1  '���������������� ������� �� ��� ������

loop:  '��������� ��� GOTO
	Adcin 0, an0  '�������� �������� �� ��� � ����������
	voltage_vd = power * an0 / 1024  '������ ���������� �� �����
	Lcdout "voltage:", #voltage_vd, "V"  '������ �� ��� ����� ������� � ��������� ����������
	Lcdcmdout LcdLine2Home  '����������� ������� �� 2 ������

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
	Lcdcmdout LcdClear  '�������  LCD
Goto loop  '��������� �� ��������� loop
