'PIC16F628
TRISB = 1

loop:
	If PORTB.0 Then
		PORTB.1 = 1
		WaitMs 100
		PORTB.1 = 0
		WaitMs 100
		PORTB.1 = 1
		WaitMs 100
		PORTB.1 = 0
		WaitMs 100
		PORTB.1 = 1
		WaitMs 100
		PORTB.1 = 0
		WaitMs 100
		PORTB.1 = 1
		WaitMs 100
		PORTB.1 = 0
		WaitMs 100
		PORTB.1 = 1
		WaitMs 100
		PORTB.1 = 0
		WaitMs 100
	Endif
Goto loop

