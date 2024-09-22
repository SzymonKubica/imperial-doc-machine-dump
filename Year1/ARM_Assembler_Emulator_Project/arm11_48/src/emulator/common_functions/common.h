#ifndef COMMON_H
#define COMMON_H

byte_t get_First_Nibble(byte_t byte);

byte_t get_Second_Nibble(byte_t byte); 

word_t shifter(byte_t shiftType, byte_t shiftAmount, word_t word, bit_t *carry);

byte_t parse_binary(char *str);

word_t parse_binary_word(char *str);

#endif
