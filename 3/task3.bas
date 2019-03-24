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
TRISD.0 = 0  '���� � ���� ����� ����������� �������� �������
PORTD.0 = 0  '���������� ���� �� �����

Dim an0 As Word  '�������� ���������� ��� ������ � �� �������� �� ��� ����� �0
Dim an1 As Word  '�������� ���������� ��� ������ � �� �������� �� ��� ����� �1

Lcdinit 1  '���������������� ������� �� ��� ������

loop:  '��������� ��� GOTO

Adcin 0, an0  '�������� �������� �� ��� � ����������
Adcin 1, an1  '�������� �������� �� ��� � ����������

Lcdout "LongH:", #an1, "ms"  '������ �� ��� ����� ������� � ��������� ����������

Lcdcmdout LcdLine2Home  '����������� ������� �� 2 ������

Lcdout "LongL:", #an0, "ms"  '������ �� ��� ����� ������� � ��������� ����������

If an1 = 0 Then
WaitMs 100
Lcdcmdout LcdClear  '�������  LCD
Goto loop  '��������� �� ��������� loop
Endif

PORTD.0 = 1  '���������� 1 �� ����� � 0
WaitMs an1  '��������� an1 ������� (����������������� ��������)
PORTD.0 = 0  '���������� 0 �� ����� � 0
WaitMs an0  '��������� an0 ������� (���������� ����� ����������)

Lcdcmdout LcdClear  '�������  LCD

Goto loop  '��������� �� ��������� loop
