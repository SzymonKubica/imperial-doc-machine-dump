#include <stdbool.h>

struct symbol_table_entry;

typedef struct symbol_table {
	int size;
	struct symbol_table_entry *head;
} symbol_table_t;

typedef struct symbol_table_entry {
	char *label;
	int address;
	struct symbol_table_entry *next;
} symbol_table_entry_t;

void symbol_table_init(symbol_table_t *table);

bool add_entry(symbol_table_t *table, char *label, int address);

int get_address(symbol_table_t *table, char *label);

void table_destroy(symbol_table_t *table);
