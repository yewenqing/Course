
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "HashTable.h"

bool areSimilarStrings(char *s1, char *s2);

int main(int argc, char *argv[]) {
	if (argc != 3) {
		fprintf(stderr, "usage: %s <string 1> <string 2>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	bool result = areSimilarStrings(argv[1], argv[2]);
	printf("The strings %s similar\n", result ? "are" : "are not");
	return EXIT_SUCCESS;
}

// !!! DO NOT MODIFY THE CODE ABOVE !!!
////////////////////////////////////////////////////////////////////////
// Your task

/**
 * Returns true if two strings are similar, and false otherwise. Two strings s1
 * and s2 are similar if, for each character in s1, it is possible to *uniquely*
 * replace it by another character (possibly itself) such that, after all
 * replacements are done to s1, we end up with s2. For example, the strings
 * "adt" and "bst" are similar, but "adt" and "dcc" are not.
 */
bool areSimilarStrings(char *s1, char *s2) {
	if (strlen(s1) != strlen(s2)) return false;
	
	// TODO: Complete this function!
    HashTable map1 = HashTableNew();
    HashTable map2 = HashTableNew();

    for (int i = 0; s1[i] != '\0'; i++) {
        int c1 = (int)s1[i];
        int c2 = (int)s2[i];

        if (HashTableContains(map1, c1)) {
            if (HashTableGet(map1, c1) != c2) {
                HashTableFree(map1);
                HashTableFree(map2);
                return false;
            }
        } else {
            HashTableInsert(map1, c1, c2);
        }

        if (HashTableContains(map2, c2)) {
            if (HashTableGet(map2, c2) != c1) {
                HashTableFree(map1);
                HashTableFree(map2);
                return false;
            }
        } else {
            HashTableInsert(map2, c2, c1);
        }
    }

    HashTableFree(map1);
    HashTableFree(map2);
    return true;
	
	
}

