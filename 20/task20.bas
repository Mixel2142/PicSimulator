'PIC16F876
'Open: Tools->Software UART Simulation Interface
'Open: Tools->7-Segment Led Displays
'Open: Tools-> Microcontroller View
' Change port A0
TRISC = %00000000 ' ��������� ��� 8 ������ C �� �����
TRISB = %00000000 ' ��������� ��� 8 ������ B �� �����
TRISA = %11111111 ' ��������� ��� 8 ������ A �� �����

PORTB = 0 ' ��� ����� B � ��������� ����������� ����
PORTC = %00000000 ' ��� ����� � � ��������� ����������� ����

Dim an0 As Word ' ������� ���������� ���� Word ��� ������ � �� ���������� � ����� �0
Dim voltage_uart As Single ' ������� ���������� ���� Single ��� ������������� �������� � ������ ���������� � UART (Singke)��� � ���������� ����� �������
Dim voltage_seg As Long   ' ������� ���������� ���� Long ��� ������������� ��������
Dim edinici As Byte ' ������� ���������� ���� Byte ��� ������������� �������� � ������ ���������� �� �������������� ��������� 
Dim desyatki As Byte ' ������� ���������� ���� Byte ��� ������������� �������� � ������ ���������� �� �������������� ��������� 

loop: ' goto ���������, ��� � �++

Adcin 0, an0 ' �������� �������� ����������� ����� �0 � ����������  an0

voltage_seg = an0 * 99 / 1023 ' �������� �������� ����� �0(0 - 1023) � ������ (0 - 99)
voltage_uart = an0 * 99 / 1023 ' �������� �������� ����� �0(0 - 1023) � ������ (0 - 99)


edinici = voltage_seg Mod 10 ' �������� �������. ������ 58 (5 - �������, 8 - �������)
desyatki = voltage_seg / 10 Mod 10 ' �������� �������. ������ 58 (5 - �������, 8 - �������)


PORTC = %00000010 ' ������ ���������� ������� �� ���� C1(� ��� ����� ���������� ���������� ��� ������ ��������)
PORTB = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), desyatki  ' LookUp - ������, � � ������� desyatki �������� ������ ������� �������
WaitMs 10 ' 0x3f ������������ 0b00111111 � �������� "0" �� ��������� 
PORTC = %00000100 ' ������ ���������� ������� �� ���� C2(� ��� ����� ���������� ���������� ��� ������ ������)
PORTB = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), edinici ' LookUp - ������, � � ������� edinici �������� ������ ������� �������
WaitMs 10
PORTC = %00001000 ' ������ ���������� ������� �� ���� C3(� ��� ����� ���������� ���������� ��� ����� V)
PORTB = %00111110 ' ���� B ��������� ������� �� ���������� ���������(�������� ������ ������� ��� ���������)


Serout PORTC.6, 9600, "����������:", #voltage_uart, " V" Lf ' �������� �������� ���������� � uart
' Lf - ��������� ������� �� ����� ������ � uart

WaitMs 100
Goto loop



