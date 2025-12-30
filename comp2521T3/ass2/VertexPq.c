// Implementation of a priority queue of edges

// !!! DO NOT MODIFY THIS FILE !!!

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "Graph.h"
#include "VertexPq.h"

#define DEFAULT_CAPACITY 64

struct pq {
	struct vertexDist *items;
	int size;
	int capacity;
};



static void fixUp(Pq pq, int i);
static void fixDown(Pq pq, int i);
static void swap(struct vertexDist *items, int i, int j);

Pq PqNew(void) {
	Pq pq = malloc(sizeof(*pq));
	if (pq == NULL) {
		fprintf(stderr, "Couldn't allocate Pq!\n");
		exit(EXIT_FAILURE);
	}
	
	pq->items = malloc((DEFAULT_CAPACITY + 1) * sizeof(struct vertexDist));
	if (pq->items == NULL) {
		fprintf(stderr, "Couldn't allocate Pq!\n");
		exit(EXIT_FAILURE);
	}
	
	pq->size = 0;
	pq->capacity = DEFAULT_CAPACITY;
	return pq;
}

void PqFree(Pq pq) {
	free(pq->items);
	free(pq);
}

void PqInsert(Pq pq, struct vertexDist vd) {
	// If the Pq is full, expand it (i.e., double its capacity)
	if (pq->size == pq->capacity) {
		pq->capacity *= 2;
		pq->items = realloc(
			pq->items,
			(pq->capacity + 1) * sizeof(struct vertexDist)
		);
		if (pq->items == NULL) {
			fprintf(stderr, "Couldn't expand Pq!\n");
			exit(EXIT_FAILURE);
		}
	}
	
	// Add the new item to the end
	pq->size++;
	pq->items[pq->size] = vd;
	fixUp(pq, pq->size);
}

static void fixUp(Pq pq, int i) {
	while (i > 1 && pq->items[i].distance < pq->items[i / 2].distance) {
		swap(pq->items, i, i / 2);
		i = i / 2;
	}
}

struct vertexDist PqExtract(Pq pq) {
	assert(pq->size > 0);
	
	struct vertexDist vd = pq->items[1];
	pq->items[1] = pq->items[pq->size];
	pq->size--;
	fixDown(pq, 1);
	return vd;
}

static void fixDown(Pq pq, int i) {
	struct vertexDist *vds = pq->items;
	while (true) {
		int j = i;
		int l = 2 * i;
		int r = 2 * i + 1;
		if (l <= pq->size && vds[l].distance < vds[j].distance) j = l;
		if (r <= pq->size && vds[r].distance < vds[j].distance) j = r;
		if (j == i) break;
		swap(pq->items, i, j);
		i = j;
	}
}

bool PqIsEmpty(Pq pq) {
	return (pq->size == 0);
}

void PqShow(Pq pq) {
	printf("#items = %d\n", pq->size);
	printf("Items:");
	for (int i = 1; i <= pq->size; i++) {
		printf(" (v: %d, distance: %d)",
		       pq->items[i].v, pq->items[i].distance);
	}
	printf("\n");
}

////////////////////////////////////////////////////////////////////////

static void swap(struct vertexDist *items, int i, int j) {
	struct vertexDist tmp = items[i];
	items[i] = items[j];
	items[j] = tmp;
}
