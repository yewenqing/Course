// COMP2521 25T3 - Assignment 1
// Implementation of the Multiset ADT

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "Mset.h"
#include "MsetStructs.h"

////////////////////////////////////////////////////////////////////////
// Basic Operations
static void	 MsetFreeHelper(struct node *n);
// static int MsetInsertHelper(struct node *n, int elem);
static struct node *newNode(int elem);
//static int MsetInsertManyHelper(struct node *n, int elem, int amount);
static struct node *MsetFindHelper(struct node *n, int elem);
// static struct node **findNodePtr(struct node **rootPtr, int elem);
static void MsetPrintHelper(struct node *n, FILE *file, bool *first);
static void copyTree(struct node *n, Mset result);
static void unionWith(struct node *n, Mset result);
static void MsetSetCount(Mset s, int elem, int newCount);
static void intersectionWith(struct node *n, Mset s2, Mset result);
static int min(int a, int b);

static void MsetIncludedHelper(struct node *n, Mset s2, bool *b);
static void MsetEqualsHelper(struct node *n, Mset s2, bool *b);
static void MsetInsertManyBalance(Mset s, int elem, int amount);
static int MsetInsertManyBalanceHelper(struct node **n, int elem, int amount);
static struct node *rotateRight(struct node *n);
static struct node *rotateLeft(struct node *n);
static int height(struct node *n);
static int max(int a, int b);	
static void MsetDeleteManyBalance(Mset s, int elem, int amount);
static struct node *rebalance(struct node *n);
static struct node *deleteNode(struct node* n, int elem, int amount, Mset s);
static int size(struct node *n);
static void reSize(struct node *n);
static struct item MsetAtIndexHelper(struct node *n, int index);
static int MsetIndexOfHelper(struct node *n, int elem, int index);
/**
 * Creates a new empty multiset.
 */
Mset MsetNew(void) {
	// TODO
    Mset m = malloc(sizeof(struct mset));
    if (m == NULL) {
        fprintf(stderr, "error: failed to allocate Mset\n");
        exit(EXIT_FAILURE);
    }

    // 
    m->tree = NULL;
	m->size = 0;
	m->totalCount = 0;

    return m;

}



/**
 * Frees all memory allocated to the multiset.
 */
void MsetFree(Mset s) {
	// TODO
	MsetFreeHelper(s->tree);
	free(s);
}
static void	 MsetFreeHelper(struct node *n) {
    if (n == NULL) return;

    MsetFreeHelper(n->left);
    MsetFreeHelper(n->right);

    free(n);
}

/**
 * Inserts one of an element into the multiset. Does nothing if the
 * element is equal to UNDEFINED.
 */
void MsetInsert(Mset s, int elem) {
	// TODO
	MsetInsertMany(s, elem, 1);
	return;
}

//create a new node
static struct node *newNode(int elem) {
    struct node *n = malloc(sizeof(struct node));
    if (n == NULL) {
        fprintf(stderr, "error: failed to allocate node\n");
        exit(EXIT_FAILURE);
    }

    // 
	n->elem = elem;
	n->count = 1;
    n->left = NULL;
	n->right = NULL;
	n->height = 0;
	n->size = 1;

    return n;	
}

//return the size of a node, if null return 0
static int size(struct node *n) {
	return n ? n->size : 0;
}

// calculate size of nodes in tree
static void reSize(struct node *n) {
	if (!n) return;
	reSize(n->left);
	reSize(n->right);
	n->size = 1 + size(n->left) + size(n->right);
	return;

}





/**
 * Inserts the given amount of an element into the multiset. Does
 * nothing if the element is equal to UNDEFINED or the given amount is 0
 * or less.
 */




void MsetInsertMany(Mset s, int elem, int amount) {
	MsetInsertManyBalance(s, elem, amount);
}
	


//return the height of node, if null return 0
static int height(struct node *n) {
    return n ? n->height : 0;
}

// return the greater int in 2 int
static int max(int a, int b) {
    return (a > b) ? a : b;
}

//rotate return new root
static struct node* rotateRight(struct node *y) {
    struct node *x = y->left;
    struct node *T2 = x->right;

    x->right = y;
    y->left = T2;

    y->height = 1 + max(height(y->left), height(y->right));
    x->height = 1 + max(height(x->left), height(x->right));

    return x;
}

