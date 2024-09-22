#include <assert.h>
#include <stdio.h>

#include "gpio.h"
#include "common.h"

/*
 * General Purpose Input/Output (GPIO) Module: implementation.
 */

bool is_GPIO_address(word_t Rn) {
	return (Rn == GPIO_00_09) || (Rn == GPIO_10_19) || (Rn == GPIO_20_29);
}

void print_GPIO_access_message(word_t Rn) {
	char *ranges[3] = {"0 to 9", "10 to 19", "20 to 29"};
	char *range;

	switch (Rn) {
		case GPIO_00_09:
			range = ranges[0];
			break;
		case GPIO_10_19:
			range = ranges[1];
			break;
		case GPIO_20_29:
			range = ranges[2];
			break;
  }

	printf("One GPIO pin from %s has been accessed\n", range);

}

enum pin_function {input, output};

static enum pin_function from_binary_to_pin_function(nibble_t code) {
	switch(code) {
		case 0: 
			return input;
		case 1: 
			return output;
		default:
			// Error: Shold never be reached.
			return -1;
	}
}


static void write_to_GPIO_memory_at(
	word_t address, 
	word_t word, 
	byte_t *GPIO_memory) 
{
	for (int i = 0; i < 4; i++) {
		GPIO_memory[address + i] = word;
		word >>= 8;
	}
}

static word_t read_from_GPIO_memory_at(word_t address, byte_t *GPIO_memory) {
	word_t word;
	for (int i = 3; i >= 0; i--) {
		word = word << 8;
		word |= GPIO_memory[address + i];
	}
	return word;
}

void initialise_GPIO_pins(byte_t *GPIO_memory) {

	/*
	 * As outlined in the spec, each GPIO memory address
	 * should contain the value of the address. 
	 * We need to initialise these addresses with the correct values.
	 */

	 write_to_GPIO_memory_at(GPIO_00_09_shifted, GPIO_00_09, GPIO_memory);

	 write_to_GPIO_memory_at(GPIO_10_19_shifted, GPIO_10_19, GPIO_memory);

	 write_to_GPIO_memory_at(GPIO_20_29_shifted, GPIO_20_29, GPIO_memory);
}


static enum pin_function get_pin_function(int pin_number, byte_t *GPIO_memory) {

	nibble_t pin_code;
	// Each pin has its function specified by 3 bits, 
	// so we shift 3 times the last digit of pin_number to get to its region.
	int pin_offset = 3 * (pin_number % 10);
	word_t mask = 0x7 /* 111 */ << pin_offset;
	word_t pin_range;

	word_t GPIO_addresses[3] = {
		GPIO_00_09_shifted, 
		GPIO_10_19_shifted, 
		GPIO_20_29_shifted
	};

	word_t pin_address;

	if (0 <= pin_number && pin_number<= 9) {

		pin_address = GPIO_addresses[0];

	} else if (10 <= pin_number && pin_number <= 19) {

		pin_address = GPIO_addresses[1];

	} else if (20 <= pin_number && pin_number <= 29) {

		pin_address = GPIO_addresses[2];
	}

	pin_range = read_from_GPIO_memory_at(pin_address, GPIO_memory);
		
	pin_code = (pin_range & mask) >> pin_offset;

	return from_binary_to_pin_function(pin_code);
}

void set_pin_function(word_t location, word_t value, byte_t *GPIO_memory) {
	// We need to shift the GPIO_memory address to access the emulated GPIO_memory.
	location -= 0x20200000;
  word_t past_value = read_from_GPIO_memory_at(location, GPIO_memory);
	write_to_GPIO_memory_at(location, (past_value | value), GPIO_memory);
}

static int get_pin_number(word_t shifted_pin) {
	int counter = -1;
	while(shifted_pin) {
		counter++;
		shifted_pin = shifted_pin >> 1;
	}
	return counter;
}

void clear_pin(word_t shifted_pin, byte_t *GPIO_memory) {
	assert(get_pin_function(get_pin_number(shifted_pin), GPIO_memory) == output);
	
	// Setting a bit in clear area corresponding to the pin number clears the pin.
	write_to_GPIO_memory_at(GPIO_clearing_shifted, shifted_pin, GPIO_memory);

	printf("PIN OFF\n");
}

void set_pin(word_t shifted_pin, byte_t *GPIO_memory) {
	assert(get_pin_function(get_pin_number(shifted_pin), GPIO_memory) == output);
	
	// Setting a bit in set area corresponding to the pin number sets the pin.
	write_to_GPIO_memory_at(GPIO_setting_shifted, shifted_pin, GPIO_memory);

	printf("PIN ON\n");
}
