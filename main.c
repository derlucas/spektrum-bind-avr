/* vim:fdm=marker ts=4 */
#include <avr/io.h>
#include <util/delay.h>

void wait(uint8_t count) {
	uint8_t i;
	if(count == 0) count = 100;
	for(i=0;i<count;i++) {
		_delay_ms(10);
	}
}

int main(void) {
	DDRD |= _BV(PD1);  //PD1 led
	DDRD &= ~(_BV(PD0));		// Pin as input
	PORTD &= ~(_BV(PD0));		// Pullups off

	PORTD &= ~_BV(PD1); // LED aus

	_delay_ms(10);

	PORTD |= _BV(PD1); // LED an
	
	while( !(PIND & _BV(PD0)) ) {
		// NOP
	}
	
	PORTD &= ~_BV(PD1); // LED aus
	DDRD |= _BV(PD0);
	
	// 5 Impulse mit 125uS low und 125uS high senden
	// (fur einige Sat-RX, muss man auch 6 oder 7 Impulse senden)
	
	uint8_t i = 0;

	for(i = 0; i < 4; ++i) {
		PORTD &= ~_BV(PD0);
		_delay_us(125);
		PORTD |= _BV(PD0);
		_delay_us(125);
  }

	while(1) {
		PORTD |= _BV(PD1); // LED an
		_delay_ms(200);
		PORTD &= ~_BV(PD1); // LED aus
		_delay_ms(200);
	}
	return(0);
}
