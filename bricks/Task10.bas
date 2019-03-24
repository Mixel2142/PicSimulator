'PIC16F884
TRISB = 0
TRISD = 255

loop:
	PORTB = PORTD
	WaitMs 100
Goto loop

