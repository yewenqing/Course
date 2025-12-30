// COMP2521 25T3 - Assignment 1

#ifndef MSET_STRUCTS_H
#define MSET_STRUCTS_H

// IMPORTANT: Only structs should be placed in this file.
//            All other code (e.g., function prototypes) should be
//            placed in Mset.c.

// DO NOT MODIFY THE NAME OF THIS STRUCT
struct mset {
	struct node *tree;  // DO NOT MODIFY/REMOVE THIS FIELD
	int size;
	int totalCount;

	// You may add more fields here if needed
};

// DO NOT MODIFY THE NAME OF THIS STRUCT
struct node {
	int elem;           // DO NOT MODIFY/REMOVE THIS FIELD
	int count;          // DO NOT MODIFY/REMOVE THIS FIELD
	struct node *left;  // DO NOT MODIFY/REMOVE THIS FIELD
	struct node *right; // DO NOT MODIFY/REMOVE THIS FIELD
	int height;
	int size;
	// You may add more fields here if needed
};

// You may define more structs here if needed

////////////////////////////////////////////////////////////////////////
// Cursors

struct cursor {
	// You may add more fields here if needed
};

// IMPORTANT: Only structs should be placed in this file.
//            All other code (e.g., function prototypes) should be
//            placed in Mset.c.

////////////////////////////////////////////////////////////////////////

#endif

