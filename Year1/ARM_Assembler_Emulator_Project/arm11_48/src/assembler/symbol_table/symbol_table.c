#include <stdbool.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "symbol_table.h"

static symbol_table_entry_t * alloc_entry(void) {

	symbol_table_entry_t *entry = malloc(sizeof(symbol_table_entry_t));

	if (entry == NULL) {
		perror("Unable to allocate memory for a new symbol_table_entry_t.");
		exit(EXIT_FAILURE);
	}

	return entry;
}

static symbol_table_entry_t * new_entry(char *label, int address) {
	symbol_table_entry_t *entry = alloc_entry();

	entry->label = label;
	entry->address = address;
	entry->next = NULL;

	return entry;
}

static void free_symbol_table_entry(symbol_table_entry_t *entry) {
	free(entry);
}  

void symbol_table_init(symbol_table_t *table) {
	table->size = 0;
	table->head = alloc_entry();
}

/*
// For debugging purposes.
static void print_table(symbol_table_t *table) {
	for (int i = 0; i < table->size; i++) {
		symbol_table_entry_t *current_entry = table->head->next;
		printf("%d. label: %s, address: %d\n", (i + 1), current_entry->label, current_entry->address); 
	}
}
*/

bool add_entry(symbol_table_t *table, char *label, int address){
	char *label_str = malloc(strlen(label));
	strncpy(label_str, label, strlen(label));

	symbol_table_entry_t *current_entry = table->head;	
	symbol_table_entry_t *successor_entry = current_entry->next; 

	while(successor_entry) {
		if (strncmp(successor_entry->label, label_str, strlen(label_str)) == 0) {
			// Label already present in the symbol_table.
			return false;
		}
		current_entry = successor_entry;
		successor_entry = successor_entry->next;
	}

	assert(successor_entry == NULL);
	successor_entry = new_entry(label_str, address);
	current_entry->next = successor_entry;
	table->size = table->size + 1;
	return true;
}

int get_address(symbol_table_t *table, char *label) {

	if (table->size == 0) {
		printf("Attempt to get an address from an empty table.");
		exit(EXIT_FAILURE);
	}

	symbol_table_entry_t *current_entry = table->head->next;

	while(current_entry) {
		if (strcmp(current_entry->label, label) == 0) {
			return current_entry->address;
		}
		current_entry = current_entry->next;
	}
	
	printf("No such label in the symbol table.");
	exit(EXIT_FAILURE);
}

void table_destroy(symbol_table_t *table) {
	symbol_table_entry_t *current_entry = table->head;

	while(current_entry) {
		symbol_table_entry_t *next_entry = current_entry->next;
		free_symbol_table_entry(current_entry);
		current_entry = next_entry;
	}

	free(table);
}
