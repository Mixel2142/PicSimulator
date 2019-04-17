'PIC16F884
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0
'��������� LCD ������
'open Tools->Oscilloscope � ������ ������� �������� � ��������� ������� refresh !
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


TRISA = %11111111  '��� ����� � �� ���� (�������� ��� �� ���)
TRISD.0 = 0  '���� � ���� ����� ����������� �������� �������
PORTD.0 = 0  '���������� ���� �� �����

Dim longh As Word  '�������� ���������� ��� ������ � �� �������� �� ��� ����� �0
Dim an1 As Word  '�������� ���������� ��� ������ � �� �������� �� ��� ����� �1
Dim freq As Single  '�������� ���������� ��� ������ � �� �������� �� ��� ����� �0
Dim longl As Long

Lcdinit 1  '���������������� ������� �� ��� ������

loop:  '��������� ��� GOTO

Adcin 0, longh  '�������� �������� �� ��� � ����������
Adcin 1, an1  '�������� �������� �� ��� � ����������

Lcdcmdout LcdLine1Home  '����������� ������� �� 2 ������
Lcdout "LongH:", #longh, "ms"  '������ �� ��� ����� ������� � ��������� ����������

longl = longh - (an1 * longh / 1024)

Lcdcmdout LcdLine2Home  '����������� ������� �� 2 ������
Lcdout "LongL:", #longl, "ms"  '������ �� ��� ����� ������� � ��������� ����������

If longh > 0 And longl > 0 Then
freq = 1000 / (longh + longl)
Else
freq = 0
Endif

Lcdcmdout LcdLine3Home  '����������� ������� �� 2 ������
Lcdout "freq:", #freq, "Hz"  '������ �� ��� ����� ������� � ��������� ����������

If longh = 0 Then
WaitMs 100
Lcdcmdout LcdClear  '�������  LCD
Goto loop  '��������� �� ��������� loop
Endif

PORTD.0 = 1  '���������� 1 �� ����� � 0
WaitMs longh  '��������� an1 ������� (����������������� ��������)
PORTD.0 = 0  '���������� 0 �� ����� � 0
WaitMs longl  '��������� an0 ������� (���������� ����� ����������)

Lcdcmdout LcdClear  '�������  LCD

Goto loop  '��������� �� ��������� loop