static struct node* rotateLeft(struct node *x) {
    struct node *y = x->right;
    struct node *T2 = y->left;

    y->left = x;
    x->right = T2;

    x->height = 1 + max(height(x->left), height(x->right));
    y->height = 1 + max(height(y->left), height(y->right));

    return y;
}



static int MsetInsertManyBalanceHelper(struct node **n, int elem, int amount) {
    if (!(*n)) {
        (*n) = newNode(elem);
        (*n)->count = amount;
        (*n)->height = 1;  // 
        return 1;          // 
    }

    int inserted = 0;

    if (elem == (*n)->elem) {
        (*n)->count += amount;
        return 0;
    } else if (elem < (*n)->elem) {
        inserted = MsetInsertManyBalanceHelper(&((*n)->left), elem, amount);
    } else {
        inserted = MsetInsertManyBalanceHelper(&((*n)->right), elem, amount);
    }

    // update height
    (*n)->height = 1 + max(height((*n)->left), height((*n)->right));

    // check balance
    int balance = height((*n)->left) - height((*n)->right);

    // totate if unbalance 
    if (balance > 1 && elem < (*n)->left->elem) {
        // LL
        *n = rotateRight(*n);
    } else if (balance < -1 && elem > (*n)->right->elem) {
        // RR
        *n = rotateLeft(*n);
    } else if (balance > 1 && elem > (*n)->left->elem) {
        // LR
        (*n)->left = rotateLeft((*n)->left);
        *n = rotateRight(*n);
    } else if (balance < -1 && elem < (*n)->right->elem) {
        // RL
        (*n)->right = rotateRight((*n)->right);
        *n = rotateLeft(*n);
    }

    return inserted;
}






static void MsetInsertManyBalance(Mset s, int elem, int amount) {
    if (!(s->tree)) {
        s->tree = newNode(elem);
        s->tree->count = amount;
        s->tree->height = 1;
        s->totalCount = amount;
        s->size = 1;


        return;
    } else {
        s->size += MsetInsertManyBalanceHelper(&(s->tree), elem, amount);
        s->totalCount += amount;
    }


}



/**
 * Deletes one of an element from the multiset.
 */
void MsetDelete(Mset s, int elem) {
	// TODO
	MsetDeleteMany(s, elem, 1);

}










static struct node *MsetFindHelper(struct node *n, int elem) {
	// printf("MsetFindHelper\n");
	if (n == NULL) return NULL;
	// printf("n->elem: %d\n", n->elem);
	if (elem == n->elem) return n;
	if (elem < n->elem) return MsetFindHelper(n->left, elem);
	if (elem > n->elem) return MsetFindHelper(n->right, elem);
	return NULL;
}




/**
 * Deletes the given amount of an element from the multiset.
 */

 void MsetDeleteMany(Mset s, int elem, int amount) {
	MsetDeleteManyBalance(s, elem, amount);	
 }


//balance a node
static struct node *rebalance(struct node *n) {
    int balance = height(n->left) - height(n->right);

    // LL
    if (balance > 1 && height(n->left->left) >= height(n->left->right))
        return rotateRight(n);

    // LR
    if (balance > 1 && height(n->left->left) < height(n->left->right)) {
        n->left = rotateLeft(n->left);
        return rotateRight(n);
    }

    // RR
    if (balance < -1 && height(n->right->right) >= height(n->right->left))
        return rotateLeft(n);

    // RL
    if (balance < -1 && height(n->right->right) < height(n->right->left)) {
        n->right = rotateRight(n->right);
        return rotateLeft(n);
    }

    return n;
}

static struct node *deleteNode(struct node *n, int elem, int amount,  Mset s) {
    if (!n) return NULL;

    if (elem < n->elem) {
        n->left = deleteNode(n->left, elem, amount, s);
    } else if (elem > n->elem) {
        n->right = deleteNode(n->right, elem, amount, s);
    } else {
		// node find
		// elem == n->elem
        if (n->count > amount) {
			// noneed to delete node
            n->count -= amount;
            s->totalCount -= amount;
            return n;
        }

		// need to delete node
        s->totalCount -= n->count;
        s->size--;

        if (!n->left) {
            struct node *r = n->right;
            free(n);
            return r;
        } else if (!n->right) {
            struct node *l = n->left;
            free(n);
            return l;
        } else {
            // find Successor node
            struct node *succ = n->right;
            while (succ->left) succ = succ->left;

            n->elem = succ->elem;
            n->count = succ->count;
            n->right = deleteNode(n->right, succ->elem, succ->count, s);
        }
    }

