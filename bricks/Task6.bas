'PIC16F84

TRISB.6 = 0
PORTB.6 = 1
TRISA.0 = 0  '�� ����� (������� �����)
INTCON = %10010000  '��������� ����� ����������

Enable
loop:
INTCON = %10010000
PORTB.6 = 0
WaitMs 50
PORTB.6 = 1
WaitMs 50
Goto loop
'����������� ����.
End                                               

Disable
On Interrupt
INTCON = $80
PORTA.0 = 1
WaitMs 100
PORTA.0 = 0
WaitMs 100
Resume                                            