'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0
'��������� LCD ������
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


'Single - ���������� � ��������� ������

Dim power As Single  '��������

Dim resistance_r1 As Single  '������������� ��������� R1
resistance_r1 = 250  'Om
Dim voltage_r1 As Single  '���������� �� ��������� R1

Dim resistance_r2 As Single  '������������� ��������� R2
Dim voltage_r2 As Single  '���������� �� ��������� R2

TRISA = %11111111  '��������� ����� � �� ����
Dim an0 As Long  '���������� ��� ������ � ��� �0

Lcdinit 1  '������������� ������� �� LCD

loop:

Adcin 0, an0  '������ � ��� � ����������
voltage_r2 = 5 * an0 / 1024  '������ ���������� �� �2 5 - ���������� �������
Lcdout "Voltage:", #voltage_r2, " V"  '����� �� LCD �������� ����������

Lcdcmdout LcdLine2Home  '������� �� 2 �������
voltage_r1 = 5 - voltage_r2  '������ ���������� �� �1
resistance_r2 = voltage_r2 * resistance_r1 / voltage_r1  '������ ������������� �2
Lcdout "Resis:", #resistance_r2, " Om"  '����� �� LCD �������� �������������

Lcdcmdout LcdLine3Home  '������� �� 3 �������
power = 220 * 220 / resistance_r2
Lcdout "Power:", #power, "W"  '����� �� LCD �������� ��������


WaitMs 100
Lcdcmdout LcdClear  '�������  LCD

Goto loop
