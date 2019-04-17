'PIC16F876
'open Tools->LCD Module
'open Tools->Microcontroller View
'change analog Ra0





Symbol zaryadka = PORTC.0  '�������� � ��������� ������� ���.������ ���� ���� �� ���������
Gosub off_zaryadka

Symbol razryad = PORTC.4  '�������� � ��������� �������� ��� ����� ��������.'������ ���� ��� �� ���������
Gosub on_razryad

Symbol power = PORTC.5  '������ ��� ��������� ���������� � ������ ������� ���(����� ������� ���)


Dim mod_zaryadka As Bit  '�������� � ��������� ����� �������
mod_zaryadka = 0



TRISA = %11111111
PORTA = %00000000
TRISC = %11001110
PORTC = %00110000


'��������� LCD ������
Define LCD_BITS = 8
Define LCD_DREG = PORTB
Define LCD_DBIT = 0
Define LCD_RSREG = PORTC
Define LCD_RSBIT = 1
Define LCD_EREG = PORTC
Define LCD_EBIT = 3
Define LCD_RWREG = PORTC
Define LCD_RWBIT = 2

Dim voltage_akb As Single
Dim current_akb As Single

Dim vol As Word  '���������� ��� ������ ���������� ������� � AN0
Dim cur As Word  '���������� ��� ������ ���� ������� � AN1

Lcdinit 0




main:

	If power Then
			
			Adcin 0, vol  '����� �������� ���������� �� ���
			Adcin 1, cur  '����� �������� ���� �� ���
			
			voltage_akb = vol * 5 / 1023
			current_akb = cur * 5 / 1023
			
			Lcdout "Voltage: ", #voltage_akb, "V"
			Lcdcmdout LcdLine2Home
			Lcdout "Current: ", #current_akb, "A"
			
			
			If voltage_akb < 2.8 Then
				mod_zaryadka = 1
			Endif
			
			If voltage_akb > 4.2 Then
				mod_zaryadka = 0
			Endif
			
			
			

	Else  '����� ���������� � ����������� ���������
		Gosub off_zaryadka
		Gosub on_razryad
		
		
	Endif
	
	
'Adcin 0, an0

'Lcdout "Voltage: ", #an0, "mV"

'Lcdcmdout LcdLine2Home

'Lcdout "Capacity: ", #an0, "mah"

WaitMs 100
Lcdcmdout LcdClear

Goto main
End                                               

on_zaryadka:
zaryadka = 1
Return                                            


off_zaryadka:
zaryadka = 1
Return                                            


on_razryad:
razryad = 0
Return                                            

off_razryad:
razryad = 1
Return                                            