    // update height
    n->height = 1 + max(height(n->left), height(n->right));

    // rebalance and return new root
    return rebalance(n);
}


static void MsetDeleteManyBalance(Mset s, int elem, int amount) {
    if (!s->tree) return;
    s->tree = deleteNode(s->tree, elem, amount, s);
}



/**
 * Returns the number of distinct elements in the multiset.
 */
int MsetSize(Mset s) {
	// TODO
	// printf("MsetSize: %d\n", s->size);
	return s->size;
}

/**
 * Returns the sum of counts of all elements in the multiset.
 */
int MsetTotalCount(Mset s) {
	// TODO
	// printf("MsetTotalCount: %d\n", s->totalCount);
	return s->totalCount;
}

/**
 * Returns the count of an element in the multiset, or 0 if it doesn't
 * occur in the multiset.
 */
int MsetGetCount(Mset s, int elem) {
	// TODO

	struct node *n = MsetFindHelper(s->tree, elem);
	if (n == NULL) {

		return 0;
	}
	else {

		return n->count;
	}
}

/**
 * Prints the multiset to a file.
 * The elements of the multiset should be printed in ascending order
 * inside a pair of curly braces, with elements separated by a comma
 * and space. Each element should be printed inside a pair of
 * parentheses with its count, separated by a comma and space.
 */
void MsetPrint(Mset s, FILE *file) {
	// TODO
	bool first = true;
	fprintf(file,"{");
	MsetPrintHelper(s->tree, file, &first);
	fprintf(file, "}");

}

static void MsetPrintHelper(struct node *n, FILE *file, bool *first) {
	if (n == NULL) return;
	MsetPrintHelper(n->left, file, first);
	if ((*first) == false) {
		fprintf(file, ", ");
	}
	(*first) = false;
	fprintf(file, "(%d, %d)", n->elem, n->count);
	
	MsetPrintHelper(n->right, file, first);
	return;
	
}

////////////////////////////////////////////////////////////////////////
// Advanced Operations

/**
 * Returns a new multiset representing the union of the two given
 * multisets.
 */

Mset MsetUnion(Mset s1, Mset s2) {
	// TODO
	Mset result = MsetNew();
	copyTree(s1->tree, result);     
	unionWith(s2->tree, result);   
	return result;
}

static void copyTree(struct node *n, Mset result) {
	if (n == NULL) return;
	MsetInsertMany(result, n->elem, n->count);
	copyTree(n->left, result);
	copyTree(n->right, result);
}

static void unionWith(struct node *n, Mset result) {
	if (n == NULL) return;
	int countInResult = MsetGetCount(result, n->elem);
	if (countInResult < n->count) {
		// replace if b has greater count 
		MsetSetCount(result, n->elem, n->count);
	}
	unionWith(n->left, result);
	unionWith(n->right, result);
}


// set node count into a new count, if node do not excist then create a node
static void MsetSetCount(Mset s, int elem, int newCount) {

	struct node *n = MsetFindHelper(s->tree, elem);
	if (n) {
		if (newCount >= n->count) {
			MsetInsertMany(s, elem, (newCount-n->count));
			return;
		} else {
			MsetDeleteMany(s, elem, (n->count-newCount));
		}

		
	}
	
	else{
		MsetInsertMany(s, elem, newCount);
	}
	
}

/**
 * Returns a new multiset representing the intersection of the two
 * given multisets.
 */
Mset MsetIntersection(Mset s1, Mset s2) {
	// TODO
	Mset result = MsetNew();
	intersectionWith(s1->tree, s2, result);
  
	return result;
}

// return the min of 2 int
static int min(int a, int b) {
	if (a >= b) return b;
	else return a;
}

// intersection help function
static void intersectionWith(struct node *n, Mset s2, Mset result) {
	if (!n) return;
	int countInS2 = MsetGetCount(s2, n->elem);
	// if both in s1 and s2, insert min value to result
	if (countInS2 > 0) {
		MsetInsertMany(result, n->elem, min(countInS2, n->count));
	}
	intersectionWith(n->left, s2, result);
	intersectionWith(n->right, s2, result);
}
/**
 * Returns true if the multiset s1 is included in the multiset s2, and
 * false otherwise.
 */
bool MsetIncluded(Mset s1, Mset s2) {
	// TODO
	bool b = true;
	MsetIncludedHelper(s1->tree, s2, &b);
	return b;
}

// iniclude help function
static void MsetIncludedHelper(struct node *n, Mset s2, bool *b) {
	// TODO
	if (!n) return;
	int countInS2 = MsetGetCount(s2, n->elem);
	if (countInS2 < n->count) {
		(*b) = false;
		return;
	}
	MsetIncludedHelper(n->left, s2, b);
	MsetIncludedHelper(n->right, s2, b);
	return;
}
/**
 * Returns true if the two given multisets are equal, and false
 * otherwise.
 */
bool MsetEquals(Mset s1, Mset s2) {																		
	// TODO
	bool b = true;
	MsetEqualsHelper(s1->tree, s2, &b);
	return b;
}

// equals help function
static void MsetEqualsHelper(struct node *n, Mset s2, bool *b) {
	// TODO
	if (!n) return;
	int countInS2 = MsetGetCount(s2, n->elem);
	if (countInS2 != n->count) {
		(*b) = false;
		return;
	}
	MsetEqualsHelper(n->left, s2, b);
	MsetEqualsHelper(n->right, s2, b);
	return;
}
////////////////////////////////////////////////////////////////////////
// Index Operations

/**
 * Returns the element at the given index and its count, or
 * {UNDEFINED, 0} if the given index is outside the range [0, n - 1]
 * where n is the size of the multiset.
 */
struct item MsetAtIndex(Mset s, int index) {
	// TODO
	reSize(s->tree);

	return MsetAtIndexHelper(s->tree, index);
}


static struct item MsetAtIndexHelper(struct node *n, int index) {
	if (!n) return (struct item){UNDEFINED, 0};
	int leftSize = size(n->left);
    if (index < leftSize) {
        return MsetAtIndexHelper(n->left, index);
    } else if (index == leftSize) {
        return (struct item){n->elem, n->count};
    } else {
        return MsetAtIndexHelper(n->right, index - leftSize - 1);
    }
}

/**
 * Returns the index of the given element if it exists, or -1 otherwise.
 */
int MsetIndexOf(Mset s, int elem) {
	// TODO
	reSize(s->tree);
	int result = MsetIndexOfHelper(s->tree, elem, 0);

	return result;
}

static int MsetIndexOfHelper(struct node *n, int elem, int index) {
	if (!n) return -1;
	if (elem == n->elem) return index + size(n->left);;
	if (elem < n->elem ) {
		int result = MsetIndexOfHelper(n->left, elem, index);
		if (result < 0) return -1;
		else return result;
	}
	if (elem > n->elem ) {
		index = index + 1 + size(n->left);
		int result = MsetIndexOfHelper(n->right, elem, index);
		if (result < 0) return -1;
		else return result;
	}	
	return -1;
}
////////////////////////////////////////////////////////////////////////
// Cursor Operations

/**
 * Creates a new cursor positioned at the start of the multiset.
 * (see spec for explanation of start and end)
 */
MsetCursor MsetCursorNew(Mset s) {
	// TODO
	return NULL;
}

/**
 * Frees all memory allocated to the given cursor.
 */
void MsetCursorFree(MsetCursor cur) {
	// TODO
}

/**
 * Returns the element at the cursor's position and its count, or
 * {UNDEFINED, 0} if the cursor is positioned at the start or end of
 * the multiset.
 */
struct item MsetCursorGet(MsetCursor cur) {
	// TODO
	return (struct item){UNDEFINED, 0};
}

/**
 * Moves the cursor to the next greatest element, or to the end of the
 * multiset if there is no next greatest element. Does not move the
 * cursor if it is already at the end. Returns false if the cursor is at
 * the end after this operation, and true otherwise.
 */
bool MsetCursorNext(MsetCursor cur) {
	// TODO
	return false;
}

/**
 * Moves the cursor to the next smallest element, or to the start of the
 * multiset if there is no next smallest element. Does not move the
 * cursor if it is already at the start. Returns false if the cursor is
 * at the start after this operation, and true otherwise.
 */
bool MsetCursorPrev(MsetCursor cur) {
	// TODO
	return false;
}

////////////////////////////////////////////////////////////////////////

